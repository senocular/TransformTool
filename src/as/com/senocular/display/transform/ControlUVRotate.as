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
	import flash.events.MouseEvent;
	
	public class ControlUVRotate extends ControlUVBase {
		
		public function ControlUVRotate(u:Number = 1, v:Number = 1, cursor:CursorBase = null){
			super(u, v, cursor);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
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
				beginFill(0x000000);
				lineStyle(2, 0xFFFFFF);
				drawCircle(0, 0, 4);
			}
		}
		
		override protected function activeMouseMove(event:MouseEvent):void {
			super.activeMouseMove(event);
			
			rotate();
			updateTool(false);
		}
		
		override protected function restrict(event:Event):void {
			event.preventDefault();
			
			if (activeMouseEvent.ctrlKey){
				
				// snap to 45 degree angles
				var snap:Number = Math.PI/4;
				tool.setRotation( Math.round(tool.getRotation()/snap)*snap );
			}
			
			// standard rotation restrictions
			// but not scaling restrictions since
			// if negative scaling is false, scale
			// restricts can scale while rotating
			tool.restrictRotation();
		}
	}
}