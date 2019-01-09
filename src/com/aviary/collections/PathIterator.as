package com.aviary.collections
{
	import com.aviary.geom.path.IPath;
	import com.aviary.geom.path.ISegment;
	import com.aviary.sdk.core.IIterator;

	/**
	 * Iterate throught the segments of a path
	 * 
	 */
	public class PathIterator implements IIterator
	{
		private var _path: IPath;
		private var _segment: ISegment;
		private var _length: int;
		private var _pointer: int;
		private var _start: ISegment;
		
		public function PathIterator( source: IPath, start_segment: ISegment = null )
		{
			_path 		= source;
			_length 	= _path.length;
			_pointer 	= -1;
			_start      = start_segment;
		}

		/**
		 * Iterate to the next segment of the
		 * path. This is not recursive, when the end
		 * of the path is found it stops
		 * 
		 */
		public function get next():*
		{
			if( _pointer == -1 )
			{
				_segment = _start != null ? _start : ( _path.closed ? _path.getSegmentAt( 0 ) : _path.firstSegment );
				_pointer = 0;
			} else
			{
				if( _pointer < ( _length - 1 ) )
				{
					_segment = _segment.next;
				} else {
					_segment = null;
				}
				_pointer++;
			}
			return _segment;
		}
		
		public function get current():*
		{
			return _segment;
		}
		
		public function hasNext():Boolean
		{
			return _segment.next != null;
		}
		
	}
}