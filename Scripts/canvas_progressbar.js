(function($) {
	var i = 0;
	var res = 0;
	var context = null;
	var total_width = 300;
	var total_height = 40;
	var initial_x = 0;
	var initial_y = 0;
	var radius = total_height / 2;
	var elem = null;

	function draw(percentage) {
		var width_equivalent = percentage;
		//Convert the percentage to reflect the proportion of width desired if the percentage passed is not 0
		if(percentage>0){
			width_equivalent = (percentage*total_width)/100;
		}
		i += width_equivalent; 
		
		 
		// Clear everything before drawing
		context.clearRect(initial_x - 5, initial_y - 5, total_width + 15, total_height + 15);
		progressLayerRect(context, initial_x, initial_y, total_width, total_height, radius);
		progressBarRect(context, initial_x, initial_y, width_equivalent, total_height, radius, total_width);
		progressText(context, initial_x, 20, width_equivalent, total_height, radius, total_width);
		if(width_equivalent >= total_width) {
			clearInterval(res);
		}
	}

	/**
	 * Draws a rounded rectangle.
	 * @param {CanvasContext} ctx
	 * @param {Number} x The top left x coordinate
	 * @param {Number} y The top left y coordinate
	 * @param {Number} width The width of the rectangle
	 * @param {Number} height The height of the rectangle
	 * @param {Number} radius The corner radius;
	 */
	function roundRect(ctx, x, y, width, height, radius) {
		ctx.beginPath();
		ctx.moveTo(x + radius, y);
		ctx.lineTo(x + width - radius, y);
		ctx.arc(x + width - radius, y + radius, radius, -Math.PI / 2, Math.PI / 2, false);
		ctx.lineTo(x + radius, y + height);
		ctx.arc(x + radius, y + radius, radius, Math.PI / 2, 3 * Math.PI / 2, false);
		ctx.closePath();
		ctx.fill();
	}

	/**
	 * Draws a rounded rectangle.
	 * @param {CanvasContext} ctx
	 * @param {Number} x The top left x coordinate
	 * @param {Number} y The top left y coordinate
	 * @param {Number} width The width of the rectangle
	 * @param {Number} height The height of the rectangle
	 * @param {Number} radius The corner radius;
	 */
	function roundInsetRect(ctx, x, y, width, height, radius) {
		ctx.beginPath();
		// Draw huge anti-clockwise box
		ctx.moveTo(1000, 1000);
		ctx.lineTo(1000, -1000);
		ctx.lineTo(-1000, -1000);
		ctx.lineTo(-1000, 1000);
		ctx.lineTo(1000, 1000);
		ctx.moveTo(x + radius, y);
		ctx.lineTo(x + width - radius, y);
		ctx.arc(x + width - radius, y + radius, radius, -Math.PI / 2, Math.PI / 2, false);
		ctx.lineTo(x + radius, y + height);
		ctx.arc(x + radius, y + radius, radius, Math.PI / 2, 3 * Math.PI / 2, false);
		ctx.closePath();
		ctx.fill();
	}

	function progressLayerRect(ctx, x, y, width, height, radius) {
		ctx.save();
		// Set shadows to make some depth
		ctx.shadowOffsetX = 2;
		ctx.shadowOffsetY = 2;
		ctx.shadowBlur = 5;
		ctx.shadowColor = '#666';

		// Create initial grey layer
		ctx.fillStyle = 'rgba(189,189,189,1)';
		roundRect(ctx, x, y, width, height, radius);

		// Overlay with gradient
		ctx.shadowColor = 'rgba(0,0,0,0)'
		var lingrad = ctx.createLinearGradient(0, y + height, 0, 0);
		lingrad.addColorStop(0, 'rgba(255,255,255, 0.1)');
		lingrad.addColorStop(0.4, 'rgba(255,255,255, 0.7)');
		lingrad.addColorStop(1, 'rgba(255,255,255,0.4)');
		ctx.fillStyle = lingrad;
		roundRect(ctx, x, y, width, height, radius);

		ctx.fillStyle = 'white';
		//roundInsetRect(ctx, x, y, width, height, radius);

		ctx.restore();
	}

	/**
	 * Draws a half-rounded progress bar to properly fill rounded under-layer
	 * @param {CanvasContext} ctx
	 * @param {Number} x The top left x coordinate
	 * @param {Number} y The top left y coordinate
	 * @param {Number} width The width of the bar
	 * @param {Number} height The height of the bar
	 * @param {Number} radius The corner radius;
	 * @param {Number} max The under-layer total width;
	 */
	function progressBarRect(ctx, x, y, width, height, radius, max) {
		// var to store offset for proper filling when inside rounded area
		var offset = 0;
		ctx.beginPath();
		if(width < radius) {
			offset = radius - Math.sqrt(Math.pow(radius, 2) - Math.pow((radius - width), 2));
			ctx.moveTo(x + width, y + offset);
			ctx.lineTo(x + width, y + height - offset);
			ctx.arc(x + radius, y + radius, radius, Math.PI - Math.acos((radius - width) / radius), Math.PI + Math.acos((radius - width) / radius), false);
		} else if(width + radius > max) {
			offset = radius - Math.sqrt(Math.pow(radius, 2) - Math.pow((radius - (max - width)), 2));
			ctx.moveTo(x + radius, y);
			ctx.lineTo(x + width, y);
			ctx.arc(x + max - radius, y + radius, radius, -Math.PI / 2, -Math.acos((radius - (max - width)) / radius), false);
			ctx.lineTo(x + width, y + height - offset);
			ctx.arc(x + max - radius, y + radius, radius, Math.acos((radius - (max - width)) / radius), Math.PI / 2, false);
			ctx.lineTo(x + radius, y + height);
			ctx.arc(x + radius, y + radius, radius, Math.PI / 2, 3 * Math.PI / 2, false);
		} else {
			ctx.moveTo(x + radius, y);
			ctx.lineTo(x + width, y);
			ctx.lineTo(x + width, y + height);
			ctx.lineTo(x + radius, y + height);
			ctx.arc(x + radius, y + radius, radius, Math.PI / 2, 3 * Math.PI / 2, false);
		}
		ctx.closePath();
		ctx.fill();

		// draw progress bar right border shadow
		if(width < max - 1) {
			ctx.save();
			ctx.shadowOffsetX = 1;
			ctx.shadowBlur = 1;
			ctx.shadowColor = '#666';
			if(width + radius > max)
				offset = offset + 1;
			ctx.fillRect(x + width, y + offset, 1, total_height - offset * 2);
			ctx.restore();
		}
	}

	/**
	 * Draws properly-positioned progress bar percent text
	 * @param {CanvasContext} ctx
	 * @param {Number} x The top left x coordinate
	 * @param {Number} y The top left y coordinate
	 * @param {Number} width The width of the bar
	 * @param {Number} height The height of the bar
	 * @param {Number} radius The corner radius;
	 * @param {Number} max The under-layer total width;
	 */
	function progressText(ctx, x, y, width, height, radius, max) {
		ctx.save();
		ctx.fillStyle = 'white';
		var text = Math.floor(width / max * 100) + "%";
		var text_width = ctx.measureText(text).width;
		var text_x = x + width - text_width - radius / 2;
		if(width <= radius + text_width) {
			text_x = x + radius / 2;
		}
		ctx.fillText(text, text_x, y + 10);
		ctx.restore();
	}

	var methods = {
		init : function(options) {
			draw(0);
		},
		show : function() {
			// IS
		},
		hide : function() {
			// GOOD
		},
		update : function(percentage) { 
			draw(percentage);
		}
	};

	$.progress_bar = function(selector, method) {
		//alert(arguments[0]);
		elem = document.getElementById(selector);

		if(!elem || !elem.getContext) {
			return;
		}
		context = elem.getContext('2d');
		if(!context) {
			return;
		}

		// set font
		context.font = "20px Verdana";

		// Blue gradient for progress bar
		var progress_lingrad = context.createLinearGradient(0, initial_y + total_height, 0, 0);
		progress_lingrad.addColorStop(0, '#4DA4F3');
		progress_lingrad.addColorStop(0.4, '#ADD9FF');
		progress_lingrad.addColorStop(1, '#9ED1FF');
		context.fillStyle = progress_lingrad;
		//res = setInterval(draw, 100);

		// Method calling logic
		if(methods[method]) {
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 2));
		} else if( typeof method === 'object' || !method) {
			return methods.init.apply(this, arguments[1]);
		} else {
			$.error('Method ' + method + ' does not exist on jQuery.tooltip');
		}

	};
})(jQuery);
