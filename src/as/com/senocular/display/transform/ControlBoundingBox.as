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
	
	import flash.events.Event;
	
	public class ControlBoundingBox extends ControlSimpleBase {
		
		public function ControlBoundingBox(){
			super();
			mouseEnabled = false;
		}
		
		override protected function draw():void {
			super.draw();
			redraw(null);
		}
		
		override protected function redraw(event:Event):void {
			super.redraw(event);
			
			var tool:TransformTool = this.tool;
			
			var minX:Number = tool.topLeft.x;
			if (tool.topRight.x < minX) minX = tool.topRight.x;
			if (tool.bottomRight.x < minX) minX = tool.bottomRight.x;
			if (tool.bottomLeft.x < minX) minX = tool.bottomLeft.x;
			var minY:Number = tool.topLeft.y;
			if (tool.topRight.y < minY) minY = tool.topRight.y;
			if (tool.bottomRight.y < minY) minY = tool.bottomRight.y;
			if (tool.bottomLeft.y < minY) minY = tool.bottomLeft.y;
			var maxX:Number = tool.topLeft.x;
			if (tool.topRight.x > maxX) maxX = tool.topRight.x;
			if (tool.bottomRight.x > maxX) maxX = tool.bottomRight.x;
			if (tool.bottomLeft.x > maxX) maxX = tool.bottomLeft.x;
			var maxY:Number = tool.topLeft.y;
			if (tool.topRight.y > maxY) maxY = tool.topRight.y;
			if (tool.bottomRight.y > maxY) maxY = tool.bottomRight.y;
			if (tool.bottomLeft.y > maxY) maxY = tool.bottomLeft.y;
			
			with (graphics){
				clear();
				lineStyle(1, 0x000000);
				moveTo(minX, minY);
				lineTo(maxX, minY);
				lineTo(maxX, maxY);
				lineTo(minX, maxY);
				lineTo(minX, minY);
			}
		}
	}
}