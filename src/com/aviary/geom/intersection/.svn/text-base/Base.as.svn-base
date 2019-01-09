
package com.aviary.geom.intersection
{
	import com.aviary.collections.PathIterator;
	import com.aviary.geom.path.Curve3Segment;
	import com.aviary.geom.path.IPath;
	import com.aviary.geom.path.ISegment;
	import com.aviary.geom.path.LineSegment;
	import com.aviary.geom.path.Path;
	import com.aviary.geom.utils.Point2D;
	import com.aviary.sdk.core.IIterator;
	import com.aviary.utils.UserDict;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Base
	{
		public static const PRECISION: int = 100000;
		
		/**
		 * 
		 * @return an array of ApproxPathPoint
		 */
		internal static function approximate_path( path: IPath, threshold: Number = 1.0  ): Array
		{
			var buffer: Array = [];
			//var last: Point = path.closed ? path.getSegmentAt( 0 ).end : path.firstSegment.end;
			var last: Point = path.startPoint;
			
			var iter: IIterator = new PathIterator( path );
			var i: int = 0;
			while( iter.next )
			{
				var segment: ISegment = iter.current as ISegment;
				if( segment is Curve3Segment )
				{
					for each( var ret: Array in subdivide_curve( last, Curve3Segment( segment ).curveHandle1.point, Curve3Segment( segment ).curveHandle2.point, segment.end, threshold ) )
					{
						buffer.push( new ApproxPathPoint( ret[0] as Point, i - 1.0 + ret[ 1 ] ) );
					}
					buffer.push( new ApproxPathPoint( segment.end, i ) );
				} else if ( segment is LineSegment )
				{
					buffer.push( new ApproxPathPoint( segment.end, i ) );
				}
				last = segment.end;
				i++;
			}
			return buffer;
		}
		
		internal static function subdivide_curve( p0: Point, p1: Point, p2: Point, p3: Point, threshold: Number = 1.0, r: Array = null ): Array
		{
			var buffer: Array = [];
			var p10: Point, p11: Point, p12: Point, p20: Point, p21: Point, p30: Point, t: Number;
			if( r == null )
				r = [0,1];
			
			p10 = new Point( subdivide( p0.x, p1.x ), subdivide( p0.y, p1.y ) );
			p11 = new Point( subdivide( p1.x, p2.x ), subdivide( p1.y, p2.y ) );
			p12 = new Point( subdivide( p2.x, p3.x ), subdivide( p2.y, p3.y ) );
			p20 = new Point( subdivide( p10.x, p11.x ), subdivide( p10.y, p11.y ) );
			p21 = new Point( subdivide( p11.x, p12.x ), subdivide( p11.y, p12.y ) );
			p30 = new Point( subdivide( p20.x, p21.x ), subdivide( p20.y, p21.y ) );
			t = subdivide( r[ 0 ], r[ 1 ] );
			
			if( distance( p0.x - p30.x, p0.y - p30.y) > threshold )
				buffer = buffer.concat( subdivide_curve( p0, p10, p20, p30, threshold, [ r[ 0 ], t ] ) );
				
			buffer.push( [ p30, t ] );
			
			if( distance( p30.x - p3.x, p30.y - p3.y) > threshold )
				buffer = buffer.concat( subdivide_curve( p30, p21, p12, p3, threshold, [ t, r[ 1 ] ] ) );
				
			return buffer;
		}
		
		internal static function subdivide( m: Number, n: Number, t: Number = 0.5 ): Number
		{
			return m + t * (n - m);
		}
		
		internal static function distance( x: Number, y: Number ): Number
		{
			 return Math.sqrt( x * x + y * y );
		}
		
		internal static function coord_rect( points: Array ): Rectangle
		{
			var p: Point = ( points[ 0 ] as ApproxPathPoint ).point;
			var x1: Number, x2: Number, y1: Number, y2: Number;
			
			x1 = x2 = p.x;
			y1 = y2 = p.y;
			
			for( var i: int = 0; i < points.length; i++ )
			{
				p  = ( points[ i ] as ApproxPathPoint).point;
				x1 = Math.min( x1, p.x );
				x2 = Math.max( x2, p.x );
				y1 = Math.min( y1, p.y );
				y2 = Math.max( y2, p.y );
			}
			return new Rectangle( x1, y1, x2 - x1, y2 - y1 );		
		}
		
		internal static function findIntersection( p1: Point, p2: Point, p3: Point, p4: Point): Point
		{
			var xD1: Number, yD1: Number, xD2: Number, yD2: Number, xD3: Number, yD3: Number;  
			var dot: Number, deg: Number, len1: Number, len2: Number;  
			var segmentLen1: Number,segmentLen2: Number;  
			var ua: Number,ub: Number,div: Number;  
			
			xD1=p2.x-p1.x;
			xD2=p4.x-p3.x;
			yD1=p2.y-p1.y;
			yD2=p4.y-p3.y;
			xD3=p1.x-p3.x;
			yD3=p1.y-p3.y;
	
			// calculate the lengths of the two lines  
			len1 = Math.sqrt( xD1 * xD1 + yD1 * yD1 );  
			len2 = Math.sqrt( xD2 * xD2 + yD2 * yD2 );  
	
			// calculate angle between the two lines.  
			dot = ( xD1 * xD2 + yD1 * yD2 ); // dot product  
			deg = dot / ( len1 * len2 );
	
			// if abs(angle)==1 then the lines are parallell,  
			// so no intersection is possible  
			if( Math.abs( deg ) == 1 ) return null;  
	
			// find intersection Pt between two lines  
			var pt: Point = new Point( 0, 0 );  
			div = yD2 * xD1 - xD2 * yD1;
			ua = ( xD2 * yD3 - yD2 * xD3 ) / div;
			ub = ( xD1 * yD3 - yD1 * xD3 ) / div;
			pt.x = p1.x + ua * xD1;
			pt.y = p1.y + ua * yD1;
	
			// calculate the combined length of the two segments  
			// between Pt-p1 and Pt-p2  
			xD1 = pt.x - p1.x;  
			xD2 = pt.x - p2.x;  
			yD1 = pt.y - p1.y;  
			yD2 = pt.y - p2.y;  
			segmentLen1 = Math.sqrt( xD1 * xD1 + yD1 * yD1 ) + Math.sqrt( xD2 * xD2 + yD2 * yD2 );  
	
			// calculate the combined length of the two segments  
			// between Pt-p3 and Pt-p4  
			xD1 = pt.x - p3.x;  
			xD2 = pt.x - p4.x;  
			yD1 = pt.y - p3.y;  
			yD2 = pt.y - p4.y;  
			segmentLen2 = Math.sqrt( xD1 * xD1 + yD1 * yD1 ) + Math.sqrt( xD2 * xD2 + yD2 * yD2 );  
	
			// if the lengths of both sets of segments are the same as  
			// the lenghts of the two lines the point is actually  
			// on the line segment.  
			
			// if the point isn’t on the line, return null  
			if( Math.abs( len1 - segmentLen1 ) > 0.01 || Math.abs( len2 - segmentLen2 ) > 0.01 )
			  return null;
			
			// return the valid intersection  
			return pt;
		}
		
		internal static function index( cp: Point, p0: Point, t0: Number, p1: Point, t1: Number ): Number
		{
			if( ( p1.x - p0.x ) == 0 )
				return subdivide(t0, t1, (cp.y - p0.y) / (p1.y - p0.y));
			else
				return subdivide(t0, t1, (cp.x - p0.x) / (p1.x - p0.x));
		}
		
		internal static function equal( a: Point, b: Point ): Boolean
		{
			return round( a.x, PRECISION ) == round( b.x, PRECISION ) && round( a.y, PRECISION ) == round( b.y, PRECISION );
		}
		
		internal static function round( value: Number, precision: Number ): Number
		{
			return Math.round( value * precision ) / precision;
		}
		
		public static function copy_path( dest: IPath, src: IPath, start: int = 0, end: int = -1 ): void
		{
			if( start < 0 )
				start = src.length + start;
				
			if( end < 0 )
				end = src.length + end;
				
			for( var i: int = start; i < end + 1; i++ )
			{
				var segment: ISegment = src.getSegmentAt( i );
				dest.addSegment( segment.clone() as ISegment );
			}
			
			if( src.closed && end == src.length - 1 )
			{
				dest.addSegment( src.getSegmentAt( 0 ).clone() as ISegment );
			} 
		}		
		
		internal static function split_path_at( path: IPath, at: Number ): Array
		{
			var pt1: Point;
			var pt2: Point;
			var q: Point;
			var path1: IPath;
			var path2: IPath;
			var result: Array;
			var index: int = Math.floor( at );
			var t: Number = at - index;
			var fn: Function;
			var args: Array;
			
			if( path.closed )
			{
				path1 = path2 = new Path( );
				result = [ path1 ];
			} else 
			{
				path1 = new Path( );
				path2 = new Path( );
				result = [ path1, path2 ];
				copy_path( path1, path, 0, 0 )
			}
			
			var segment: ISegment = path.getSegmentAt( index + 1 );
			
			if( segment is LineSegment )
			{
				pt1 = Point2D.multiply( path.getSegmentAt( index ).end, 1 - t );
				pt2 = Point2D.multiply( segment.end, t );
				q   = pt1.add( pt2 ); 
				path2.lineTo( q.x, q.y );
				path2.lineTo( segment.end.x, segment.end.y );
				fn = path1.lineTo;
				args = [q.x, q.y];
			} else
			{
				pt1 = ( segment as Curve3Segment ).curveHandle1.point;
				pt2 = ( segment as Curve3Segment ).curveHandle2.point;
				
				var arr: Array = Curve3Segment.subdivide( path.getSegmentAt( index ).end, pt1, pt2, segment.end, t );
				var p1: Point = arr[ 0 ];
				var p2: Point = arr[ 1 ];
				q = arr[ 2 ];
				var p3: Point = arr[ 3 ];
				var p4: Point = arr[ 4 ];
				
				path2.lineTo( q.x, q.y );
				path2.curve3To( p3.x, p3.y, p4.x, p4.y, segment.end.x, segment.end.y );
				fn = path1.curve3To;
				args = [p1.x, p1.y, p2.x, p2.y, q.x, q.y];
			}
			
			copy_path( path2, path, index + 2 );
			copy_path( path1, path, 1, index );
			
			fn.apply( path1, args );
			return result			
		}
		
		/**
		 * 
		 * @param paths	array of paths
		 */
		internal static function split_paths( paths: Array, index_table: UserDict ): Array
		{
			var buffer: Array = [];
			var path: IPath;
			
			for each( var i: int in index_table.keys() )
			{
				var segments: Array = ( index_table.get_value( i ) as UserDict ).keys( );
				segments.sort( );
				var first: Point = null;
				var last: Point = null;
				for( var j: int = 0; j < segments.length; j++ )
				{
					var segment: Number = segments[ j ];
					
					for each( var temp: Array in ( index_table.get_value( i ) as UserDict ).get_value( segment ) )
					{
						var index: Number = temp[0] + segment;
						var cp: Point = temp[1] as Point;
						
						if( j > 0 && segment > 0 )
						{
							index = index - segments[j - 1]
						}
						
						var result: Array = split_path_at( paths[ i ], index );
						
						if( ( paths[i] as IPath ).closed )
						{
							paths[ i ] = result[ 0 ];
							first = cp;
						} else
						{
							paths[ i ] = result[ 1 ];
							path = tidy( result[ 0 ] );
							
							if( path.length > 1 )
							{
								buffer.push( [ last, path, cp ] );
							}
						}
						segment = 0;
						last = cp;
					}
				}
				path = tidy( paths[ i ] );
				
				if( path.length > 1 )
					buffer.push( [ last, path, first ] );
			}
			return buffer;
		}
		
		/**
		 * remove redundant node at the end of the path
		 * 
		 */
		internal static function tidy( path: IPath ): IPath
		{
			if( path.length > 1 )
			{
				var segment: ISegment = path.getSegmentAt( path.length - 1 );
				if( equal( segment.end, path.getSegmentAt( path.length - 2 ).end ) )
				{
					var new_path: IPath = new Path( );
					for( var i: uint = 0; i < path.length - 1; i++ )
					{
						new_path.addSegment( path.getSegmentAt( i ).clone() as ISegment );
					}
					path = new_path;
				}
			}
			return path;
		}		
		
		// ---------------------------
		// PATH INTERSECTIONS
		// ---------------------------
		
		/**
		 * 
		 * @param objects	Array of paths
		 * @param threshold	Accuracy ( less value is more accuracy )
		 * 
		 */
		public static function intersect_paths( objects: Array, threshold: Number = 1.0 ): IntersectionResult
		{
			var approx_paths: Array = [];
			var approx_path: Array;
			var path: IPath;
			var partials: Array;
			var index1: Number;
			var index2: Number;
			var j: int;
			var i: int;
			
			var __temp__:Array = [];
			
			for( j = 0; j < objects.length; j++ )
			{
				path = objects[ j ] as IPath;
				approx_path = approximate_path( path, threshold );
				if( approx_path.length < 2 )
					continue;
					
				partials = [];
				
				for( var k: uint = 0; k < approx_path.length; k += 10)
				{
					var partial: Array = approx_path.slice( k, k + 11 );
					partials.push( new ApproxPath( j, partial, coord_rect( partial ) ) );
				}
				
				if( partials[ partials.length - 1 ] == 1 )
				{
					partial = partials.pop( );
					partials[ partials.length - 1] = ( partials[ partials.length - 1 ] as Array ).concat( partial );
				}
				
				approx_paths.push( partials );
			}

			var table: IntersectionIndex = new IntersectionIndex( );
			
			for( i = 0; i < approx_paths.length; i++ )
			{
				for( j = i + 1; j <  approx_paths.length; j++ )
				{
					for each( var object1: ApproxPath in approx_paths[ i ] )
					{
						for each( var object2: ApproxPath in approx_paths[ j ] )
						{
							if( object1.rect.intersects( object2.rect ) )
							{
								for( var p: int = 1; p <  object1.points.length; p++ )
								{
									var _ar: Array = object1.points.slice( p - 1, p + 1 );
									
									if( _ar.length < 2 )
										continue;
									
									var p0: Point = ( _ar[ 0 ] as ApproxPathPoint ).point;
									var p1: Point = ( _ar[ 1 ] as ApproxPathPoint ).point;
									var t0: Number = ( _ar[ 0 ] as ApproxPathPoint ).t;
									var t1: Number = ( _ar[ 1 ] as ApproxPathPoint ).t;
									
									for( var q: int = 1; q < object2.points.length; q++ )
									{
										var _ar2: Array = object2.points.slice( q - 1, q + 1 );
										
										if( _ar2.length < 2 )
											continue;
										
										var p2: Point = ( _ar2[ 0 ] as ApproxPathPoint ).point;
										var p3: Point = ( _ar2[ 1 ] as ApproxPathPoint ).point;
										var t2: Number = ( _ar2[ 0 ] as ApproxPathPoint ).t;
										var t3: Number = ( _ar2[ 1 ] as ApproxPathPoint ).t;
										var cp: Point;

										if( equal( p0, p2 ) )
										{
											cp = p0;
										}
										else if ( equal( p0, p3 ) || equal( p1, p2 ) || equal( p1, p3 ) )
										{
											cp = null;
										}
										else
										{
											cp = findIntersection( p0, p1, p2, p3 );
										}
										if( cp != null )
										{
											__temp__.push( cp );
											index1 = index( cp, p0, t0, p1, t1 );
											index2 = index( cp, p2, t2, p3, t3 );
											table.add( object1.path_index, index1, cp );
											table.add( object2.path_index, index2, cp );
										}
									}
								}
							}
						}
					}
				}
			}
			
			table.adjust( );
			
			var new_paths: Array;
			//new_paths = [[ 0, split_paths( objects, table.path_table ) ]];
			
			var untouched_paths: Array = new Array( );
			for( j = 0; j <  objects.length; j++ )
			{
				if( !table.path_table.has_key( j ) )
				{
					untouched_paths.push( [ 0, objects[ j ] ] );
				}
			}
			return new IntersectionResult( new_paths, untouched_paths, __temp__, approx_paths );
		}
	}
}
