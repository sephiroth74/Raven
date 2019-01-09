package com.aviary.collections
{
	import __AS3__.vec.Vector;
	
	import com.aviary.raven.repository.IItem;
	
	public class VectorIItemIterator
	{
		protected var _data: Vector.< IItem >;
		protected var pointer: int;
		protected var _current: IItem;
		
		public function VectorIItemIterator( data: Vector.< IItem > )
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
		
		public function get current( ): IItem
		{
			if( !_current )
				_current = _data[ pointer ];
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