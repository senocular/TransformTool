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
	
	public class CursorRotate extends CursorBase {

		public function CursorRotate() {
			super();
		}
		
		override protected function draw():void {
			super.draw();
			
			// don't draw anything if something
			// has been added as a child to
			// this display object as a "skin"
			if (numChildren) return;
			
			var angle1:Number = Math.PI;
			var angle2:Number = -Math.PI/2;
			with(graphics){
				clear();
				beginFill(0x000000);
				lineStyle(1, 0xFFFFFF);
				this.drawArc(0,0,4, angle1, angle2, true);
				this.drawArc(0,0,6, angle2, angle1, false);
				// arrow
				lineTo(-8, 0);
				lineTo(-5, 4);
				lineTo(-2, 0);
				lineTo(-4, 0);
				endFill();
			}
		}
		
		private function drawArc(originX:Number, originY:Number, radius:Number, angle1:Number, angle2:Number, useMove:Boolean = true):void {
			var diff:Number = angle2 - angle1;
			var divs:int = 1 + Math.floor(Math.abs(diff)/(Math.PI/4));
			var span:Number = diff/(2*divs);
			var cosSpan:Number = Math.cos(span);
			var radiusc:Number = cosSpan ? radius/cosSpan : 0;
			if (useMove) {
				graphics.moveTo(originX + Math.cos(angle1)*radius, originY - Math.sin(angle1)*radius);
			}else{
				graphics.lineTo(originX + Math.cos(angle1)*radius, originY - Math.sin(angle1)*radius);
			}
			var i:int;
			for (i=0; i<divs; i++) {
				angle2 = angle1 + span;
				angle1 = angle2 + span;
				graphics.curveTo(
					originX + Math.cos(angle2)*radiusc, originY - Math.sin(angle2)*radiusc,
					originX + Math.cos(angle1)*radius, originY - Math.sin(angle1)*radius
				);
			}
		}
	}	
}
