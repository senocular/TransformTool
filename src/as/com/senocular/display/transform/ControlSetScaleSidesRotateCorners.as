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
	
	public dynamic class ControlSetScaleSidesRotateCorners extends Array {
		
		public function ControlSetScaleSidesRotateCorners(){
			
			var rotateCursor:CursorRotate = new CursorRotate();
			var scaleCursorY:CursorScale = new CursorScale(ControlUVScale.Y_AXIS, 0);
			var scaleCursorX:CursorScale = new CursorScale(ControlUVScale.X_AXIS, 0);
			
			super(
				new ControlBorder(),
				new ControlMove(new CursorMove()),
				new ControlUVRotate(0, 0, rotateCursor),
				new ControlUVRotate(0, 1, rotateCursor),
				new ControlUVRotate(1, 0, rotateCursor),
				new ControlUVRotate(1, 1, rotateCursor),
				new ControlUVScale(.5, 0, ControlUVScale.Y_AXIS, scaleCursorY),
				new ControlUVScale(0, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(1, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(.5, 1, ControlUVScale.Y_AXIS, scaleCursorY),
				new ControlRegistration(new CursorRegistration()),
				new ControlCursor()
			);
		}
	}
}