///////////////////////////////////////////////////////////
//  CurveSegment.as
//  Macromedia ActionScript Implementation of the Class CurveSegment
//  Generated by Enterprise Architect
//  Created on:      01-Apr-2008 8:09:21 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////

package com.aviary.geom.path
{
	import __AS3__.vec.Vector;
	
	import com.aviary.geom.controls.HandleType;
	import com.aviary.geom.controls.IHandle;
	import com.aviary.geom.controls.SegmentHandle;
	import com.aviary.raven.utils.ICloneable;
	
	import flash.geom.Point;

	/**
	 * @author alessandro crugnola
	 * @version 1.0
	 * @created 01-Apr-2008 8:09:21 AM
	 */
	public class CurveSegment extends PathSegment implements ICurveSegment
	{
	    protected var curveHandle: SegmentHandle;
	    protected var curvePoint: Point;

	    /**
	     * 
	     * @param cx
	     * @param cy
	     * @param x
	     * @param y    y
	     */
	    public function CurveSegment( cx: Number, cy: Number, x: Number, y: Number )
	    {
			super( x, y );
			curveHandle = new SegmentHandle( 'curve', cx, cy, this, HandleType.CONTROL_FORM );
			curvePoint  = curveHandle.point;
			curveHandle.parentHandle = controlHandle;
			_handles = Vector.<IHandle>( [ curveHandle, controlHandle ] );
	    }

	    override public function clone(): ICloneable
	    {
	    	return new CurveSegment( curvePoint.x, curvePoint.y, this.end.x, this.end.y );
	    }

		override public function toString( ): String
		{
			return "curve2(" + curvePoint.x + "," + curvePoint.y + "," + "," + this.end.x + "," + this.end.y + ")";
		}
	    

	}//end CurveSegment

}