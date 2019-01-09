package com.aviary.utils
{
	import flash.utils.Dictionary;
	
	public class UserDict
	{
		private var _keys: Array;
		private var _values: Array;
		private var _dict: Dictionary;
		
		public function UserDict()
		{
			_keys   = new Array( );
			_values = new Array( );
			_dict   = new Dictionary( );
		}
		
		public function add( key: * , value: * ): void
		{
			if( _keys.indexOf( key ) == -1 )
			{
				_keys.push( key );
				_values.push( value );
			} else {
				var index: int   = _keys.indexOf( key );
				_keys[ index ]   = key;
				_values[ index ] = value;
			}
			_dict[ key ] = value;
		}
		
		public function values( ): Array
		{
			var ret: Array = new Array( );
			for each( var a:* in _dict )
			{
				ret.push( a );
			}
			return ret;
		}
		
		public function keys( ): Array
		{
			return _keys;
		}
		
		public function get_value( key: *, defaultValue: * = null ): *
		{
			return _keys.indexOf( key ) > -1 ? _dict[ key ] : defaultValue;
		}

		public function has_key( k: * ): Boolean
		{
			return _keys.indexOf( k ) > -1;
		}
		
	}
}