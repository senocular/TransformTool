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
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * A simple variation of ControlBase that does not include 
	 * user interaction handlers, instead simply including a
	 * tool reference and handlers for draw/redraw.
	 * @author Trevor McCauley
	 */
	public class ControlSimpleBase extends Sprite {
		
		public function get tool():TransformTool {
			return _tool;
		}
		public function set tool(value:TransformTool):void {
			if (value == _tool){
				return;
			}
			if (_tool){
				_tool.removeEventListener(TransformTool.REDRAW, redraw);
			}
			_tool = value;
			if (_tool){
				_tool.addEventListener(TransformTool.REDRAW, redraw);
				redraw(null);
			}
		}
		private var _tool:TransformTool;
		
		public function ControlSimpleBase() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		// event handlers
		protected function addedToStage(event:Event):void {
			var tool:TransformTool = parent as TransformTool;
			if (tool != null){
				this.tool = tool;
				draw();
			}else{
				this.tool = null;
			}
		}
		
		protected function removedFromStage(event:Event):void {
			this.tool = null;
		}
		
		protected function draw():void {
			// to be overridden
		}
		
		protected function redraw(event:Event):void {
			// to be overridden
		}
	}
}