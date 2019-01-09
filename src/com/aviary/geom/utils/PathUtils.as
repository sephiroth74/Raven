package com.aviary.geom.utils
{
	import com.aviary.collections.PathIterator;
	import com.aviary.core.errors.AssertionError;
	import com.aviary.core.utils.assertTrue;
	import com.aviary.geom.path.Curve3Segment;
	import com.aviary.geom.path.IPath;
	import com.aviary.geom.path.ISegment;
	import com.aviary.geom.path.LineSegment;
	import com.aviary.geom.path.Path;
	import com.aviary.sdk.core.IIterator;
	
	import flash.geom.Point;
	
	import it.sephiroth.gettext._;
	
	public class PathUtils
	{
		
		public static function open( path: IPath, segment: ISegment ): void
		{
			assertTrue( path.closed, _("Only closed path can be opened") );
			assertTrue( path.getSegmentIndex( segment ) > -1, _("Segment does not exists in the current path") );
			
			var s_index: int = path.getSegmentIndex( segment );
			var new_segment: ISegment = segment.prev;
			
			path.open( s_index );
			path.addSegmentBefore( path.firstSegment, segment.clone( ) as ISegment );
		}
		
        public static function split( path: IPath, to_index: uint ): IPath
        {
        	assertTrue( !path.closed, _("Path must be opened") );
        	
        	var new_path: IPath = new Path( );
        	var last_segment: ISegment = path.getSegmentAt( to_index );
        	var first_segment: ISegment = path.firstSegment;
        	var index: int;
        	
        	assertTrue( last_segment != null && last_segment != first_segment, _("Invalid segment") );
        	assertTrue( last_segment != path.lastSegment, _("Invalid segment") );
        	
        	while( first_segment != last_segment )
        	{
        		index = path.getSegmentIndex( first_segment );
        		new_path.addSegment( first_segment.clone( ) as ISegment );
        		first_segment = first_segment.next;
        		path.removeSegmentAt( index );
        	}
        	new_path.addSegment( first_segment.clone( ) as ISegment );
        	return new_path;
        }
        
        public static function splitSegment( path: IPath, segment: ISegment, position: Number = 0.5 ): ISegment
        {
        	assertTrue( path.getSegmentIndex( segment ) > -1, _("Invalid segment. Segment is not part of the path") );
        	assertTrue( segment is LineSegment || segment is Curve3Segment, _("Invalid segment") );
        	
        	var new_segment: ISegment;
        	
        	if( segment is LineSegment )
        	{
				var pt: Point = segment.getLerp( position );
				new_segment = new LineSegment( pt.x, pt.y );
				path.addSegmentAfter( segment.prev, new_segment );        		
        	} else if( segment is Curve3Segment )
        	{
        		var t: Number = position;
        		var s: Number = 1 - t;
				var csegment: Curve3Segment = ( segment as Curve3Segment );
				
				var f000: Point = csegment.start.clone( );
				var f111: Point = csegment.end.clone( );
				var f001: Point = csegment.curveHandle1.point.clone( );
				var f011: Point = csegment.curveHandle2.point.clone( );
				
	            var f00t: Point = new Point( s * f000.x + t * f001.x, s * f000.y + t * f001.y );
	            var f01t: Point = new Point( s * f001.x + t * f011.x, s * f001.y + t * f011.y );
	            var f11t: Point = new Point( s * f011.x + t * f111.x, s * f011.y + t * f111.y );
	            var f0tt: Point = new Point( s * f00t.x + t * f01t.x, s * f00t.y + t * f01t.y );
	            var f1tt: Point = new Point( s * f01t.x + t * f11t.x, s * f01t.y + t * f11t.y );
	            var fttt: Point = new Point( s * f0tt.x + t * f1tt.x, s * f0tt.y + t * f1tt.y );
	            
	            new_segment = new Curve3Segment(0, 0, 0, 0, 0, 0);
	            ( new_segment as Curve3Segment ).curveHandle1.setPoint( f00t, false );
	            ( new_segment as Curve3Segment ).curveHandle2.setPoint( f0tt, false );
	            ( new_segment as Curve3Segment ).controlHandle.setPoint( fttt, false );
	            
	            csegment.curveHandle1.setPoint( f1tt, false );
	            csegment.curveHandle2.setPoint( f11t, false );

	            ( new_segment as Curve3Segment ).updateFactors( );
	            csegment.updateFactors( );
	            
	            ( path as Path ).addSegmentAfter( segment.prev, new_segment );
	            path.updateSegment( segment );
        	}
        	return new_segment;
        }
		
		public static function clone( path: IPath ): IPath
		{
			return PathUtils.fromString( PathUtils.toString( path ) );
		}
		
		
		/**
		 * Given a path returns a string which represent
		 * the path itself
		 * 
		 */
		public static function toString( path: IPath ): String
		{
			var str: String = "path(";
			var iter: IIterator = new PathIterator( path );
			while( iter.next )
			{
				str += ( iter.current as ISegment ).toString( );
				str += ",";
			}
			
			if( path.closed )
				str += "c,";
			
			str += ")";
			
			return str;
		}
		
		/**
		 * Create a new path starting from a string
		 * 
		 * @throws AssertionError
		 */
		public static function fromString( str: String ): IPath
		{
			var result: Object = new RegExp( /^path\((.+)*\)$/ ).exec( str );
			
			assertTrue( result is Array && ( result as Array ).length == 2, _("String does not contain a valid path") );
			
			var content: String = result[1] as String;
			var segments: Array = content.match( /((line|move|curve2|curve3)\([^\)]+\)),|(c),/img );

			assertTrue( segments && segments.length > 0, _("Path is empty"));
			
			var values: Array;
			var path: IPath = new Path( );
			
			while( segments.length > 0 )
			{
				var current: String = segments.shift( ) as String;
				var r: Array = current.match( /(line|curve2|curve3|move)\((.+)\),|(c),/ ); 
				
				if( r[1] == "line" )
				{
					values = ( r[2] as String ).split(",");
					path.lineTo( parseFloat( values[0] ), parseFloat( values[1] ) );
				} else if( r[1] == "move" )
				{
					values = ( r[2] as String ).split(",");
					path.moveTo( parseFloat( values[0] ), parseFloat( values[1] ) );
				} else if( r[1] == "curve3" )
				{
					values = ( r[2] as String ).split(",");
					path.curve3To( parseFloat( values[0] ), parseFloat( values[1] ), parseFloat( values[2] ), parseFloat( values[3] ), parseFloat( values[4] ), parseFloat( values[5] ) );
				} else if( r[0] == "c," )
				{
					assertTrue( segments.length == 0, _("Cannot close path at this point!"));
					path.close( );
				} else 
				{
					throw new AssertionError( _("Given segment string is invalid!") );
				}
			}
			
			return path;
		}			
	}
}