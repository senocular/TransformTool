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
	
	public class CursorScale extends CursorBase {

		protected var mode:String;
		protected var rotationOffset:Number;
		
		public function CursorScale(mode:String = "both", rotationOffset:Number = 0) {
			super();
			this.mode = mode;
			if (isNaN(rotationOffset)){
				rotationOffset = 0;
			}
			this.rotationOffset = rotationOffset;
		}
		
		override protected function draw():void {
			super.draw();
			
			// don't draw anything if something
			// has been added as a child to
			// this display object as a "skin"
			if (numChildren) return;
			
			with (graphics){
				clear();
				beginFill(0x000000);
				lineStyle(1, 0xFFFFFF);
				// right arrow
				moveTo(4.5, -0.5);
				lineTo(4.5, -2.5);
				lineTo(8.5, 0.5);
				lineTo(4.5, 3.5);
				lineTo(4.5, 1.5);
				lineTo(-0.5, 1.5);
				// left arrow
				lineTo(-3.5, 1.5);
				lineTo(-3.5, 3.5);
				lineTo(-7.5, 0.5);
				lineTo(-3.5, -2.5);
				lineTo(-3.5, -0.5);
				lineTo(4.5, -0.5);
				endFill();
			}
		}
		
		override public function redraw(event:Event):void {
			super.redraw(event);
			
			var TO_DEGREES:Number = 180/Math.PI;
			var tool:TransformTool = this.tool;
			var angleX:Number = Math.atan2(tool.topRight.y - tool.topLeft.y, tool.topRight.x - tool.topLeft.x) * TO_DEGREES;
			var angleY:Number = Math.atan2(tool.bottomLeft.y - tool.topLeft.y, tool.bottomLeft.x - tool.topLeft.x) * TO_DEGREES;
			
			switch(mode){
				case ControlUVScale.X_AXIS:{
					rotation = rotationOffset + angleX;
					break;
				}
				case ControlUVScale.Y_AXIS:{
					rotation = rotationOffset + angleY;
					break;
				}
				case ControlUVScale.BOTH:
				case ControlUVScale.UNIFORM:
				default:{
					rotation = rotationOffset + (angleX + angleY)/2;
					break;
				}
			}
		}
	}
}
