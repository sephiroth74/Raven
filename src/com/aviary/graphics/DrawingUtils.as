package com.aviary.graphics
{
	import com.aviary.geom.utils.Point2D;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class DrawingUtils
	{
		
		/**
		 * 
		 * @param g	Graphics where draw will be created
		 * @param x	starting x point
		 * @param y	starting y point
		 * @param sides	num of sides
		 * @param innerRadius	inner radius value
		 * @param outerRadius	outer radius value
		 * @param angle			gear angle
		 * @param holeSides		num of sides of the hole
		 * @param holeRadius	hole radius
		 * 
		 */
		public static function drawGear(g:Graphics, 
									x:int, 
									y:int, 
									sides:uint, 
									innerRadius:Number, 
									outerRadius:Number, 
									angle:Number, 
									holeSides:uint, 
									holeRadius:int = -1):void
		{
			if(sides < 3)
			{
				return;
			}
			var start:Number;
			var qtrStep:Number;
			var step:Number;
			var n:int;
			var dx:int;
			var dy:int;
			step = (Math.PI*2)/sides;
			qtrStep = step/4;
			start = (angle/180)*Math.PI;
			g.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			for (n = 1; n <= sides; n++)
			{
				dx = x+Math.cos(start+(step*n)-(qtrStep*3))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*3))*innerRadius;
				g.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-(qtrStep*2))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*2))*innerRadius;
				g.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-qtrStep)*outerRadius;
				dy = y-Math.sin(start+(step*n)-qtrStep)*outerRadius;
				g.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				g.lineTo(dx, dy);
			}
	
			if (holeSides > 2)
			{
				if(holeRadius < 0)
				{
					holeRadius = innerRadius/3;
				}
				step = (Math.PI*2)/holeSides;
				g.moveTo(x+(Math.cos(start)*holeRadius), y-(Math.sin(start)*holeRadius));
				for (n = 1; n <= holeSides; n++) 
				{
					dx = x+Math.cos(start+(step*n))*holeRadius;
					dy = y-Math.sin(start+(step*n))*holeRadius;
					g.lineTo(dx, dy);
				}
			}
		} // drawGear
		
		
		
		/**
		 * Draw a n side polygon
		 * @param g
		 * @param x
		 * @param y
		 * @param sides
		 * @param outerRadius
		 * @param angle
		 * 
		 */
		public static function drawPolygon(g: Graphics, 
									x: int, 
									y: int, 
									sides: uint, 
									outerRadius: Number, 
									angle: Number, _dist: Number = 1 ): void
		{
			if(sides < 3)
				return;

			var start: Number;
			var qtrStep: Number;
			var step: Number;
			var n: int;
			var dx: int;
			var dy: int;
			step = ( Math.PI * 2 ) / sides;
			qtrStep = step / 4;
			start = angle;
			var center: Point = new Point( x, y );
			var current:Point = new Point( x + ( Math.cos( start ) * outerRadius ), y - ( Math.sin( start ) * outerRadius ) );
			g.moveTo( current.x, current.y );
			
			for (n = 1; n <= sides; n++ )
			{
				var pt: Point = new Point( x + Math.cos( start + ( step * n ) ) * outerRadius, y - Math.sin( start + ( step * n ) ) * outerRadius );
				var mid: Point = Point2D.getLerp( pt, current, 0.5 );
				var dest: Point = Point2D.getLerp( center, mid, _dist );
				g.curveTo( dest.x, dest.y, pt.x, pt.y );
				current = pt.clone( );
			}
		} // drawPolygon		
		

		/**
		 * 
		 * @param g graphic object
		 * @param x x center
		 * @param y y center
		 * @param points number of points of the star ( > 2)
		 * @param innerRadius radius of the indent of the points
		 * @param outerRadius radius of the tips of the points
		 * @param angle degree
		 * @return 
		 * 
		 */
		public static function drawStar( g: Graphics, x: int, y: int, points: uint, innerRadius: uint, outerRadius: uint, angle: Number = 0 ): void
		{
			if ( points > 2 ) 
			{
				var step: Number;
				var halfStep: Number;
				var n: uint;
				var dx: Number;
				var dy: Number;

				step = ( Math.PI * 2 ) / points;
				halfStep = step / 2;

				g.moveTo( x + ( Math.cos( angle ) * outerRadius ), y - ( Math.sin( angle ) * outerRadius ) );
				for ( n = 1; n <= points; n++ ) 
				{
					dx = x + Math.cos( angle + ( step * n ) - halfStep ) * innerRadius;
					dy = y - Math.sin( angle + ( step * n ) - halfStep ) * innerRadius;
					g.lineTo( dx, dy );
					dx = x + Math.cos( angle + ( step * n ) ) * outerRadius;
					dy = y - Math.sin( angle + ( step * n ) ) * outerRadius;
					g.lineTo( dx, dy );
				}
			}
		} // drawStar
		
		
		public static function drawSpiral( g: Graphics, x: Number, y: Number, radius: Number, _func: Function ): void
		{
			var a: Number = 0;
			var r: Number = 0;
			
			g.moveTo( x, y );
			var n: Number = 0;
			var angDiv: Number = 2 * Math.PI / 8;
			
			while ( r < radius )
			{
				var ca: Number = a + angDiv / 2;
				var cr: Number = _func( ca ) / Math.cos( angDiv / 2 );
				a += angDiv;
				r = _func( a );
				g.curveTo( x + Math.cos( ca ) * cr, y + Math.sin( ca ) * cr, x + Math.cos( a ) * r, y + Math.sin( a ) * r );
				++n;
			}
		}
	}
}
