package com.aviary.geom.path
{
	/**
	 * Used to store the informations about the
	 * command and data index for every single ISegment
	 * inside a path 
	 * @author alessandro
	 * 
	 */
	public class PathIndex
	{
		protected var _command: int;
		protected var _data: int;
		
		/**
		 * 
		 * @param $command_index	command index of this segment inside a path 
		 * @param $data_index	data index of this segment inside a path
		 * @see Graphics.drawPath
		 * 
		 */
		public function PathIndex( $command_index: int, $data_index: int )
		{
			_command = $command_index;
			_data = $data_index;
		}
		
		public function get command( ): int
		{
			return _command;
		}
		
		public function set command( value: int ): void
		{
			_command = value;
		}
		
		public function get data( ): int
		{
			return _data;
		}
		
		public function set data( value: int ): void
		{
			_data = value;
		}
		
		public function toString( ): String
		{
			return "PathIndex(" + _command + ", " + _data + ")";
		}
	}
}