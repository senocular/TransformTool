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
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	public class ControlBase extends Sprite {
		
		/**
		 * The minimum distance to allow scaling. if the 
		 * distance between the mouse position and the 
		 * registration pont is less than this value, 
		 * scaling is not permitted.
		 */
		public const MIN_SCALE_BASE:Number = .1;
		
		protected var activeTarget:IEventDispatcher;
		protected var activeMouseEvent:MouseEvent;
		protected var parentMouse:Point;
		protected var localMouse:Point;
		
		protected var parentOffset:Point = new Point();
		
		protected var baseLocalMatrixInverted:Matrix;
		protected var baseLocalRegistration:Point;
		protected var baseParentRegistration:Point;
		
		protected var baseLocalX:Number;
		protected var baseLocalY:Number;
		protected var baseParentX:Number;
		protected var baseParentY:Number;
		
		protected var activeLocalX:Number;
		protected var activeLocalY:Number;
		protected var activeParentX:Number;
		protected var activeParentY:Number;
		
		public function get cursor():CursorBase {
			return _cursor;
		}
		public function set cursor(value:CursorBase):void {
			if (value == _cursor){
				return;
			}
			if (_cursor){
				_cursor.tool = null;
			}
			_cursor = value;
			if (_cursor){
				_cursor.tool = _tool;
			}
		}
		private var _cursor:CursorBase;
		
		public function get tool():TransformTool {
			return _tool;
		}
		public function set tool(value:TransformTool):void {
			if (value == _tool){
				return;
			}
			if (_tool){
				_tool.removeEventListener(TransformTool.REDRAW, redraw);
				_tool.removeEventListener(TransformTool.TARGET_CHANGED, targetChanged);
			}
			_tool = value;
			
			if (_cursor){
				_cursor.tool = _tool;
			}
			
			if (_tool){
				_tool.addEventListener(TransformTool.REDRAW, redraw);
				_tool.addEventListener(TransformTool.TARGET_CHANGED, targetChanged);
				redraw(null);
			}
		}
		private var _tool:TransformTool;
		
		public function ControlBase(cursor:CursorBase = null){
			super();
			this.cursor = cursor;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		// event handlers
		protected function addedToStage(event:Event):void {
			var tool:TransformTool = parent as TransformTool;
			if (tool){
				this.tool = tool;
				draw(); // drawing deferred until tool is set
			}else{
				this.tool = null;
			}
		}
		
		protected function removedFromStage(event:Event):void {
			cleanupActiveMouseHandlers();
			this.tool = null;
		}
		
		protected function targetChanged(event:Event):void {
			cleanupActiveMouseHandlers();
		}
		
		protected function restrict(event:Event):void {
			// to be overridden
		}
		
		protected function draw():void {
			// to be overridden
		}
		
		protected function redraw(event:Event):void {
			if (_cursor != null){
				_cursor.redraw(event);
			}
		}
		
		protected function rollOver(event:MouseEvent):void {
			if (_cursor != null){
				if (!_tool.isActive){
					_tool.setCursor(_cursor, event);
				}
			}
		}
		
		protected function rollOut(event:MouseEvent):void {
			if (_cursor != null){
				if (!_tool.isActive && activeTarget == null){
					_tool.setCursor(null);
				}
			}
		}
		
		protected function mouseDown(event:MouseEvent):void {
			activeMouseEvent = event;
			setupActiveMouseHandlers();
			_tool.update();
			updateBaseReferences();
		}
		
		protected function activeMouseMove(event:MouseEvent):void {
			activeMouseEvent = event;
			updateMouseReferences();
		}
		
		protected function activeMouseUp(event:MouseEvent):void {
			activeMouseEvent = null;
			_tool.commitTarget();
			cleanupActiveMouseHandlers();
		}
		
		protected function activeMouseUpAtTarget(event:MouseEvent):void {
			if (event.eventPhase == EventPhase.AT_TARGET){
				activeMouseUp(event);
			}
		}
		
		protected function mouseUp(event:MouseEvent):void {
			_tool.setCursor(_cursor);
		}
		
		protected function setupActiveMouseHandlers():void {
			activeTarget = null;
			
			if (stage && loaderInfo && loaderInfo.parentAllowsChild){
				activeTarget = stage;
			}else if (root){
				activeTarget = root;
				// since without the stage, we can't identify mouse-up-outside
				// events, we have to resort to using the rolling out of the
				// content we actually have access to getting events from 
				activeTarget.addEventListener(MouseEvent.ROLL_OUT, activeMouseUp);
			}
			
			if (activeTarget){
				_tool.isActive = true;
				activeTarget.addEventListener(MouseEvent.MOUSE_MOVE, activeMouseMove);
				// Capture phase used here in case the interaction
				// target, or some other object within its hierarchy
				// stops propagation of the event preventing the
				// tool from recognizing the completion of its use
				activeTarget.addEventListener(MouseEvent.MOUSE_UP, activeMouseUp, true);
				activeTarget.addEventListener(MouseEvent.MOUSE_UP, activeMouseUpAtTarget, false);
			}
			
			// listen for restrict event to handle restrictions properly
			_tool.addEventListener(TransformTool.RESTRICT, restrict);
		}
		
		protected function cleanupActiveMouseHandlers():void {
			if (activeTarget){
				activeTarget.removeEventListener(MouseEvent.ROLL_OUT, activeMouseUp);
				activeTarget.removeEventListener(MouseEvent.MOUSE_MOVE, activeMouseMove);
				activeTarget.removeEventListener(MouseEvent.MOUSE_UP, activeMouseUp, true);
				activeTarget.removeEventListener(MouseEvent.MOUSE_UP, activeMouseUpAtTarget, false);
				activeTarget = null;
				_tool.isActive = false;
			}
			_tool.removeEventListener(TransformTool.RESTRICT, restrict);
			
			if (_tool.cursor == _cursor){
				_tool.setCursor(null);
			}
		}
		
		protected function updateBaseReferences():void {
			// define base transforms and registration points
			var baseLocalMatrix:Matrix = _tool.baseTransform;
			baseLocalMatrixInverted = baseLocalMatrix.clone();
			baseLocalMatrixInverted.invert();
			
			baseLocalRegistration = _tool.localRegistration;
			baseParentRegistration = baseLocalMatrix.transformPoint(baseLocalRegistration);
			
			// set base mouse references
			updateMousePositions();
			
			baseParentX = parentMouse.x + parentOffset.x - baseParentRegistration.x;
			baseParentY = parentMouse.y + parentOffset.y - baseParentRegistration.y;
			
			var localOffset:Point = baseLocalMatrixInverted.deltaTransformPoint(parentOffset);
			baseLocalX = localMouse.x + localOffset.x - baseLocalRegistration.x;
			baseLocalY = localMouse.y + localOffset.y - baseLocalRegistration.y;
		}
		
		protected function updateMouseReferences():void {
			// set active (current) mouse references
			updateMousePositions();
			
			activeParentX = parentMouse.x + parentOffset.x - baseParentRegistration.x;
			activeParentY = parentMouse.y + parentOffset.y - baseParentRegistration.y;
			
			var localOffset:Point = baseLocalMatrixInverted.deltaTransformPoint(parentOffset);
			activeLocalX = localMouse.x + localOffset.x - baseLocalRegistration.x;
			activeLocalY = localMouse.y + localOffset.y - baseLocalRegistration.y;
		}
		
		protected function updateMousePositions(event:MouseEvent = null):void {
			if (event == null){
				event = activeMouseEvent;
			}
			
			// if the current mouse event is the event that was
			// associated with setting the tool's target, check
			// to see if the original mouse location is available
			// to reference (pre target updates). Otherwise use the
			// mouse locations available in the event
			if (event == _tool.targetEvent && _tool.targetEventMouse){
				parentMouse = _tool.targetEventMouse.clone();
			}else{
				parentMouse = new Point(event.stageX, event.stageY);
			}
			
			if (_tool.target.parent != null){
				parentMouse = _tool.target.parent.globalToLocal(parentMouse);
			}
			
			localMouse = baseLocalMatrixInverted.transformPoint(parentMouse);
		}
		
		protected function updateTool(commit:Boolean = true):void {
			_tool.calculateTransform();
			_tool.update(commit);
		}
		
		protected function move():void {
			_tool.postTransform.translate(activeParentX - baseParentX, activeParentY - baseParentY);
		}
		
		protected function moveRegistration():void {
			var reg:Point = _tool.localRegistration;
			reg.x = localMouse.x;
			reg.y = localMouse.y;
		}
		
		protected function skewXAxis():void {
			if (Math.abs(baseLocalY) >= MIN_SCALE_BASE){
				_tool.preTransform.c = (activeLocalX - baseLocalX)/baseLocalY;
			}
		}

		protected function skewYAxis():void {
			if (Math.abs(baseLocalX) >= MIN_SCALE_BASE){
				_tool.preTransform.b = (activeLocalY - baseLocalY)/baseLocalX;
			}
		}
		
		protected function scaleXAxis():void {
			if (Math.abs(baseLocalX) >= MIN_SCALE_BASE){
				_tool.preTransform.scale(activeLocalX/baseLocalX, 1);
			}
		}
		
		protected function scaleYAxis():void {
			if (Math.abs(baseLocalY) >= MIN_SCALE_BASE){
				_tool.preTransform.scale(1, activeLocalY/baseLocalY);
			}
		}
		
		protected function scale():void {
			var sx:Number = (Math.abs(baseLocalX) >= MIN_SCALE_BASE) ? activeLocalX/baseLocalX : 1;
			var sy:Number = (Math.abs(baseLocalY) >= MIN_SCALE_BASE) ? activeLocalY/baseLocalY : 1;
			
			if (sx != 1 || sy != 1){
				_tool.preTransform.scale(sx, sy);
			}
		}
		
		protected function uniformScale():void {
			var sx:Number = (Math.abs(baseLocalX) >= MIN_SCALE_BASE) ? activeLocalX/baseLocalX : 1;
			var sy:Number = (Math.abs(baseLocalY) >= MIN_SCALE_BASE) ? activeLocalY/baseLocalY : 1;
			
			if (sx != 1 || sy != 1){
				
				// find the ratio to make the scaling
				// uniform in both the x and y axes
				var ratioX:Number = sy ? Math.abs(sx/sy) : 0;
				var ratioY:Number = sx ? Math.abs(sy/sx) : 0;
				
				// for 0 scale, scale both axises to 0
				if (ratioX == 0 || ratioY == 0){
					sx = 0;
					sy = 0;
					
				// scale mased on the smaller ratio
				}else if (ratioX > ratioY){
					sx *= ratioY;
				}else{
					sy *= ratioX;
				}
				
				_tool.preTransform.scale(sx, sy);
			}
		}
		
		protected function rotate():void {
			var baseAngle:Number = Math.atan2(baseParentY, baseParentX);
			var activeAngle:Number = Math.atan2(activeParentY, activeParentX);
			_tool.postTransform.rotate(activeAngle - baseAngle);
		}
	}
}