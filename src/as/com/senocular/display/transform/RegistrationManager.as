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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Trevor McCauley
	 */
	public class RegistrationManager {

		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(value:Boolean):void {
			_enabled = value;
			if (_enabled == false){
				clear();
			}
		}
		private var _enabled:Boolean = true;
		
		/**
		 * Default registration point location based on
		 * UV coordinates (percent relative to target).
		 */
		public function get defaultUV():Point {
			return _defaultUV;
		}
		public function set defaultUV(value:Point):void {
			_defaultUV = value ? value.clone() : null;
		}
		private var _defaultUV:Point;
		
		protected var map:Dictionary;
		
		public function RegistrationManager() {
			map = new Dictionary(true);
		}
		
		public function clear(target:DisplayObject = null):void {
			if (target){
				delete map[target];
			}else{
				var key:Object;
				for (key in map){
					delete map[target];
				}
			}
		}
		
		public function contains(target:DisplayObject):Boolean {
			return target in map;
		}
		
		public function setRegistration(target:DisplayObject, point:Point):void {
			if (_enabled && target && point){
				map[target] = point.clone();
			}
		}
		
		public function getRegistration(target:DisplayObject):Point {
			if (target == null){
				return null;
			}
			
			var result:Point = map[target] as Point;
			if (result){
				return result;
			}
			
			if (_defaultUV){
				var bounds:Rectangle = target.getBounds(target);
				return new Point(
					bounds.x + bounds.width * _defaultUV.x, 
					bounds.y + bounds.height * _defaultUV.y
				);
			}
			
			return null;
		}
	}
}