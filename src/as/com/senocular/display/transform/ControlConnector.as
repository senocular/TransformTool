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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	
	public class ControlConnector extends Sprite {
		
		public function get tool():TransformTool {
			return _tool;
		}
		public function set tool(value:TransformTool):void {
			if (value == _tool){
				return;
			}
			if (_tool){
				_tool.removeEventListener(TransformTool.REDRAW, redraw, false);
			}
			_tool = value;
			if (_tool){
				// use a lower priority allowing controls to
				// redraw before the connector connects them
				_tool.addEventListener(TransformTool.REDRAW, redraw, false, -1);
				redraw(null);
			}
		}
		private var _tool:TransformTool;
		
		public function get control1():DisplayObject { 
			return _control1; 
		}
		
		public function set control1(value:DisplayObject):void {
			if (value == _control1){
				return;
			}
			
			if (_control1){
				_control1.removeEventListener(Event.ADDED_TO_STAGE, redraw, false);
			}
			
			_control1 = value;
			
			if (_control1){
				// we presume the control will redraw itself
				// when added to the stage along with REDRAW events
				// as with REDRAW, priority is lowered
				_control1.addEventListener(Event.ADDED_TO_STAGE, redraw, false, -1);
				
				if (_tool != null){
					redraw(null);
				}
			}
		}
		private var _control1:DisplayObject;
		
		public function get control2():DisplayObject {
			return _control2; 
		}
		public function set control2(value:DisplayObject):void { 
			if (value == _control2){
				return;
			}
			
			if (_control2){
				_control2.removeEventListener(Event.ADDED_TO_STAGE, redraw, false);
			}
			
			_control2 = value;
			
			if (_control2){
				// we presume the control will redraw itself
				// when added to the stage along with REDRAW events
				// as with REDRAW, priority is lowered
				_control2.addEventListener(Event.ADDED_TO_STAGE, redraw, false, -1);
				
				if (_tool != null){
					redraw(null);
				}
			}
		}
		private var _control2:DisplayObject;
		
		public function ControlConnector(control1:DisplayObject = null, control2:DisplayObject = null){
			super();
			mouseEnabled = false;
			if (control1 != null) this.control1 = control1;
			if (control2 != null) this.control2 = control2;
			addEventListener(Event.ADDED, addedAtTarget); // find tool before added to stage
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		// event handlers
		protected function addedToStage(event:Event):void {
			var tool:TransformTool = parent as TransformTool;
			if (tool != null){
				this.tool = tool;
				redraw(null);
			}else{
				this.tool = null;
			}
		}
		
		protected function addedAtTarget(event:Event):void {
			if (event.eventPhase == EventPhase.AT_TARGET){
				addedToStage(event);
			}
		}
		
		protected function removedFromStage(event:Event):void {
			this.tool = null;
		}
		
		protected function redraw(event:Event):void {
			if (control1 == null || control2 == null){
				graphics.clear();
				return;
			}
			
			with (graphics){
				clear();
				lineStyle(1, 0x000000);
				moveTo(control1.x, control1.y);
				lineTo(control2.x, control2.y);
			}
		}
	}
}