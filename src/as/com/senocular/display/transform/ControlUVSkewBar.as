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
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Trevor McCauley
	 */
	public class ControlUVSkewBar extends ControlUVBase {
		
		public static const X_AXIS:String = "xAxis";
		public static const Y_AXIS:String = "yAxis";
		
		public function get u2():Number {
			return _u2;
		}
		public function set u2(value:Number):void {
			_u2 = isNaN(value) ? 0 : value;
		}
		private var _u2:Number;
		
		public function get v2():Number {
			return _v2;
		}
		public function set v2(value:Number):void {
			_v2 = isNaN(value) ? 0 : value;
		}
		private var _v2:Number;
		
		public function get mode():String {
			return _mode;
		}
		public function set mode(value:String):void {
			_mode = value;
		}
		private var _mode:String;
		
		public function ControlUVSkewBar(u:Number = 0, v:Number = 0, u2:Number = 1, v2:Number = 0, 
			mode:String = X_AXIS, cursor:CursorBase = null) {
			
			super(u, v, cursor);
			this.u2 = u2;
			this.v2 = v2;
			this.mode = mode;
		}
		
		override protected function draw():void {
			super.draw();
			redraw(null);
		}
		
		override protected function redraw(event:Event):void {
			super.redraw(event);
			
			var toParent:Matrix = tool.toolTransform.clone();
			toParent.invert();
			
			var start:Point = getUVPosition(u, v);
			var end:Point =  getUVPosition(_u2, _v2);
			
			var angle:Number = Math.atan2(end.y - start.y, end.x - start.x) - Math.PI/2;	
			var offset:Point = Point.polar(4, angle);
			
			// draw bar
			with (graphics){
				clear();
				beginFill(0xFF0000, 0); // invisible
				moveTo(start.x + offset.x, start.y + offset.y);
				lineTo(end.x + offset.x, end.y + offset.y);
				lineTo(end.x - offset.x, end.y - offset.y);
				lineTo(start.x - offset.x, start.y - offset.y);
				lineTo(start.x + offset.x, start.y + offset.y);
				endFill();
			}
		}
		
		override protected function setPosition():void {
			// overridden to prevent default ControlUVBase behavior
			// for these skew controls, drawing sets position
		}
		
		override protected function activeMouseMove(event:MouseEvent):void {
			super.activeMouseMove(event);
			
			switch(mode){
				
				case Y_AXIS:{
					skewYAxis();
					break;
				}
				
				case X_AXIS:
				default:{
					skewXAxis();
					break;
				}
			}
			
			updateTool(false);
		}
	}
}