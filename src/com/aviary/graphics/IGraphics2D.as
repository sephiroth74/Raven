package com.aviary.graphics
{
	import flash.display.Graphics;
	import com.aviary.geom.IShape;
	
	public interface IGraphics2D
	{
	    function get strokeType( ): uint;
	    function set strokeType( value: uint ): void;
	    function set fillType( value: uint ): void;
	    function get fillType( ): uint;
	    function get stroke( ): IVectorStroke;
	    function get fill( ): IVectorFill;
	    function get graphics( ): Graphics;
		function clear( ): void;
	    function render( value: IShape ): void;
	}
}