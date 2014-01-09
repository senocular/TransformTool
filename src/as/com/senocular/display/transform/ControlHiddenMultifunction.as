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
	import flash.events.MouseEvent;
	
	public class ControlHiddenMultifunction extends ControlBase {
		
		override public function set tool(value:TransformTool):void {
			super.tool = value;
			
			var tool:TransformTool = super.tool;
			if (tool){
				this.target = tool.target;
			}else{
				this.target = null;
			}
		}
		
		/**
		 * Target display object to be transformed by the TransformTool.
		 * Control points may use the target to add listeners to, for example
		 * to move the target by dragging it.  This value is automatically
		 * updated through the TransformTool.TARGET_CHANGED event.
		 */
		public function get target():DisplayObject {
			return _target;
		}
		public function set target(value:DisplayObject):void {
			if (value == _target){
				return;
			}
			if (_target){
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
			_target = value;
			if (_target){
				_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		private var _target:DisplayObject;
		
		public function ControlHiddenMultifunction(cursor:CursorBase = null){
			super(cursor);
		}
		
		override protected function targetChanged(event:Event):void {
			super.targetChanged(event);
			this.target = tool.target;
		}
		
		override protected function activeMouseMove(event:MouseEvent):void {
			super.activeMouseMove(event);
			
			if (event.shiftKey && event.ctrlKey){
				scaleAndRotate();
			}else if (event.shiftKey){
				scale();
			}else if (event.ctrlKey){
				rotate();
			}else if (event.altKey){
				moveRegistration();
			}else{
				move();
			}
			
			updateTool(false);
		}
		
		protected function scaleAndRotate():void {
			var baseDist:Number = Math.sqrt(baseParentX*baseParentX + baseParentY*baseParentY);
			var activeDist:Number = Math.sqrt(activeParentX*activeParentX + activeParentY*activeParentY);
			
			if (Math.abs(baseDist) >= ControlBase.MIN_SCALE_BASE){
				var scale:Number = activeDist/baseDist;
				_tool.preTransform.scale(scale, scale);
			}
			
			var baseAngle:Number = Math.atan2(baseParentY, baseParentX);
			var activeAngle:Number = Math.atan2(activeParentY, activeParentX);
			_tool.postTransform.rotate(activeAngle - baseAngle);
		}
	}
}