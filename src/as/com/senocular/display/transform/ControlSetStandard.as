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
	
	public dynamic class ControlSetStandard extends Array {
		
		public function ControlSetStandard(){
			
			var moveCursor:CursorMove = new CursorMove();
			var rotateCursor:CursorRotate = new CursorRotate();
			var scaleCursorY:CursorScale = new CursorScale(ControlUVScale.Y_AXIS, 0);
			var scaleCursorX:CursorScale = new CursorScale(ControlUVScale.X_AXIS, 0);
			var scaleCursorB:CursorScale = new CursorScale(ControlUVScale.BOTH, 0);
			var scaleCursorB90:CursorScale = new CursorScale(ControlUVScale.BOTH, 90);
			var registrationCursor:CursorRegistration = new CursorRegistration();
			
			var rotate00:ControlUVRotate = new ControlUVRotate(0, 0, rotateCursor);
			rotate00.scaleX = 3;
			rotate00.scaleY = 3;
			rotate00.alpha = 0;
			var rotate01:ControlUVRotate = new ControlUVRotate(0, 1, rotateCursor);
			rotate01.scaleX = 3;
			rotate01.scaleY = 3;
			rotate01.alpha = 0;
			var rotate10:ControlUVRotate = new ControlUVRotate(1, 0, rotateCursor);
			rotate10.scaleX = 3;
			rotate10.scaleY = 3;
			rotate10.alpha = 0;
			var rotate11:ControlUVRotate = new ControlUVRotate(1, 1, rotateCursor);
			rotate11.scaleX = 3;
			rotate11.scaleY = 3;
			rotate11.alpha = 0;
			
			super(
				new ControlBorder(),
				new ControlMove(moveCursor),
				rotate00,
				rotate01,
				rotate10,
				rotate11,
				new ControlUVScale(.5, 0, ControlUVScale.Y_AXIS, scaleCursorY),
				new ControlUVScale(0, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(1, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(.5, 1, ControlUVScale.Y_AXIS, scaleCursorY),
				new ControlUVScale(0, 0, ControlUVScale.BOTH, scaleCursorB),
				new ControlUVScale(0, 1, ControlUVScale.BOTH, scaleCursorB90),
				new ControlUVScale(1, 0, ControlUVScale.BOTH, scaleCursorB90),
				new ControlUVScale(1, 1, ControlUVScale.BOTH, scaleCursorB),
				new ControlRegistration(registrationCursor),
				new ControlCursor()
			);
		}
	}
}