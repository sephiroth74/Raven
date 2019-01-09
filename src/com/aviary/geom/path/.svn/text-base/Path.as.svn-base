///////////////////////////////////////////////////////////
//	$Id:Path.as 295 2008-04-30 17:19:26Z alessandro $
//	Revision: $Rev:350 $
//	$LastChangedBy:alessandro $
//  Created on:      01-Apr-2008 8:09:27 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////

package com.aviary.geom.path
{
	import __AS3__.vec.Vector;
	
	import com.aviary.collections.PathIterator;
	import com.aviary.core.services.logger.Logger;
	import com.aviary.core.utils.assertTrue;
	import com.aviary.events.SegmentEvent;
	import com.aviary.geom.Shape;
	import com.aviary.geom.controls.IHandle;
	import com.aviary.geom.ext.FlattenPath;
	import com.aviary.geom.ext.FlattenPathCache;
	import com.aviary.raven.utils.ObjectId;
	import com.aviary.sdk.core.IIterator;
	import com.aviary.sdk.storage.eggfile.EGGAttributeFactory;
	import com.aviary.sdk.storage.eggfile.EGGNode;
	import com.aviary.sdk.storage.eggfile.IEGGAttribute;
	import com.aviary.sdk.storage.eggfile.IEGGNode;
	import com.aviary.sdk.storage.eggfile.attributes.AttributeTypes;
	import com.aviary.sdk.storage.eggfile.attributes.LazyAttribute;
	import com.aviary.sdk.storage.eggfile.attributes.StringAttribute;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;
	
	import it.sephiroth.gettext._;
	
	public class Path extends Shape implements IPath
	{
		protected var _segments: Vector.<ISegment>;
		protected var _pathid: ObjectId;
		protected var _closed: Boolean;
		protected var _winding: String = GraphicsPathWinding.NON_ZERO;

		public function Path( )
		{
			_segments = new Vector.<ISegment>( );
			_pathid   = new ObjectId( );
			_closed   = false;
			
			_commands = new Vector.<int>( );
			_data = new Vector.<Number>( );
		}

		public function get winding():String
		{
			return _winding;
		}

		public function set winding(v:String):void
		{
			_winding = v;
			eggNode.setAttribute( new StringAttribute( "path:winding", v ) );
		}

		public override function get allowMultipleHandleSelection( ): Boolean
		{
			return true;
		}

		/**
		 * Return the current path's ObjectId, this will be used for cache the path
		 * 
		 */
		public function get pathId(): ObjectId
		{
			return _pathid;
		}

		
		// test
		
		public function moveTo( x: Number, y: Number ): ISegment
		{
			var segment: ISegment = new MoveSegment( x, y );
			addSegment( segment );
			return segment;
		}
		
		// test

	    public function lineTo( x: Number, y: Number ): ISegment
		{
			var segment: ISegment = new LineSegment( x, y );
			addSegment( segment );
			return segment;	
		}

	    public function curveTo( cx: Number, cy: Number, x: Number, y: Number ): ISegment
		{
			var segment: ISegment = new CurveSegment( cx, cy, x, y );
			addSegment( segment );
			return segment;
		}

	    public function curve3To( cx1: Number, cy1: Number, cx2: Number, cy2: Number, x: Number, y: Number): ISegment
		{
			var segment: ISegment = new Curve3Segment( cx1, cy1, cx2, cy2, x, y );
			addSegment( segment );
			return segment;	  
		}

		[Deprecated]
		public function start( x: Number, y: Number ): ISegment
		{
			return lineTo( x, y );
		}

		/**
		 * get the segment at position
		 * if the path is closed pos can be negavite
		 */
	    public function getSegmentAt( pos: int ): ISegment
		{
			if( pos >= 0 )
			{
				return _segments[ pos ];
			} else {
				return _segments[ _segments.length + pos ];
			}
			return null;
		}

	    public function getSegmentIndex( value: ISegment ): int
		{
			return _segments.indexOf( value );
		}
		
		public function hasSegment( value: ISegment ): Boolean
		{
			return _segments.indexOf( value ) > -1;
		}

		[Bindable]
		/**
		 * return the current path segments count
		 *
		 */
	    public function get length( ): uint
		{
			return _segments.length;
		}

		public function set length( value: uint ): void
		{
		}


		/**
		 * Close the current path (if opened)
		 * 
		 */
		public function close( ): void
		{
			assertTrue( !closed, _("Path is already closed!") );

			var last_segment: ISegment   = lastSegment;
			var first_segment: ISegment  = firstSegment;
			
			assertTrue( last_segment && first_segment, _("Possible corrupted path. Cannot find the 2 endpoints") );
			assertTrue( last_segment != first_segment, _("Last segment cannot be the same as the first segment") );
			
			last_segment.next  = first_segment;
			first_segment.prev = last_segment;
			
			updateSegment( first_segment );
			updateSegment( last_segment );
			
			invalidate( );
		}
		
		public function open( index: int = 0 ): void
		{
			var last_segment: ISegment = getSegmentAt( index );
			assertTrue( closed, _("Path is already opened") );
			assertTrue( !last_segment.isEndSegment, _("You must select a non end point to complete this action.") );

			var current_next_segment: ISegment = last_segment.next;
			
			last_segment.next.prev = null;
			last_segment.next = null;
			
			
			var iter: IIterator = new PathIterator( this, current_next_segment );
			var tmp_segments: Vector.<ISegment> = new Vector.<ISegment>( );
			
			while( iter.next )
			{
				tmp_segments.push( iter.current as ISegment );
			}
			
			_segments = tmp_segments;
			
			invalidate( );
		}
		
		/**
		 * Return the last segment in the current path
		 * which does not have a next associated segment
		 * 
		 */
		private function getLastBreakSegment( index: int = 0 ): ISegment
		{
			var iter: IIterator = new PathIterator( this );
			var segment: ISegment;
			
			while( iter.next )
			{
				segment = iter.current as ISegment;
				if( !iter.hasNext() )
				{
					return segment;
				}
			}
			
			return null;
		}
		
		/**
		 * Return the first segment in the current path
		 * which does not have a next associated segment
		 * 
		 */
		private function getFirstBreakSegment( index: int = 0 ): ISegment
		{
			for each( var segment: ISegment in this._segments )
			{
				if( segment.prev == null )
				{
					return segment;
				}
			}
			return null;
		}		
		
		/**
		 * Get the real last segment in the path
		 * 
		 */
		public function get lastSegment( ): ISegment
		{
			if( closed )
				return null;
			else
				return this.getLastBreakSegment( );
		}
		
		
		public function get firstSegment( ): ISegment
		{
			if( closed )
				return null;
			else
				return this.getFirstBreakSegment( );
		}


		public function get closed( ): Boolean
		{
			return _closed;
		}

		[Deprecated]
		public function set closed( value: Boolean ): void
		{
			Logger.log('Attribute closed is now deprecated, use close() instead', 'WARNING');
		}

		/**
		 * Return the path start position
		 * used for path rendering
		 */
		public function get startPoint( ): Point
		{
			return closed ? getSegmentAt( 0 ).start : getFirstBreakSegment( ).end;
		}


		public function get segments( ): Vector.<ISegment>
		{
			return _segments.concat( );
		}


		
		/**
		 * Check if there are 2 consecutive movesegments and remove one of them
		 * if found, adjusting the first one to the end of the second
		 * 
		 */
		protected function checkConsecutiveMoveSegments( index: int ): void
		{
			if( index > -1 )
			{
				var segment: ISegment = _segments[ index ];
				
				if( segment is MoveSegment )
				{
					if( segment.next && segment.next is MoveSegment )
					{
						segment.end.x = segment.next.end.x;
						segment.end.y = segment.next.end.y;
						removeSegmentAt( getSegmentIndex( segment.next ) );
					}
					
					if( segment.prev && segment.prev is MoveSegment )
					{
						segment.prev.end.x = segment.end.x;
						segment.prev.end.y = segment.end.y;
						removeSegmentAt( getSegmentIndex( segment ) );
					}
				}
			}
		}
		
		private function getCommandIndexAt( value: int ): int
		{
			var ret: int = 0;
			for( var a: int = 0; a < value; a++ )
			{
				ret += getSegmentAt( a ).commands.length;
			}
			return ret;
		}
		
		private function getDataIndexAt( value: int ): int
		{
			var ret: int = 0;
			for( var a: int = 0; a < value; a++ )
			{
				ret += getSegmentAt( a ).data.length;
			}
			return ret;
		}		
		
		/**
		 * Add a new segment to the end of the path
		 *
		 */
	    public function addSegment( value: ISegment ): void
	    {
	    	//if( length == 0 && !( value is MoveSegment ) )
	    	//	addSegmentAfter( null, new MoveSegment( value.end.x, value.end.y ) );
			addSegmentAfter( length > 0 ? _segments[ length - 1 ] : null, value );
	    }
		
		/**
		 * Add a new segment after the passed segment in the path
		 * 
		 * @param segment		ISegment	The current path's segment
		 * @param new_segment	ISegment	The new segment to be added
		 */
		public function addSegmentAfter( segment: ISegment, new_segment: ISegment ): void
		{
			//trace('-------------- addSegmentAfter', segment, new_segment );
			var prevSegment: ISegment;
			var nextSegment: ISegment;

			prevSegment = segment ? segment : this.lastSegment;
			nextSegment = segment ? segment.next : null;

			if( prevSegment )
			{
				if( prevSegment is MoveSegment && new_segment is MoveSegment )
				{
					prevSegment.end.x = new_segment.end.x;
					prevSegment.end.y = new_segment.end.y;
					invalidate( );
					return;
				} else {
					prevSegment.next = new_segment;
					new_segment.prev = prevSegment;
				}
			}

			if( nextSegment )
			{
				nextSegment.prev = new_segment;
				new_segment.next = nextSegment;
			}

			PathSegment( new_segment ).addEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );
			
			var splice_index: int = prevSegment ? getSegmentIndex( prevSegment ) + 1 : length;
			_segments.splice( splice_index, 0, new_segment );

			invalidatePathCommandsIndex( splice_index );
			invalidatePathCommands( new_segment );
			invalidate( );
			checkConsecutiveMoveSegments( splice_index );
		}
		
		protected function invalidatePathCommands( segment: ISegment ): void
		{
			var data_index: int		= segment.path_index.data;
			var command_index: int	= segment.path_index.command;
			var c: Vector.<int> 		= segment.commands;
			var d: Vector.<Number>	= segment.data;
			var a: int;
			
			for( a = command_index; a < c.length + command_index; a++ )
				_commands.splice( a, 0, c[a - command_index] );
				
			for( a = data_index; a < d.length + data_index; a++ )
				_data.splice( a, 0, d[a - data_index] );
		}
		
		protected function invalidatePathCommandsIndex( from_index: int ): void
		{
			for( var a: int = from_index; a < length; a++ )
			{
				if( a > 0 )
				{
					if( _segments[a].prev )
					{
						_segments[a].path_index.command = _segments[a].prev.path_index.command + _segments[a].prev.commands.length;
						_segments[a].path_index.data = _segments[a].prev.path_index.data + _segments[a].prev.data.length;
					}
				} else {
					_segments[a].path_index.command = 0;
					_segments[a].path_index.data = 0;
				}
			}
		}

		/**
		 * Add a new segment before a specified segment along the path
		 * 
		 * @param segment		ISegment	Insert the new segment before this segment
		 * @param new_segment	ISegment	The segment to add to the current path
		 */
		public function addSegmentBefore( segment: ISegment, new_segment: ISegment ): void
		{
			//trace('-------------- addSegmentBefore', segment, new_segment );
			var prevSegment: ISegment = segment;

			prevSegment.prev = new_segment;
			new_segment.next = prevSegment;

			if( !new_segment.hasEventListener( SegmentEvent.SEGMENT_CHANGE ) )
				new_segment.addEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );
			
			var splice_index: int = getSegmentIndex( prevSegment );
			_segments.splice( splice_index, 0, new_segment );
			
			invalidatePathCommandsIndex( splice_index );
			invalidatePathCommands( new_segment );
			
			invalidate( );
			checkConsecutiveMoveSegments( splice_index );
		}

		/**
		 * Remove the segment at specified position
		 * 
		 */
		public function removeSegmentAt( pos: uint ): ISegment 
		{
			//trace('-------------- removeSegmentAt', pos );
			var segment: ISegment = _segments[ pos ];
			
			segment.removeEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );

			if( segment.prev )
			{
				if( segment.next )
				{
					segment.prev.next = segment.next;
					segment.next.prev = segment.prev;
				} else {
					segment.prev.next = null;
				}
			} else if( segment.prev == null && segment.next )
			{
				if( segment.prev )
				{
					segment.next.prev = segment.prev;
					segment.prev.next = segment.next;
				} else {
					segment.next.prev = null;
				}
			}

			segment.prev = null;
			segment.next = null;
			
			var ret: Vector.<ISegment> = _segments.splice( pos, 1 );

			_commands.splice( segment.path_index.command, segment.commands.length );
			_data.splice( segment.path_index.data, segment.data.length );

			invalidatePathCommandsIndex( pos );

			invalidate( );
			checkConsecutiveMoveSegments( pos );
			
			return ret[ 0 ] as ISegment;
		};
		
		/**
		 * Replace the segment at the specified position
		 * with a new segment
		 *
		 * @param pos		uint		Position of the segment to replace
		 * @param segment	ISegment	The segment to insert in the current path
		 */
	    public function replaceSegmentAt( pos: uint, segment: ISegment ): void 
		{
			//trace('-------------- replaceSegmentAt', pos, segment );
			// TODO: check 2 consecutive MoveSegments
			var target: ISegment = getSegmentAt( pos );
			if( target )
			{
				segment.next = target.next;
				segment.prev = target.prev;

				if( target.prev )
				{
					target.prev.next = segment;
				}

				if( target.next )
				{
					target.next.prev = segment;
				}

				target.next = null;
				target.prev = null;

				_segments[ pos ].removeEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );
				segment.addEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );

				_commands.splice( _segments[pos].path_index.command, _segments[ pos ].commands.length );
				_data.splice( _segments[pos].path_index.data, _segments[ pos ].data.length );

				_segments[ pos ] = segment;
				
				invalidatePathCommandsIndex( pos );
				invalidatePathCommands( segment );
				
				invalidate( );
				checkConsecutiveMoveSegments( pos );
			}
		};

	    /**
	     * 
	     * @param walker    walker
	     */
	    public override function render( g: Graphics ): void
	    {
	    	if( _data.length < 1 ) return;
	    	
	    	if( _closed )
	    	{
	    		g.moveTo( _data[ _data.length - 2 ], _data[ _data.length - 1 ] );
	    	} else {
	    		g.moveTo( _data[0], _data[1] );
	    	}
	    	g.drawPath( _commands, _data, _winding );
	    }

	    public override function get boundingBox( ): Rectangle
	    {
			if( !_boundingBox )
			{
				var points: Vector.<Point> = FlattenPathCache.instance.getFlattenPath( this, FlattenPath.DEFAULT_FLATNESS ).points;
				var minx:Number = Number.POSITIVE_INFINITY;
				var miny:Number = Number.POSITIVE_INFINITY;
				var maxx:Number = Number.NEGATIVE_INFINITY;
				var maxy:Number = Number.NEGATIVE_INFINITY;
				
				for each( var point: Point in points )
				{
					if( point )
					{
						minx = Math.min( minx, point.x );
						miny = Math.min( miny, point.y );
						maxx = Math.max( maxx, point.x );
						maxy = Math.max( maxy, point.y );						
					}
				}
				_boundingBox = new Rectangle( minx, miny, maxx - minx, maxy - miny );
			}
			return _boundingBox;	    	
	    }

	    public override function get handles( ): Vector.<IHandle>
	    {
			var ret: Vector.<IHandle> = new Vector.<IHandle>( );
			for each( var item: PathSegment in _segments )
			{
				if( item.handles )
				{
					ret = ret.concat( item.handles );
				}
			}
			return ret;
	    }

		public override function invalidate( ): void
		{
			super.invalidate( );
			_closed = length > 0 && getLastBreakSegment( ) == null;
			eggNode.setAttribute( new LazyAttribute( "shape:handles", AttributeTypes.BINARY_TYPE, encodeHandles ) );
		}

		/**
		 * Remove all nodes from the current path and
		 * replaces them with the content of the egg node
		 * 
		 */
		override public function decode( node: IEGGNode ): void
		{
			( node.attributes['shape:handles'].data as ByteArray ).position = 0;
			
			this.removeAll( );
			var bytes: ByteArray = ( node.getAttribute( "shape:handles" ).data as ByteArray );
			bytes.position = 0;
			bytes.endian = Endian.LITTLE_ENDIAN;
			var was_closed: Boolean = ( bytes.readByte() == 1 );
			
			while( bytes.bytesAvailable > 0 )
			{
				var class_name: String = bytes.readUTF();
				var obj_decoded: Object = bytes.readObject( );
				Logger.log("adding segment: " + class_name );
				
				var sgm: ISegment;
				try
				{
					sgm = PathSegment.decode( class_name, obj_decoded );
					this.addSegment( sgm );
				} catch( err: Error )
				{
					Logger.log( err.toString() );
				}
				
				
			}
			
			if( was_closed )
				this.close( );
		}
		
		override public function encode( ): IEGGNode
		{
			var node: IEGGNode = new EGGNode( this.uid );
			var attr: IEGGAttribute = EGGAttributeFactory.instance.create( AttributeTypes.BINARY_TYPE, "shape:handles" );					
			attr.data = this.encodeHandles( );
			( attr.data as ByteArray ).endian = Endian.LITTLE_ENDIAN;
			node.setAttribute( attr );
			return node;
		}

		private function onSegmentUpdate( event: SegmentEvent ): void
		{
			updateSegment( event.target as ISegment );
		}
		
		/**
		 * Update path data informations from a given segment  
		 * @param segment
		 * 
		 */
		public function updateSegment( segment: ISegment ): void
		{
			//trace('updateSegment', segment );
			var data_index: int = segment.path_index.data;
			var d: Vector.<Number> = segment.data;
			
			for( var a: int = data_index; a < d.length + data_index; a++ )
			{
				_data[a] = d[a - data_index ];
			}
			_pathid = new ObjectId( );
		}

        /**
         * Encode the segments into a ByteArray
         *
         */
        public function encodeHandles( ): ByteArray
        {
            var byte: ByteArray = new ByteArray( );
            byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeByte( closed ? 1 : 0 );
			
            for each( var item: ISegment in _segments )
            {
            	byte.writeUTF( getQualifiedClassName( item ) );
                item.encode( byte );
            }
			
            return byte;
        }
        
		/**
		 * Join the current path with the passed path.
		 * Both paths must be opened paths and both segments must be
		 * end-point segments.
		 * 
		 * @param other	the path to be joined with the current path
		 * @param this_segment	the segment on the current path
		 * @param other_segment	the segment on the other path
		 */
		public function join( other: IPath, this_segment: ISegment, other_segment: ISegment ): void
		{
			assertTrue( !other.closed );
			assertTrue( !this.closed );
			assertTrue( this_segment.isEndSegment );
			assertTrue( other_segment.isEndSegment );
			
			
			var other_direction: int = other_segment.prev ? -1 : 1;
			var this_direction: int  = this_segment.prev ? -1 : 1;
			var cloned: ISegment;
			
			if( other_direction == 1 )
			{
				// next
				/*if( other_segment is MoveSegment )
				{
					cloned = new LineSegment( other_segment.end.x, other_segment.end.y )
					this.addSegmentAfter( this_segment, cloned );
					this_segment  = cloned;
					other_segment = other_segment.next;
				}*/
				
				while( other_segment /*&& !( other_segment is MoveSegment )*/ )
				{
					cloned = other_segment.clone( ) as ISegment;
					this.addSegmentAfter( this_segment, cloned );
					other_segment = other_segment.next;
					this_segment  = cloned;
				}
			} else
			{
				// prev
				this.addSegmentAfter( this_segment, other_segment.clone( ) as ISegment );
				other_segment = other_segment.prev;
			}
		}
		
		/**
		 * Remove all segments
		 * 
		 */
		public function removeAll( ): void 
		{
			while( _segments.length > 0 )
			{
				var segment: ISegment = _segments.shift( ) as ISegment;
				segment.prev = null;
				segment.next = null;
				PathSegment( segment ).removeEventListener( SegmentEvent.SEGMENT_CHANGE, onSegmentUpdate );
			}
			_commands = new Vector.<int>( );
			_data = new Vector.<Number>( );
			invalidate( );
		};
		
	}
}





