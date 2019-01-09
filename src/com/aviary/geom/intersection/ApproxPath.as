package com.aviary.geom.intersection
{
	import flash.geom.Rectangle;
	
	public class ApproxPath
	{
		public var path_index: int;
		public var rect: Rectangle;
		public var points: Array;	// ApproxPathPoint
		
		function ApproxPath( p_index: int, a: Array, r: Rectangle )
		{
			path_index = p_index;
			points = a;
			rect = r;
		}
	}
}