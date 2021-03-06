///////////////////////////////////////////////////////////
//  Spiral.as
//  Macromedia ActionScript Implementation of the Class Spiral
//  Generated by Enterprise Architect
//  Created on:      01-Apr-2008 8:09:30 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////

package com.aviary.geom
{
	import __AS3__.vec.Vector;
	
	import com.aviary.events.HandleEvent;
	import com.aviary.geom.controls.Handle;
	import com.aviary.geom.controls.HandleType;
	import com.aviary.geom.controls.IHandle;
	import com.aviary.geom.path.IPath;
	import com.aviary.geom.path.Path;
	import com.aviary.raven.io.LoaderUtils;
	import com.aviary.sdk.storage.eggfile.IEGGNode;
	import com.aviary.sdk.storage.eggfile.attributes.AttributeTypes;
	import com.aviary.sdk.storage.eggfile.attributes.BinaryAttribute;
	import com.aviary.sdk.storage.eggfile.attributes.LazyAttribute;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author alessandro crugnola
	 * @version 1.0
	 * @created 01-Apr-2008 8:09:30 AM
	 */
	public class Spiral extends Shape
	{
	    private var center: Handle;
	    private var radius: Handle;
	    private var _func: Function = archimedes;
	    private var archK: Number = 2;
	    private var _dirty: Boolean;

	    /**
	     * 
	     * @param x
	     * @param y
	     * @param r    r
	     */
	    public function Spiral( x: Number = 0, y: Number = 0, r: Number = 0 )
	    {
			super( );
        	center = new Handle( 'center', x, y );
        	radius = new Handle( 'radius', x + r, y, HandleType.CONTROL_FORM );
        	
        	center.addEventListener( HandleEvent.HANDLE_CHANGE, onHandleChange );
        	radius.addEventListener( HandleEvent.HANDLE_CHANGE, onHandleChange );
        	_handles = Vector.<IHandle>( [ center, radius ] );
        	_handles_dict[ center.name ] = 0;
        	_handles_dict[ radius.name ] = 1;
			
			eggNode.setAttribute( new LazyAttribute( "shape:center", AttributeTypes.BINARY_TYPE, encodePt0 ) );
			eggNode.setAttribute( new LazyAttribute( "shape:radius", AttributeTypes.BINARY_TYPE, encodePt1 ) );
			
			_dirty = true;
			updateData( );
	    }

	    /**
	     * 
	     * @param event    event
	     */
	    private function onHandleChange(event:HandleEvent): void
	    {
			var handle: Handle = event.target as Handle;
			var diff_point: Point = handle.point.subtract( event.old_point );

			if( handle.name == 'center' )
			{
				radius.setPoint( new Point( radius.point.x + diff_point.x, radius.point.y + diff_point.y ), false );
			} else if( handle.name == 'radius' )
			{
				radius.setPoint( new Point( radius.point.x, center.point.y ), false );
			}
			
			_boundingBox = null;
			_dirty = true;
	    }

	    /**
	     * 
	     * @param walker    walker
	     */
	    public override function render( g: Graphics ): void
	    {
	    	if( _dirty )
	    		updateData( );
	    	
	    	g.drawPath( _commands, _data );
	    }
	    
	    private function updateData( ): void
	    {
	    	if( _dirty )
	    	{
				var a: Number = 0;
				var r: Number = 0;

	    		_commands = new Vector.<int>( );
	    		_data = new Vector.<Number>( );
	    		
	    		_commands.push( GraphicsPathCommand.MOVE_TO );
	    		_data.push( center.point.x, center.point.y );
	    		
				var n: Number = 0;
				var angDiv: Number = 2 * Math.PI / 8;
				var RAD: Number = Point.distance( radius.point, center.point );

				while ( r < RAD )
				{
					var ca: Number = a + angDiv / 2;
					var cr: Number = _func( ca ) / Math.cos( angDiv / 2 );
					a += angDiv;
					r = _func( a );
					
					_commands.push( GraphicsPathCommand.CURVE_TO );
					_data.push( center.point.x + Math.cos( ca ) * cr, center.point.y + Math.sin( ca ) * cr, center.point.x + Math.cos( a ) * r, center.point.y + Math.sin( a ) * r );
					++n;
				}
	    	}
	    	_dirty = false;
	    }

	    /**
	     * 
	     * @param a    a
	     */
	    private function archimedes(a:Number): Number
	    {
			return archK * a;	    	
	    }

	    public override function get boundingBox(): Rectangle
	    {
			if( !_boundingBox )
			{
				var width: Number  = Point.distance( radius.point, center.point );
				_boundingBox = new Rectangle( center.point.x - width, center.point.y - width, width * 2, width * 2 );
			}
			return _boundingBox;	    	
	    }

	    public override function generatePath(): IPath
	    {
			var a: Number = 0;
			var r: Number = 0;
			var n: Number = 0;
			var angDiv: Number = 2 * Math.PI / 8;
			var previus: Point;
			var current_rad: Number = Point.distance( radius.point, center.point );
			
			var path: IPath = new Path( );
			path.start( center.point.x, center.point.y );
			previus = center.point.clone( );
			
			while ( r < current_rad )
			{
				var ca: Number = a + angDiv / 2;
				var cr: Number = _func( ca ) / Math.cos( angDiv / 2 );
				a += angDiv;
				r = _func( a );
				path.curve3To( previus.x, previus.y, center.point.x + Math.cos( ca ) * cr, center.point.y + Math.sin( ca ) * cr, center.point.x + Math.cos( a ) * r, center.point.y + Math.sin( a ) * r );
				previus = new Point( center.point.x + Math.cos( a ) * r, center.point.y + Math.sin( a ) * r );
				++n;
			}
			
			return path;
	    }
	    
		protected function encodePt0( ): ByteArray
		{
			return LoaderUtils.encodePoint( center.point );
		}
		
		protected function encodePt1( ): ByteArray
		{
			return LoaderUtils.encodePoint( radius.point );
		}
		
		override public function decode(node:IEGGNode):void
		{
			( node.attributes['shape:center'].data as ByteArray ).position = 0;
			( node.attributes['shape:radius'].data as ByteArray ).position = 0;
			
			var pt0: Point = LoaderUtils.decodePoint( node.attributes['shape:center'].data ); 
			var pt1: Point = LoaderUtils.decodePoint( node.attributes['shape:radius'].data ); 
			var r: Number = Point.distance( pt1, pt0 ); 
			
			this.center.setPoint( pt0, false, false );
			this.radius.setPoint( pt1, false, false );
			invalidate( );
			
			_dirty = true;
			updateData( );
		}
		
		override public function encode():IEGGNode
		{
			var node: IEGGNode = createEggNode( );
			node.setAttribute( new BinaryAttribute( "shape:center", encodePt0() ) );
			node.setAttribute( new BinaryAttribute( "shape:radius", encodePt1() ) );
			return node;
		}
		
		override public function toString():String
		{
			return "spiral(" + center.point.x + "," + center.point.y + "," + radius.point.x + "," + radius.point.y + ")";
		}
				

	}//end Spiral

}