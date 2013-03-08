/**
 * Captures mouse position within the context
 * of a DOM element.
 */
var Mouse = {};
Mouse.x = 0;
Mouse.y = 0;

Mouse.isTouchSupported = "ontouchstart" in window;
Mouse.START = Mouse.isTouchSupported ? "touchstart" : "mousedown";
Mouse.MOVE = Mouse.isTouchSupported ? "touchmove" : "mousemove";
Mouse.END = Mouse.isTouchSupported ? "touchend" : "mouseup";
	
Mouse.get = function(event, elem){
	
	var isTouch = false;
	
	// touch screen events
	if (event.touches){
		if (event.touches.length){
			isTouch = true;
			// referencing first touch only
			Mouse.x = parseInt(event.touches[0].pageX);
			Mouse.y = parseInt(event.touches[0].pageY);
		}
	}else{
		// mouse events
		Mouse.x = parseInt(event.clientX);
		Mouse.y = parseInt(event.clientY);
	}
	
	// accounts for border
	Mouse.x -= elem.clientLeft;
	Mouse.y -= elem.clientTop;

	// parent offsets
	var par = elem;
	while (par !== null) {
		if (isTouch){
			// touch events offset scrolling with pageX/Y
			// so scroll offset not needed for them
			Mouse.x -= parseInt(par.offsetLeft);
			Mouse.y -= parseInt(par.offsetTop);
		}else{
			Mouse.x += parseInt(par.scrollLeft - par.offsetLeft);
			Mouse.y += parseInt(par.scrollTop - par.offsetTop);
		}

		par = par.offsetParent || null;
	}
}
/**
 * Loads Image objects in bulk and calls a a callback
 * function when all images have loaded.
 */
function ImagesLoader(completeCallback){
	this.images = [];
	this.imageCount = 0;
	this.completeCallback = completeCallback;
}

ImagesLoader.prototype.load = function(imgList){
	var i;
	this.imageCount = imgList.length;
	for (i=0; i<this.imageCount; i++){
		this.loadImage(imgList[i]);
	}
}

ImagesLoader.prototype.loadImage = function(url){
	var img = new Image();
	this.images.push(img);
	this.images[url] = img;
	img.onload = this.handleOnLoad.bind(this);
	img.onerror = this.handleOnError.bind(this);
	img.src = url; // starts load
}

ImagesLoader.prototype.handleOnLoad = function(){
	
	this.checkComplete();
	
};

ImagesLoader.prototype.handleOnError = function(){
	
	console.log("Failed to load img " + this);
	this.checkComplete();
	
};

ImagesLoader.prototype.checkComplete = function(){
	if (--this.imageCount <= 0){
		if (this.completeCallback != null){
			var temp = this.completeCallback;
			this.completeCallback = null;
			temp();
		}
	}
}

if (!console){
	// log messages lost but no error
	console = {log:function(){}};
}

	
// POLYFILLS

(function() {

	// Function.bind
	// source: https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Function/bind
	if (!Function.prototype.bind) {
		Function.prototype.bind = function (oThis) {
			if (typeof this !== "function") {
				// closest thing possible to the ECMAScript 5 internal IsCallable function
				throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
			}
			
			var aArgs = Array.prototype.slice.call(arguments, 1), 
				fToBind = this, 
				fNOP = function () {},
				fBound = function () {
					return fToBind.apply(this instanceof fNOP && oThis
						? this
						: oThis,
						aArgs.concat(Array.prototype.slice.call(arguments)));
				};
				
			fNOP.prototype = this.prototype;
			fBound.prototype = new fNOP();
			
			return fBound;
		};
	}
	
	
	// window.requestAnimationFrame
	// source: http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
	var lastTime = 0;
	var vendors = ['ms', 'moz', 'webkit', 'o'];
	for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
		window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
		window.cancelAnimationFrame =
		  window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
	}

	if (!window.requestAnimationFrame)
		window.requestAnimationFrame = function(callback, element) {
			var currTime = new Date().getTime();
			var timeToCall = Math.max(0, 16 - (currTime - lastTime));
			var id = window.setTimeout(function() { callback(currTime + timeToCall); },
			  timeToCall);
			lastTime = currTime + timeToCall;
			return id;
		};

	if (!window.cancelAnimationFrame)
		window.cancelAnimationFrame = function(id) {
			clearTimeout(id);
		};
}());
