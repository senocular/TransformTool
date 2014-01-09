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
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
		
	/*
	NEW:
		Simpler
		Modular
		New Features
			- Set transforms through width/height rather than the matrix (for components)
			- Protection against 0-value transforms
			- Min/max values
			- Selection helper event handlers
	*/
	public class TransformTool extends Sprite {
		
		private static const TO_DEGREES:Number = (180/Math.PI);
		private static const TO_RADS:Number = (Math.PI/180);
		
		// transform types
		public static const TRANSFORM_MATRIX:String = "matrix";
		public static const TRANSFORM_PROPERTIES:String = "properties";
		
		// events
		public static const CURSOR_CHANGED:String = "cursorChanged";
		public static const TARGET_CHANGED:String = "targetChanged";
		public static const TRANSFORM_CHANGED:String = "transformChanged";
		public static const TARGET_TRANSFORMED:String = "targetTransformed";
		public static const REDRAW:String = "redraw";
		public static const RESTRICT:String = "restrict";
		
		/**
		 * Compares two matrices to see if they're equal.
		 */
		private static function matrixEquals(m1:Matrix, m2:Matrix):Boolean {
			if (m1.a != m2.a
			||  m1.d != m2.d
			||  m1.b != m2.b
			||  m1.c != m2.c
			||  m1.tx != m2.tx
			||  m1.ty != m2.ty){
				return false;
			}
			return true;
		}
		
		public function get cursor():DisplayObject {
			return _cursor;
		}
		public function set cursor(value:DisplayObject):void {
			setCursor(value, null);
		}
		public function setCursor(value:DisplayObject, cursorEvent:Event = null):void {
			_cursorEvent = value ? cursorEvent : null;
			if (value == _cursor){
				return;
			}
			_cursor = value;
			dispatchEvent( new Event(CURSOR_CHANGED) );
		}
		private var _cursor:DisplayObject;
		
		public function get cursorEvent():Event { return _cursorEvent; }
		protected var _cursorEvent:Event;
		
		public function get registrationManager():RegistrationManager {
			return _registrationManager;
		}
		public function set registrationManager(value:RegistrationManager):void {
			if (value){
				_registrationManager = value;
			}else{
				throw new ArgumentError("Parameter registrationManager must be non-null");
			}
		}
		private var _registrationManager:RegistrationManager;
		
		public function get localRegistration():Point {
			return _localRegistration;
		}
		private var _localRegistration:Point = new Point(0, 0);
		
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void { _minWidth = value; }
		private var _minWidth:Number;
		
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void { _maxWidth = value; }
		private var _maxWidth:Number;
		
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void { _minHeight = value; }
		private var _minHeight:Number;
		
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void { _maxHeight = value; }
		private var _maxHeight:Number;
		
		public function get minScaleX():Number { return _minScaleX; }
		public function set minScaleX(value:Number):void { _minScaleX = value; }
		private var _minScaleX:Number;
		
		public function get maxScaleX():Number { return _maxScaleX; }
		public function set maxScaleX(value:Number):void { _maxScaleX = value; }
		private var _maxScaleX:Number;
		
		public function get minScaleY():Number { return _minScaleY; }
		public function set minScaleY(value:Number):void { _minScaleY = value; }
		private var _minScaleY:Number;
		
		public function get maxScaleY():Number { return _maxScaleY; }
		public function set maxScaleY(value:Number):void { _maxScaleY = value; }
		private var _maxScaleY:Number;
		
		public function get negativeScaling():Boolean { return _negativeScaling; }
		public function set negativeScaling(value:Boolean):void { _negativeScaling = value; }
		private var _negativeScaling:Boolean = true;
		
		public function get minRotation():Number { return _minRotation; }
		public function set minRotation(value:Number):void { _minRotation = value; }
		private var _minRotation:Number;
		
		public function get maxRotation():Number { return _maxRotation; }
		public function set maxRotation(value:Number):void { _maxRotation = value; }
		private var _maxRotation:Number;
		
		// lookups
		public var registration:Point = new Point();
		public var topLeft:Point = new Point();
		public var topRight:Point = new Point();
		public var bottomLeft:Point = new Point();
		public var bottomRight:Point = new Point();
		
		/**
		 * Target display object to be transformed by the TransformTool.
		 */
		public function get target():DisplayObject {
			return _target;
		}
		public function set target(value:DisplayObject):void {
			setTarget(value, null);
		}
		public function setTarget(value:DisplayObject, targetEvent:Event = null):void {
			
			_targetEvent = value ? targetEvent : null;
			var targetMouseEvent:MouseEvent = _targetEvent as MouseEvent;
			if (targetMouseEvent){
				_targetEventMouse = new Point(targetMouseEvent.stageX, targetMouseEvent.stageY);
			}else{
				_targetEventMouse = null;
			}
			
			if (value == _target){
				return;
			}
			
			// update the saved registration point for 
			// the old target so it can be referenced
			// when the tool is reassigned to it later
			_registrationManager.setRegistration(_target, _localRegistration);
			
			_target = value;
			assignRegistration();
			
			if (_target){
				visible = true;
				
				if (_autoRaise){
					raise();
				}
				
				fitToTarget();
				
			}else{
				visible = false;
			}
			
			dispatchEvent( new Event(TARGET_CHANGED) );
		}
		private var _target:DisplayObject;
		
		/**
		 * A saved reference to the event that selected the
		 * target when TransformTool.select was used. This allows
		 * controls to use that event to perform appropriate actions
		 * during selection, such as starting a drag (move) operation
		 * on the target.
		 */
		public function get targetEvent():Event { return _targetEvent; }
		protected var _targetEvent:Event;
		
		public function get targetEventMouse():Point { return _targetEventMouse; }
		protected var _targetEventMouse:Point;
		
		public function get controls():Array {
			var value:Array = []; // objects in display list
			
			// loop through display list one child at a time
			// adding them to the return value array
			var i:int = numChildren;
			while(i--){
				value[i] = getChildAt(i);
			}
			
			return value;
		}
		public function set controls(value:Array):void {
			var child:DisplayObject; // child to be added
			var childrenOffset:int = 0; // number of invalid children in array
			
			// loop through array adding a display list child
			// for each child in the value array
			var i:int, n:int = value ? value.length : 0;
			for (i=0; i<n; i++){
				
				// when a valid child is found
				child = value[i] as DisplayObject;
				if (child){
					
					// check the parent as it may already exist
					// within this display list
					if (child.parent == this){
						
						// if already in the display list, set
						// the sorting value to match it's position
						// in the array
						setChildIndex(child, i - childrenOffset);
					}else{
						
						// if not already in the display list
						// add the child to it at the location
						// matching it's position in the array
						addChildAt(child, i - childrenOffset);
					}
				}else{
					
					// count of invalid children. when an invalid
					// child is found, this offset is used to
					// offset the position of other children
					// added to the display list since the spot
					// the invalid child would have taken is no
					// longer being used
					childrenOffset++;
				}
			}
			
			// remove any children from the end of the
			// display list that would have been left over
			// from the original display list layout
			var end:int = n - childrenOffset;
			while (numChildren > end){
				removeChildAt(end);
			}
		}
		
		public function get preTransform():Matrix { return _preTransform; }
		protected var _preTransform:Matrix = new Matrix();
		
		public function get baseTransform():Matrix { return _baseTransform; }
		protected var _baseTransform:Matrix = new Matrix();
		
		public function get postTransform():Matrix { return _postTransform; }
		protected var _postTransform:Matrix = new Matrix();
		
		public function get toolTransform():Matrix { return _toolTransform; }
		protected var _toolTransform:Matrix = new Matrix();
		
		
		/**
		 * Determines the method by which tool transformations 
		 * are applied to the target display object.
		 */
		public function get transformStyle():String { return _transformStyle; }
		public function set transformStyle(value:String):void { _transformStyle = value; }
		private var _transformStyle:String = TRANSFORM_MATRIX;
		
		
		public function get livePreview():Boolean { return _livePreview; }
		public function set livePreview(value:Boolean):void { _livePreview = value; }
		private var _livePreview:Boolean = true;
		
		
		public function get autoRaise():Boolean { return _autoRaise; }
		public function set autoRaise(value:Boolean):void { _autoRaise = value; }
		private var _autoRaise:Boolean = false;
		
		/**
		 * Indicates that a transform control has assumed control
		 * of the tool for interaction.  Other controls would check
		 * this value to see if it is able to interact with the
		 * tool without interference from other controls.
		 */
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void { _isActive = value; }
		private var _isActive:Boolean = false;
		
		
		public function TransformTool(controls:Array = null){
			if (controls){
				this.controls = controls;
			}
			visible = false;
			
			_registrationManager = new RegistrationManager();
		}
		
		public function select(event:Event):void {
			// the selected object will either be the
			// event target or current target. The current
			// target is checked first followed by target.
			// The parent of the target must match the
			// parent of the tool to be selected this way.
			
			if (event.currentTarget != this 
			&& event.currentTarget.parent == parent){
				
				setTarget(event.currentTarget as DisplayObject, event);
				
			}else if (event.target != this 
			&& event.target.parent == parent){
				
				setTarget(event.target as DisplayObject, event);
				
			}
		}
		
		public function deselect(event:Event):void {
			if (_target != null && event.eventPhase == EventPhase.AT_TARGET){
				setTarget(null, null);
			}
		}
		
		public function fitToTarget():void {
			if (_target == null){
				return;
			}
			
			resetTransformModifiers();
			calculateTransform();
			update();
		}
		
		public function raise():void {
			var container:DisplayObjectContainer;					
			
			// raise target first
			if (_target){
				container = _target.parent;
				if (container){
					container.setChildIndex(_target, container.numChildren - 1);
				}
			}
			
			// raise the tool second
			// to go above the target
			container = this.parent;
			if (container){
				container.setChildIndex(this, container.numChildren - 1);
			}
		}
		
		public function calculateTransform():void {
			
			// our final transform starts with the preTransform
			// followed by the base transform of the last commit point
			_toolTransform.identity();
			_toolTransform.concat(_preTransform);
			_toolTransform.concat(_baseTransform);
			
			// next, the post transform is concatenated on top
			// of the previous result, but for the post transform,
			// translation (x,y) values are not transformed. They're
			// saved with the respective post transform offset, then 
			// reassigned after concatenating the post transformation
			var tx:Number = _toolTransform.tx + _postTransform.tx;
			var ty:Number = _toolTransform.ty + _postTransform.ty;
			
			// finally, concatenate post transform on to final
			_toolTransform.concat(_postTransform);
			
			// reassign saved tx and ty values with the 
			// included registration offset
			_toolTransform.tx = tx;
			_toolTransform.ty = ty;
			
			restrict();
			
			// registration handling is done after
			// all transforms; the tool has to re-position
			// itself so that the new position of the
			// registration point now matches the old
			applyRegistrationOffset();
			
			updateMetrics();
			resetTransformModifiers(false);
			
			dispatchEvent( new Event(TRANSFORM_CHANGED) );
		}
		
		public function resetRegistration():void {
			_localRegistration.x = 0;
			_localRegistration.y = 0;
			
			// the only metrics that need updating as
			// as result of local registration changing
			registration = _toolTransform.transformPoint(_localRegistration);
		}
		
		public function resetTransform():void {
			resetTransformModifiers(false);
			
			// counter base transform with an inverted
			// post transform.  This will transform the
			// target to the identity (reset) transform.
			_postTransform.identity();
			_postTransform.concat(_baseTransform);
			_postTransform.invert();
			
			// do not transform position
			_postTransform.tx = 0;
			_postTransform.ty = 0;
			
			// calc transform to apply updated base
			// to final transform as well as handle
			// restrictions etc.  For restrictions
			// we need to temporarily turn negative
			// scaling on if not already to make sure
			// the transform can be properly reset and
			// not restricted in that manner
			
			var originalNegativeScaling:Boolean = _negativeScaling;
			_negativeScaling = true;
			
			calculateTransform();
			
			_negativeScaling = originalNegativeScaling;
		}
		
		public function update(commit:Boolean = true):void {
			if (commit){
				commitTarget();
			}else{
				updateTarget();
			}
			updateControls();
		}
		
		public function updateControls():void {
			dispatchEvent( new Event(REDRAW) );
		}
		
		public function updateTarget():void {
			if (_livePreview){
				if (applyTransformToTarget()){
					dispatchEvent( new Event(TARGET_TRANSFORMED) );
				}
			}
		}
		
		public function commitTarget():void {
			var transformed:Boolean = applyTransformToTarget();
			resetTransformModifiers();
			if (transformed){
				dispatchEvent( new Event(TARGET_TRANSFORMED) );
			}
		}
		
		protected function validateTargetMatrix():void {
			if (_target && _target.transform.matrix == null){
				_target.transform.matrix = new Matrix(1, 0, 0, 1, _target.x, _target.y);
			}
		}
		
		protected function updateMetrics():void {
			var bounds:Rectangle = _target.getBounds(_target);
			
			registration = _toolTransform.transformPoint(_localRegistration);
			
			var referencePoint:Point = new Point(bounds.left, bounds.top);
			topLeft = _toolTransform.transformPoint(referencePoint);
			
			referencePoint.x = bounds.right;
			topRight = _toolTransform.transformPoint(referencePoint);
			
			referencePoint.y = bounds.bottom;
			bottomRight = _toolTransform.transformPoint(referencePoint);
			
			referencePoint.x = bounds.left;
			bottomLeft = _toolTransform.transformPoint(referencePoint);
		}
		
		protected function applyTransformToTarget():Boolean {
			
			// if the target transform already matches the
			// calculated tansform of the tool, don't update
			validateTargetMatrix();
			if (matrixEquals(_target.transform.matrix, _toolTransform)){
				return false;
			}
			
			switch (_transformStyle){
				
				case TRANSFORM_MATRIX:{
					
					// assign adjusted matrix directly to
					// the matrix of the target instance
					_target.transform.matrix = _toolTransform;
					break;
				}
				
				case TRANSFORM_PROPERTIES:{
				
					// get the internal boundaries of the target instance
					// this is used to set the appropriate size
					var bounds:Rectangle = _target.getBounds(_target);
					
					if (bounds.width == 0 || bounds.height == 0){
						// cannot set the size of an object with no content
						// doing so can corrupt the object's dimensions
						return false;
					}
					
					// first, any rotation needs to be removed so that
					// applications of width and height are accurate
					_target.rotation = 0;
					
					// get necessary transform data from the matrix
					// this is limited to size and rotation. Skew
					// transforms cannot be applied through 
					// non-matrix properties
					var ratioX:Number = Math.sqrt(_toolTransform.a*_toolTransform.a + _toolTransform.b*_toolTransform.b);
					var ratioY:Number = Math.sqrt(_toolTransform.c*_toolTransform.c + _toolTransform.d*_toolTransform.d);
					var angle:Number = Math.atan2(_toolTransform.b, _toolTransform.a);
					
					// assign width and height followed by rotation
					_target.width = bounds.width * ratioX;
					_target.height = bounds.height * ratioY;
					_target.rotation = angle * TO_DEGREES;
					break;
				}
				
				default:{
					// unrecognized transform type
					// do nothing
					return false;
					break;
				}
			}
			
			return true;
		}
		
		protected function resetTransformModifiers(resetBase:Boolean = true):void {
			_preTransform.identity();
			_postTransform.identity();
			
			if (resetBase){
				_baseTransform.identity();
				
				if (_target != null){
					validateTargetMatrix();
					_baseTransform.concat( _target.transform.matrix );
					
					// protect against 0-valued scales giving
					// each axis an implied size of 1 pixel if 
					// their scale starts as 0
					var bounds:Rectangle = _target.getBounds(_target);
					if (_baseTransform.a == 0 && bounds.width != 0){
						_baseTransform.a = 1/bounds.width;
					}
					if (_baseTransform.d == 0 && bounds.height != 0){
						_baseTransform.d = 1/bounds.height;
					}
					
					// flip the transform (if inverted and mirroring is
					// not permitted) around the axis that would be more
					// appropriate to flip around - the one which would
					// get the transform getting closest to right-side-up
					if (!_negativeScaling && !isPositiveScale(_baseTransform)){
						var baseRotation:Number = Math.atan2(_baseTransform.a + _baseTransform.c, _baseTransform.d + _baseTransform.b);
						if (baseRotation < -(3*Math.PI/4) || baseRotation > (Math.PI/4)){
							_toolTransform.c = -_toolTransform.c;
							_toolTransform.d = -_toolTransform.d;
						}else{
							_toolTransform.a = -_toolTransform.a;
							_toolTransform.b = -_toolTransform.b;
						}
					}
				}
			}
		}
		
		protected function assignRegistration():void {				
			var saved:Point = _registrationManager.getRegistration(_target);
			if (saved){
				_localRegistration.x = saved.x;
				_localRegistration.y = saved.y;
			}else{
				_localRegistration.x = 0;
				_localRegistration.y = 0;
			}
		}
		
		/**
		 * Adds registration offset to transformation matrix. This
		 * assumes deriveFinalTransform has already been called.
		 */
		protected function applyRegistrationOffset():void {
			if (_localRegistration.x != 0 || _localRegistration.y != 0){
				
				// the registration offset is the change in x and y
				// of the pseudo registration point since the 
				// transformation occurred.  At this point, the final
				// transform should all ready be calculated
				var parentReg:Point = _baseTransform.deltaTransformPoint(_localRegistration);
				var regOffset:Point = _toolTransform.deltaTransformPoint(_localRegistration);
				regOffset = parentReg.subtract(regOffset);
				_toolTransform.translate(regOffset.x, regOffset.y);
			}
		}
		
		/**
		 * Goes under the assumption that scaling is handled by
		 * the preTransform and rotation is handled by the
		 * postTransform matrices.
		 */
		protected function restrict():void {
			
			// dispatch a cancelable RESTRICT event.
			// if the event is canceled, don't perform
			// the restict operations. Controls may do
			// this if they want to implement restrictions
			// on their own and not have interference
			// from the normal tool operations
			var restrictEvent:Event = new Event(RESTRICT, false, true);
			dispatchEvent(restrictEvent);
			if (restrictEvent.isDefaultPrevented()){
				return;
			}
			
			restrictScale();
			restrictRotation();
		}
		
		public function restrictScale():void {
			var bounds:Rectangle = _target.getBounds(_target);
			
			// cannot scale an object with no size
			if (bounds.width == 0 || bounds.height == 0){
				return;
			}
			
			// find the values of min and max to use for
			// scale.  Since these can come from either
			// width/height or scaleX/scaleY, both are
			// first checked for a value and then, if both
			// are set, the smallest variation is used.
			// if neither are set, the value will be
			// defined as NaN.
			
			var minX:Number;
			if (isNaN(_minWidth)){
				minX = _minScaleX;
			}else{
				if (isNaN(_minScaleX)){
					minX = _minWidth/bounds.width;
				}else{
					minX = Math.max(_minScaleX, _minWidth/bounds.width);
				}
			}
			
			var maxX:Number;
			if (isNaN(_maxWidth)){
				maxX = _maxScaleX;
			}else{
				if (isNaN(_maxScaleX)){
					maxX = _maxWidth/bounds.width;
				}else{
					maxX = Math.min(_maxScaleX, _maxWidth/bounds.width);
				}
			}
			
			var minY:Number;
			if (isNaN(_minHeight)){
				minY = _minScaleY;
			}else{
				if (isNaN(_minScaleY)){
					minY = _minHeight/bounds.height;
				}else{
					minY = Math.max(_minScaleY, _minHeight/bounds.height);
				}
			}
			
			var maxY:Number;
			if (isNaN(_maxHeight)){
				maxY = _maxScaleY;
			}else{
				if (isNaN(_maxScaleY)){
					maxY = _maxHeight/bounds.height;
				}else{
					maxY = Math.min(_maxScaleY, _maxHeight/bounds.height);
				}
			}
			
			// make sure each limit is positive
			if (minX < 0) minX = -minX;
			if (maxX < 0) maxX = -maxX;
			if (minY < 0) minY = -minY;
			if (maxY < 0) maxY = -maxY;
			
			var currScaleX:Number = Math.sqrt(_toolTransform.a*_toolTransform.a + _toolTransform.b*_toolTransform.b);
			var currScaleY:Number = Math.sqrt(_toolTransform.c*_toolTransform.c + _toolTransform.d*_toolTransform.d);
			
			// if negative scaling is not allowed
			// we need to figure out if the current scale
			// in either direction is going into the
			// negatives or not.  To do this, the angle
			// of each axis is compared against the base
			// transform angles
			if (!_negativeScaling){
				var currAngleX:Number = Math.atan2(_toolTransform.b, _toolTransform.a);
				var baseAngleX:Number = Math.atan2(_baseTransform.b, _baseTransform.a);
				if (currScaleX != 0 && Math.abs(baseAngleX - currAngleX) > Math.PI/2){
					currScaleX = -currScaleX;
				}
				var currAngleY:Number = Math.atan2(_toolTransform.c, _toolTransform.d);
				var baseAngleY:Number = Math.atan2(_baseTransform.c, _baseTransform.d);
				if (currScaleY != 0 && Math.abs(baseAngleY - currAngleY) > Math.PI/2){
					currScaleY = -currScaleY;
				}
			}
			
			
			var scale:Number; // limited scale; NaN if not scaling
			var angle:Number; // angle of scale when basing on base
			
			if (!isNaN(minX) && currScaleX < minX){
				scale = minX;
			}else if (!isNaN(maxX) && currScaleX > maxX){
				scale = maxX;
			}else{
				scale = Number.NaN;
			}
			
			if (!isNaN(scale)){
				if (currScaleX){
					scale = (scale/currScaleX);
					_toolTransform.a *= scale;
					_toolTransform.b *= scale;
				}else{
					angle = Math.atan2(_baseTransform.b, _baseTransform.a);
					_toolTransform.a = scale * Math.cos(angle);
					_toolTransform.b = scale * Math.sin(angle);
				}
			}
			
			if (!isNaN(minY) && currScaleY < minY){
				scale = minY;
			}else if (!isNaN(maxY) && currScaleY > maxY){
				scale = maxY;
			}else{
				scale = Number.NaN;
			}
			
			if (!isNaN(scale)){
				if (currScaleY){
					scale = (scale/currScaleY);
					_toolTransform.c *= scale;
					_toolTransform.d *= scale;
				}else{
					angle = Math.atan2(_baseTransform.c, _baseTransform.d);
					_toolTransform.c = scale * Math.sin(angle);
					_toolTransform.d = scale * Math.cos(angle);
				}
			}
			
			// undo any negative scaling
			if (!_negativeScaling && !isPositiveScale(_toolTransform)){
				
				// flip the final transform around the axis 
				// to best match the base
				var baseX:Number = _baseTransform.a + _baseTransform.c;
				var toolX:Number = _toolTransform.a + _toolTransform.c;
				if ((toolX < 0 && baseX >= 0) || (toolX >= 0 && baseX < 0)){
					_toolTransform.a = -_toolTransform.a;
					_toolTransform.b = -_toolTransform.b;
				}else{
					_toolTransform.c = -_toolTransform.c;
					_toolTransform.d = -_toolTransform.d;
				}
			}
		}
		
		public function isPositiveScale(matrix:Matrix = null):Boolean {
			if (matrix == null) matrix = _toolTransform;
			return Boolean(matrix.a*matrix.d - matrix.c*matrix.b > 0);
		}
		
		public function restrictRotation():void {
			// both min and max rotation need to be set
			// in order to restrict rotation
			
			if (!isNaN(_minRotation) && !isNaN(_maxRotation)){
				var min:Number = _minRotation * TO_RADS;
				var max:Number = _maxRotation * TO_RADS;
				
				var angle:Number = Math.atan2(_toolTransform.b, _toolTransform.a);
				
				// restrict to a single rotation value
				if (min == max){
					if (angle != min){
						setRotation(min);
					}
					
				// restricting to a range
				}else if (min < max){
					if (angle < min){
						setRotation(min);
					}else if (angle > max){
						setRotation(max);
					}
				}else if (angle < min && angle > max){
					if (Math.abs(angle - min) > Math.abs(angle - max)){
						setRotation(max);
					}else{
						setRotation(min);
					}
				}
			}
		}
		
		public function getRotation(matrix:Matrix = null):Number {
			return getRotationX(matrix);
		}
		
		public function getRotationX(matrix:Matrix = null):Number {
			if (matrix == null) matrix = _toolTransform;
			return Math.atan2(matrix.b, matrix.a);
		}
		
		public function getRotationY(matrix:Matrix = null):Number {
			if (matrix == null) matrix = _toolTransform;
			return Math.atan2(matrix.c, matrix.d);
		}
		
		public function setRotation(value:Number, matrix:Matrix = null):void {
			if (isNaN(value)) return;
			if (matrix == null) matrix = _toolTransform;
			
			var tx:Number = matrix.tx;
			var ty:Number = matrix.ty;
			var angle:Number = Math.atan2(matrix.b, matrix.a);
			matrix.rotate(value - angle);
			matrix.tx = tx;
			matrix.ty = ty;
		}
		
		public function getScaleX(matrix:Matrix = null):Number {
			if (matrix == null) matrix = _toolTransform;
			return Math.sqrt(_toolTransform.a*_toolTransform.a + _toolTransform.b*_toolTransform.b);
		}
		
		public function setScaleX(value:Number, matrix:Matrix = null):void {
			if (isNaN(value)) return;
			if (matrix == null) matrix = _toolTransform;
			
			var angle:Number = Math.atan2(matrix.b, matrix.a);
			matrix.a = value * Math.cos(angle);
			matrix.b = value * Math.sin(angle);
		}
		
		public function getScaleY(matrix:Matrix = null):Number {
			if (matrix == null) matrix = _toolTransform;
			return Math.sqrt(_toolTransform.c*_toolTransform.c + _toolTransform.d*_toolTransform.d);
		}
		
		public function setScaleY(value:Number, matrix:Matrix = null):void {
			if (isNaN(value)) return;
			if (matrix == null) matrix = _toolTransform;
			
			var angle:Number = Math.atan2(matrix.c, matrix.d);
			matrix.c = value * Math.sin(angle);
			matrix.d = value * Math.cos(angle);
		}
	}
}