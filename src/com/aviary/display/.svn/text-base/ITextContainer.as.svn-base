package com.aviary.display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.TextFlow;
	
	public interface ITextContainer
	{
		function get textFlow(): TextFlow;
		function set textFlow( value: TextFlow ): void;
		function get uid( ): String;
		function get controller( ): ContainerController;
		function set controller( value: ContainerController ): void;
		function get compositionWidth( ): Number;
		function get compositionHeight( ): Number;
		function get autoSize( ): Boolean;
		function set autoSize( value: Boolean ): void;
		
		function encodeText( ): String;
		function decodeText( obj: String ): void;
		function getBitmapData( min_size: int = -1 ): BitmapData;
		function getOriginalBitmapData( min_size: int = -1 ): BitmapData;
		function releaseOriginal( ): void;
		function getContentBounds( ): Rectangle;
		function getSelection( ): Point;
		function setSelection( start_index: int, end_index: int ): void;
		function setCompositionSize( width: Number, height: Number ): void;		
		function hasFonts( ): Boolean;
	}
}