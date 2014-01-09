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
	
	public class CursorMove extends CursorBase {
		
		public function CursorMove() {
			super();
		}
		
		override protected function draw():void {
			super.draw();
			
			// don't draw anything if something
			// has been added as a child to
			// this display object as a "skin"
			if (numChildren) return;
			
			with (graphics){
				clear();
				beginFill(0x000000);
				lineStyle(1, 0xFFFFFF);
				// up arrow
				moveTo(1, 1);
				lineTo(1, -2);
				lineTo(-1, -2);
				lineTo(2, -6);
				lineTo(5, -2);
				lineTo(3, -2);
				lineTo(3, 1);
				// right arrow
				lineTo(6, 1);
				lineTo(6, -1);
				lineTo(10, 2);
				lineTo(6, 5);
				lineTo(6, 3);
				lineTo(3, 3);
				// down arrow
				lineTo(3, 5);
				lineTo(3, 6);
				lineTo(5, 6);
				lineTo(2, 10);
				lineTo(-1, 6);
				lineTo(1, 6);
				lineTo(1, 5);
				// left arrow
				lineTo(1, 3);
				lineTo(-2, 3);
				lineTo(-2, 5);
				lineTo(-6, 2);
				lineTo(-2, -1);
				lineTo(-2, 1);
				lineTo(1, 1);
				endFill();
			}
		}
	}
}
