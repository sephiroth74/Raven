package com.aviary.collections
{
	public class ArrayIterator
	{
		protected var _data:Array;
		protected var pointer:int;
		protected var _current:Object;
		
		public function ArrayIterator( data: Array )
		{
			_data = data;
			pointer = -1;
		}
		
		public function get length( ): Number
		{
			return _data.length;
		}
		
		public function rewind( ): void
		{
			pointer = -1;
			_current = null;
		}
		
		public function next( ): Boolean
		{
			++pointer;
			_current = null;
			return _data.length > pointer;
		}
		
		public function get current( ): Object
		{
			if( !_current )
				_current = _data[pointer];
			return _current;
		}
		
		public function get isValid( ): Boolean
		{
			return _data.length > pointer;
		}
		
		public function get index( ): int
		{
			return pointer;
		}
		
	}
}