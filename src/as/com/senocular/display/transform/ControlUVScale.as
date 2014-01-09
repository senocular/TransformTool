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
	
	public class ControlUVScale extends ControlUVBase {
		
		/**
		 * Scale mode for scaling x axis only.
		 */
		public static const X_AXIS:String = "xAxis";
		
		/**
		 * Scale mode for scaling y axis only.
		 */
		public static const Y_AXIS:String = "yAxis";
		
		/**
		 * Scale mode for scaling both the x and y axes at
		 * the same time.
		 */
		public static const BOTH:String = "both";
		public static const UNIFORM:String = "uniform";
		
		/**
		 * Scale mode for scaling both the x and y axes
		 * uniformly (maintaining aspect ratio) at the same
		 * time.
		 */
		
		public function get mode():String {
			return _mode;
		}
		public function set mode(value:String):void {
			_mode = value;
		}
		private var _mode:String;
		
		public function ControlUVScale(u:Number = 1, v:Number = 1, mode:String = BOTH, cursor:CursorBase = null){
			super(u, v, cursor);
			this.mode = mode;
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
				lineStyle(2, 0xFFFFFF);
				drawRect(-4, -4, 8, 8);
			}
		}
		
		override protected function mouseDown(event:MouseEvent):void {
			// define offset for updateBaseReferences
			// which is called in super.mouseDown
			// (so it must be defined before super())
			parentOffset.x = -event.localX;
			parentOffset.y = -event.localY;
			super.mouseDown(event);
		}
		
		override protected function activeMouseMove(event:MouseEvent):void {
			super.activeMouseMove(event);
			
			switch(_mode){
				
				case X_AXIS:{
					scaleXAxis();
					break;
				}
				
				case Y_AXIS:{
					scaleYAxis();
					break;
				}
				
				case UNIFORM:{
					uniformScale();
					break;
				}
				
				case BOTH:
				default:{
					if (event.shiftKey){
						uniformScale();
					}else{
						scale();
					}
					break;
				}
			}
			
			updateTool(false);
		}
	}
}