///////////////////////////////////////////////////////////
//	$Id:IPath.as 295 2008-04-30 17:19:26Z alessandro $
//	Revision: $Rev:350 $
//	$LastChangedBy:alessandro $
//  Created on:      01-Apr-2008 8:09:27 AM
//  Original author: alessandro crugnola
///////////////////////////////////////////////////////////


package com.aviary.geom.path
{
	import __AS3__.vec.Vector;
	
	import com.aviary.raven.utils.ObjectId;
	import com.aviary.sdk.storage.eggfile.IEGGNode;
	
	import flash.geom.Point;

	/**
	 * @author alessandro crugnola
	 * @version 1.0
	 * @created 01-Apr-2008 8:09:24 AM
	 */
	public interface IPath
	{
		function get pathId( ): ObjectId;
		function get closed( ): Boolean;
		function get length( ): uint;
		function get startPoint( ): Point;
		function get segments( ): Vector.<ISegment>;
		function get lastSegment( ): ISegment;
		function get firstSegment( ): ISegment;
		function decode( node: IEGGNode ): void;
		function encode( ): IEGGNode;
		function close( ): void;
		function open( index: int = 0 ): void;
		function moveTo( x: Number, y: Number ): ISegment;
		function lineTo( x: Number, y: Number ): ISegment;
		function curveTo( cx: Number, cy: Number, x: Number, y: Number): ISegment;
		function curve3To( cx1: Number, cy1: Number, cx2: Number, cy2: Number, x: Number, y: Number): ISegment;
		function start( x: Number, y: Number): ISegment;
		function getSegmentAt( pos: int ): ISegment;
		function getSegmentIndex( value: ISegment ): int;
		function hasSegment( value: ISegment ): Boolean;
		function removeAll( ): void;		function removeSegmentAt( pos: uint ): ISegment;
		function replaceSegmentAt( pos: uint, segment: ISegment ): void;
		function addSegment( value: ISegment ): void;
		function addSegmentAfter( segment: ISegment, new_segment: ISegment ): void;
		function addSegmentBefore( segment: ISegment, new_segment: ISegment ): void;
		function join( other: IPath, this_segment: ISegment, other_segment: ISegment ): void;
		function updateSegment( segment: ISegment ): void;
		function get winding( ): String;
		function set winding( v: String ): void;

	}//end IPath

}
