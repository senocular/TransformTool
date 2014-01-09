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
	import flash.geom.Point;
	
	public class ControlRegistration extends ControlBase {
		
		public function get editable():Boolean {
			return _editable;
		}
		public function set editable(value:Boolean):void {
			_editable = value;
		}
		private var _editable:Boolean = true;
		
		public function ControlRegistration(cursor:CursorBase = null){
			super(cursor);
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
		}
		
		override protected function draw():void {
			super.draw();
			
			// don't draw anything if something
			// has been added as a child to
			// this display object as a "skin"
			if (numChildren) return;
			
			with (graphics){
				clear();
				beginFill(0xFFFFFF);
				lineStyle(2, 0x000000);
				drawCircle(0, 0, 4);
			}
		}
		
		override protected function redraw(event:Event):void {
			super.redraw(event);
			
			if (getVisible()){
				visible = true;
				
				var loc:Point = tool.registration;
				x = loc.x;
				y = loc.y;
				
			}else{
				visible = false;
			}
		}
		
		protected function getVisible():Boolean {
			
			if (Point.distance(tool.topRight, tool.topLeft) < width
			&& Point.distance(tool.bottomLeft, tool.topLeft) < height){
				return false;
			}
			
			return true;
		}
		
		override protected function activeMouseMove(event:MouseEvent):void {
			if (_editable){
				super.activeMouseMove(event);
				
				moveRegistration();
				updateTool(false);
			}
		}
		
		protected function doubleClick(event:MouseEvent):void {
			if (_editable){
				tool.resetRegistration();
				tool.updateControls();
			}
		}
	}
}