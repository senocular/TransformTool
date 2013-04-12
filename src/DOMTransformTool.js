function DOMTransformTool(container){
	DOMTransformTool.prototype._super.call(this, container);
}

DOMTransformTool.prototype = new TransformTool();
DOMTransformTool.prototype._super = TransformTool;
DOMTransformTool.prototype.constructor = DOMTransformTool;

DOMTransformTool.prototype.setControls = function(controls){
	// remove old, persistent svg elements
	if (this.controls){
		var i = 0;
		var n = this.controls.length;
		for (i=0; i<n; i++){
			this.controls[i].undraw(this.container);
		}
	}
	
	DOMTransformTool.prototype._super.prototype.setControls.call(this, controls);
};

DOMTransformTool.prototype.shouldDraw = function(){
	// always draws since dom elements persistent
	return true;
};

function DOMControl(type, u, v, offsetX, offsetY, size){
	DOMControl.prototype._super.call(this, type, u, v, offsetX, offsetY, size);
	this.id = DOMControl.idPrefix + (++DOMControl.idCounter);
}

DOMControl.idCounter = 0;
DOMControl.idPrefix = "-dom-control-";
DOMControl.prototype = new Control();
DOMControl.prototype._super = Control;
DOMControl.prototype.constructor = DOMControl;

DOMControl.prototype.undraw = function(){
	var elem = document.getElementById(this.id);
	if (elem && elem.parentNode){
		elem.parentNode.removeChild(elem);
	}
}

DOMControl.prototype.setStyle = function(elem, fill){
	if (fill !== false){
		elem.setAttribute("fill", this.tool.fillStyle);
	}else{
		elem.setAttribute("fill", "none");
	}
	elem.setAttribute("stroke", this.tool.strokeStyle);
	elem.setAttribute("stroke-width", this.tool.lineWidth);
}

DOMControl.prototype.draw = function(container){
	// for custom drawing methods, call
	// that method and skip standard drawing
	// if it returns false
	if (this.drawCallback !== null){
		if (!this.drawCallback(this, container)){
			return;
		}
	}
	
	// do not draw for non-positive sizes
	if (this.size <= 0){
		return;
	}
	
	var elem = document.getElementById(this.id);
	
	var x = 0;
	var y = 0;
	
	var i = 0;
	var n = 0;
	
	switch(this.shape){
		
		case Control.SHAPE_CIRCLE:{
			if (!elem){
				elem = document.createElementNS(container.namespaceURI, "circle"); 
				elem.id = this.id;
				elem.r.baseVal.value = this.size/2;
				this.setStyle(elem);
				container.appendChild(elem);
			}
			
			elem.cx.baseVal.value = this.x;
			elem.cy.baseVal.value = this.y;
			break;
		}
		
		case Control.SHAPE_SQUARE:{
			if (!elem){
				elem = document.createElementNS(container.namespaceURI, "rect");
				elem.id = this.id;
				elem.width.baseVal.value = this.size;
				elem.height.baseVal.value = this.size;
				this.setStyle(elem);
				container.appendChild(elem);
			}
			
			elem.x.baseVal.value = (this.x - this.size/2);
			elem.y.baseVal.value = (this.y - this.size/2);
			break;
		}
		
		case Control.SHAPE_BORDER:{
			if (!elem){
				elem = document.createElementNS(container.namespaceURI, "polygon");
				elem.id = this.id;
				for (i=0; i<4; i++){
					elem.points.appendItem(container.createSVGPoint());
				}
				this.setStyle(elem, false);
				container.appendChild(elem);
			}
			
			var pt;
			if (this.tool && this.tool.target){
				var t = this.tool.target;
				var m = this.tool.endMatrix;
				
				pt = elem.points.getItem(0);
				pt.x = m.x;
				pt.y = m.y;
				
				pt = elem.points.getItem(1);
				pt.x = m.x + m.a * t.width;
				pt.y = m.y + m.b * t.width;
				
				pt = elem.points.getItem(2);
				pt.x = m.x + m.a * t.width + m.c * t.height;
				pt.y = m.y + m.d * t.height + m.b * t.width;
				
				pt = elem.points.getItem(3);
				pt.x = m.x + m.c * t.height;
				pt.y = m.y + m.d * t.height;
			}
			
			break;
		}
		
		default:{
			// no draw
			break;
		}
	}
	
	// without a target, the control is not displayed
	if (elem && this.tool){
		if (!this.tool.target){
			elem.style.display = "none";
		}else{
			elem.style.display = "";
		}
	}
	
}
