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
	
	public class ControlUVBase extends ControlBase {
		
		/**
		 * The U value in the UV positioning used by the
		 * Control object. This representes a percentage
		 * along the width of the target used in determining
		 * the x location of the control. A value of 0 
		 * positions the control at the left edge of the target
		 * while a value of 1 positions at the right edge.
		 */
		public function get u():Number {
			return _u;
		}
		public function set u(value:Number):void {
			_u = isNaN(value) ? 0 : value;
		}
		private var _u:Number;
		
		/**
		 * The V value in the UV positioning used by the
		 * Control object. This representes a percentage
		 * along the height of the target used in determining
		 * the y location of the control. A value of 0 
		 * positions the control at the top edge of the target
		 * while a value of 1 positions at the bottom edge.
		 */
		public function get v():Number {
			return _v;
		}
		public function set v(value:Number):void {
			_v = isNaN(value) ? 0 : value;
		}
		private var _v:Number;
		
		public function get offsetU():Number {
			return _offsetU;
		}
		public function set offsetU(value:Number):void {
			_offsetU = isNaN(value) ? 0 : value;
		}
		private var _offsetU:Number = 0;
		
		public function get offsetV():Number {
			return _offsetV;
		}
		public function set offsetV(value:Number):void {
			_offsetV = isNaN(value) ? 0 : value;
		}
		private var _offsetV:Number = 0;
		
		
		
		public function ControlUVBase(u:Number = 0, v:Number = 0, cursor:CursorBase = null){
			super(cursor);
			this.u = u;
			this.v = v;
		}
		
		public function getUVPosition(u:Number = NaN, v:Number = NaN):Point {
			if (isNaN(u)){
				u = _u;
			}
			if (isNaN(v)){
				v = _v;
			}
			
			var position:Point = new Point();
			
			var tool:TransformTool = this.tool;
			if (tool == null){
				return position;
			}
			var target:DisplayObject = tool.target;
			if (target == null){
				return position;
			}
			
			var bounds:Rectangle = target.getBounds(target);
			position.x = bounds.left + bounds.width * u;
			position.y = bounds.top + bounds.height * v;
			position = tool.toolTransform.transformPoint(position);
			
			var angle:Number;
			if (_offsetU){
				angle = tool.getRotationX();
				position.x += _offsetU * Math.cos(angle);
				position.y += _offsetU * Math.sin(angle);
			}
			if (_offsetV){
				angle = tool.getRotationY();
				position.x += _offsetV * Math.sin(angle);
				position.y += _offsetV * Math.cos(angle);
			}
			
			return position;
		}
		
		override protected function redraw(event:Event):void {
			super.redraw(event);
			setPosition();
		}
		
		protected function setPosition():void {
			var position:Point = getUVPosition();
			x = position.x;
			y = position.y;
		}
	}
}