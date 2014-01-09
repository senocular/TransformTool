/*
Copyright (c) 2010 Trevor McCauley

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
*/
package com.senocular.display.transform {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Trevor McCauley
	 */
	public class ControlOrigin extends ControlSimpleBase {
		
		public function ControlOrigin() {
			super();
			mouseEnabled = false;
		}
		
		override protected function draw():void {
			super.draw();
			
			// don't draw anything if something
			// has been added as a child to
			// this display object as a "skin"
			if (numChildren) return;
			
			with (graphics){
				clear();
				// fat background plus
				beginFill(0xFFFFFF);
				drawRect(-2.5, -3.5, 5, 7);
				endFill();
				beginFill(0xFFFFFF);
				drawRect(-3.5, -2.5, 7, 5);
				endFill();
				// thin foreground plus
				beginFill(0x000000);
				drawRect(-1, -3.5, 2, 7);
				endFill();
				beginFill(0x000000);
				drawRect(-3.5, -1, 7, 2);
				endFill();
			}
		}
		
		override protected function redraw(event:Event):void {
			super.redraw(event);
			
			var position:Point = tool.toolTransform.transformPoint( new Point(0, 0) );
			x = position.x;
			y = position.y;
		}
	}
}