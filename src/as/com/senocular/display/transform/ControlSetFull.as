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
	
	public dynamic class ControlSetFull extends Array {
		
		public function ControlSetFull(){
			
			var moveCursor:CursorMove = new CursorMove();
			var skewCursorX:CursorSkew = new CursorSkew(ControlUVSkewBar.X_AXIS);
			var skewCursorY:CursorSkew = new CursorSkew(ControlUVSkewBar.Y_AXIS);
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
			
			
			var rotateHandle:ControlUVRotate = new ControlUVRotate(.5, 0, rotateCursor);
			rotateHandle.offsetV = -20;
			var scaleHandle:ControlUVScale = new ControlUVScale(.5, 0, ControlUVScale.Y_AXIS, scaleCursorY);
			var handle:ControlConnector = new ControlConnector(rotateHandle, scaleHandle);
			
			var scaleTL:ControlUVScale = new ControlUVScale(0, 0, ControlUVScale.BOTH, scaleCursorB);
			var scaleBR:ControlUVScale = new ControlUVScale(1, 1, ControlUVScale.BOTH, scaleCursorB);
			var crossTLtoBR:ControlConnector = new ControlConnector(scaleTL, scaleBR);
			
			var scaleTR:ControlUVScale = new ControlUVScale(0, 1, ControlUVScale.BOTH, scaleCursorB90);
			var scaleBL:ControlUVScale = new ControlUVScale(1, 0, ControlUVScale.BOTH, scaleCursorB90);
			var crossTRtoBL:ControlConnector = new ControlConnector(scaleTR, scaleBL);
			
			super(
				new ControlBorder(),
				new ControlBoundingBox(),
				handle,
				crossTLtoBR,
				crossTRtoBL,
				new ControlOrigin(),
				new ControlMove(moveCursor),
				new ControlUVSkewBar(0, 0, 1, 0, ControlUVSkewBar.X_AXIS, skewCursorX),
				new ControlUVSkewBar(1, 0, 1, 1, ControlUVSkewBar.Y_AXIS, skewCursorY),
				new ControlUVSkewBar(1, 1, 0, 1, ControlUVSkewBar.X_AXIS, skewCursorX),
				new ControlUVSkewBar(0, 1, 0, 0, ControlUVSkewBar.Y_AXIS, skewCursorY),
				rotate00,
				rotate01,
				rotate10,
				rotate11,
				rotateHandle,
				scaleHandle,
				new ControlUVScale(0, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(1, .5, ControlUVScale.X_AXIS, scaleCursorX),
				new ControlUVScale(.5, 1, ControlUVScale.Y_AXIS, scaleCursorY),
				scaleTL,
				scaleTR,
				scaleBL,
				scaleBR,
				new ControlReset(),
				new ControlRegistration(registrationCursor),
				new ControlCursor()
			);
		}
	}
}