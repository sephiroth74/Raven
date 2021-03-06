///////////////////////////////////////////////////////////
//  IHandle.as
//  Macromedia ActionScript Implementation of the Interface IHandle
//  Generated by Enterprise Architect
//  Created on:      01-Apr-2008 8:09:24 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////

package com.aviary.geom.controls
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 * Returns the handle used for the selected control point
	 * @author alessandro crugnola
	 * @version 1.0
	 * @created 01-Apr-2008 8:09:24 AM
	 */
	public interface IHandle extends IEventDispatcher
	{
		/**
		 * Get the type of the handle
		 * @see HandleType
		 */
		function get type(): uint;

		function get point(): Point;

		/**
		 * 
		 * @param value    value
		 */
		function set point(value:Point): void;

		/**
		 * Set a point but ask if an event should be dispatched
		 * 
		 * @param value
		 * @param handleEvent    handleEvent
		 */
		function setPoint( value: Point, handleEvent: Boolean = true, handleUpdate: Boolean = true ): void;

		/**
		 * Return the handle internal uid
		 */
		function get name(): String;
		
		function get uid( ): String;
	}//end IHandle

}