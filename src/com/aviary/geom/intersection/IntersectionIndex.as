package com.aviary.geom.intersection
{
	import com.aviary.utils.UserDict;
	
	import flash.geom.Point;
	
	public class IntersectionIndex
	{
		private var indexes: Array;
		private var index_table: UserDict;
		private var segment_table: UserDict;
		
		public function IntersectionIndex()
		{
			index_table   = new UserDict( );
		}
		
		public function add( path_index: int, index: Number, cp: Point ): void
		{
			var segment: int = int( index );
			var b: UserDict = index_table.get_value( path_index, new UserDict( ) );
			index_table.add( path_index, b );
			var c: Array = b.get_value( segment, [] );
			b.add( segment, c );
			var indexes: Array = c;
			indexes.push( [ index - segment, cp] );
		}

		public function adjust( ): void
		{
			for each( var segment_table: UserDict in index_table.values() )
			{
				for each( var indexes: Array in segment_table.values() )
				{
					indexes.sort( );
					for( var i: int = 0; i < indexes.length; i++ )
					{
						var r: Number = 1 - indexes[i][0];
						for( var j: int = i + 1; j < indexes.length; j++ )
						{
							indexes[j][0] = (indexes[j][0] - indexes[i][0]) / r;
						}
					}
				}
			}
		}
		
		public function get path_table( ): UserDict
		{
			return index_table;
		}
		
	}
}
