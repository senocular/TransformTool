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
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Trevor McCauley
	 */
	public class ControlCursor extends Sprite {
		
		protected var interactionTarget:IEventDispatcher;
		protected var mouseActive:Boolean = false;
		
		public function get tool():TransformTool {
			return _tool;
		}
		public function set tool(value:TransformTool):void {
			if (value == _tool){
				return;
			}
			
			if (_tool){
				_tool.removeEventListener(TransformTool.CURSOR_CHANGED, cursorChanged);
				_tool.removeEventListener(TransformTool.TARGET_CHANGED, targetChanged);
			}
			_tool = value;
			if (_tool){
				_tool.addEventListener(TransformTool.CURSOR_CHANGED, cursorChanged);
				_tool.addEventListener(TransformTool.TARGET_CHANGED, targetChanged);
			}
		}
		private var _tool:TransformTool;
		
		public function get offset():Point {
			return _offset;
		}
		private var _offset:Point = new Point(20, 28);
		
		protected function get currentCursor():DisplayObject {
			return _currentCursor;
		}
		protected function set currentCursor(value:DisplayObject):void {
			if (value == _currentCursor){
				return;
			}
			
			if (_currentCursor && currentCursor.parent == this){
				removeChild(_currentCursor);
			}
			
			_currentCursor = value;
			
			if (_currentCursor){
				addChild(_currentCursor);
				setupActiveMouseHandlers();
				
				var cursorEvent:MouseEvent = _tool.cursorEvent as MouseEvent;
				if (cursorEvent){
					activeMouseMove(cursorEvent);
				}
				
			}else{
				cleanupActiveMouseHandlers();
			}
		}
		private var _currentCursor:DisplayObject;
		
		public function ControlCursor(offset:Point = null){
			super();
			mouseEnabled = false;
			if (offset != null){
				_offset.x = offset.x;
				_offset.y = offset.y;
			}
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		// event handlers
		protected function addedToStage(event:Event):void {
			this.tool = parent as TransformTool;
		}
		
		protected function removedFromStage(event:Event):void {
			this.tool = null;
			cleanupActiveMouseHandlers();
		}
		
		protected function targetChanged(event:Event):void {
			cleanupActiveMouseHandlers();
			currentCursor = null;
			cursorChanged(event);
			
			var targetEvent:MouseEvent = _tool.targetEvent as MouseEvent;
			if (targetEvent){
				activeMouseMove(targetEvent);
			}
		}
		
		protected function cursorChanged(event:Event):void {
			currentCursor = _tool.cursor;
		}
		
		protected function activeMouseMove(event:MouseEvent):void {
			var position:Point;
			
			// get the position of the mouse
			// either from the tool event mouse
			// (pre-transformed mouse) or from the
			// event itself
			if (event == _tool.targetEvent && _tool.targetEventMouse){
				position = _tool.targetEventMouse;
			}else{
				position = new Point(event.stageX, event.stageY);
			}
			
			position = _tool.globalToLocal(position);
			x = position.x + _offset.x;
			y = position.y + _offset.y;
			event.updateAfterEvent();
		}
		
		protected function setupActiveMouseHandlers():void {
			if (mouseActive){
				return;
			}
			
			interactionTarget = null;
			if (stage && loaderInfo && loaderInfo.parentAllowsChild){
				interactionTarget = stage;
			}else if (root){
				interactionTarget = root;
			}
			if (interactionTarget){
				mouseActive = true;
				// priority increased for the cursor to make sure
				// the cursor finds the original mouse location
				// prior to target transforms since event locations
				// change as the event target changes
				interactionTarget.addEventListener(MouseEvent.MOUSE_MOVE, activeMouseMove, false, 1);
			}
		}
		
		protected function cleanupActiveMouseHandlers():void {
			if (interactionTarget){
				interactionTarget.removeEventListener(MouseEvent.MOUSE_MOVE, activeMouseMove, false);
				interactionTarget = null;
			}
			mouseActive = false;
		}
	}
}