///////////////////////////////////////////////////////////
//  IVectorStroke.as
//  Macromedia ActionScript Implementation of the Interface IVectorStroke
//  Generated by Enterprise Architect
//  Created on:      01-Apr-2008 8:09:25 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////

package com.aviary.graphics
{
	import com.aviary.raven.utils.ICloneable;
	
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * @author alessandro crugnola
	 * @version 1.0
	 * @created 01-Apr-2008 8:09:25 AM
	 */
	public interface IVectorStroke extends IEventDispatcher, ICloneable, IGradient
	{
		function get weight(): Number;
	
		/**
		 * 
		 * @param value    value
		 */
		function set weight(value:Number): void;
	
		function get miterLimit(): Number;
	
		/**
		 * 
		 * @param value    value
		 */
		function set miterLimit(value:Number): void;
	
		function get joints(): String;
	
		/**
		 * 
		 * @param value    value
		 */
		function set joints(value:String): void;
	
		function get caps(): String;
	
		/**
		 * 
		 * @param value    value
		 */
		function set caps(value:String): void;
	
		function get scaleMode(): String;
	
		/**
		 * 
		 * @param value    value
		 */
		function set scaleMode(value:String): void;
	
		function get pixelHinting(): Boolean;
	
		/**
		 * 
		 * @param value    value
		 */
		function set pixelHinting(value:Boolean): void;
	
		/**
		 * 
		 * @param g
		 * @param type
		 * @param rc    rc
		 */
		function apply(g:Graphics, type:uint, rc:Rectangle = null): void;
		
		function toString(): String;
	}//end IVectorStroke
}