/**
* @class Bar3D
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
*
* Bar3D extends the movie clip class and represents a single
* 3D Bar to be drawn on the chart. It takes in the required
* parameters (dimensions) and draws a 3D bar.
* We draw the bar in the given movie clip at 0,0 for supporting
* linear scale animations. Finally, we reposition the original
* movie clip to the required x,y. So, effectively, within one 
* movie clip, you can just plot 1 Bar 3D.
*/
//Import required classes
import flash.geom.Rectangle;
import com.fusioncharts.extensions.ColorExt;
class com.fusioncharts.core.chartobjects.Bar3D extends MovieClip {
	//Instance variables
	//Movie clip in which we've to draw bar
	var mc:MovieClip;
	//Left X and center Y Position of front bar (in case of positive bar)
	//Right X and center Y Position of front bar (in case of negative bar)
	var x:Number, y:Number;
	//Width required and height of front part
	var width:Number, hFront:Number;
	//X and Y Shifts
	var xShift:Number, yShift:Number;
	//Color of bar
	var color:String;
	//Border properties
	var showBorder:Boolean, borderColor:String, borderAlpha:Number;
	//Constructor method
	function Bar3D(target:MovieClip, x:Number, y:Number, width:Number, hFront:Number, xShift:Number, yShift:Number, color:String, showBorder:Boolean, borderColor:String, borderAlpha:Number) {
		//Store the parameters in instance variables
		this.mc = target;
		this.x = x;
		this.y = y;
		this.width = width;
		this.hFront = hFront;
		this.xShift = xShift;
		this.yShift = yShift;
		this.color = color;
		this.showBorder = showBorder;
		this.borderColor = borderColor;
		this.borderAlpha = borderAlpha;
	}
	/**
	* draw method draws the bar
	* 	@param	use3DLighting	Boolean value to indicate whether 3D lighting
	*							would be used while plotting the bar.
	*/
	public function draw(use3DLighting:Boolean):Void {
		//Get half height
		var wHalf:Number = this.hFront/2;
		//Origin X and Origin Y
		var ox:Number, oy:Number;
		//Set line style (if border is to be drawn)
		if (this.showBorder) {
			this.mc.lineStyle(1, parseInt(this.borderColor, 16), this.borderAlpha);
		}
		//Arrays for 3D Lighting 
		if (use3DLighting) {
			var colors:Array = new Array();
			var alphas:Array = [100, 100];
			var ratios:Array = [0, 255];
		}
		//If it's a positive bar we draw it normally 
		if (width>=0) {
			//Front bar - Fill as gradient (if use3DLighting)
			if (use3DLighting) {
				colors = [ColorExt.getLightColor(this.color, 0.55), ColorExt.getDarkColor(this.color, 0.65)];
				var matrix:Object = {matrixType:"box", w:width, h:hFront, x:0, y:-wHalf, r:Math.PI};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				this.mc.beginFill(parseInt(this.color, 16), 100);
			}
			this.mc.moveTo(0,-wHalf);
			this.mc.lineTo(width, -wHalf);
			this.mc.lineTo(width, wHalf);
			this.mc.lineTo(0, wHalf);
			this.mc.lineTo(0, -wHalf);
			this.mc.endFill();			
			//Draw the top face
			if (use3DLighting) {
				//Gradient if use3DLighting
				colors = [ColorExt.getDarkColor(this.color, 0.85), ColorExt.getDarkColor(this.color, 0.95)];
				var matrix:Object = {matrixType:"box", w:xShift, h:hFront+yShift, x:width, y:-wHalf, r:135*(Math.PI/180)};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				this.mc.beginFill(ColorExt.getDarkColor(this.color, 0.75), 100);
			}
			this.mc.moveTo(width, -wHalf);
			this.mc.lineTo(width+xShift, -wHalf-yShift);
			this.mc.lineTo(width+xShift, wHalf-yShift);
			this.mc.lineTo(width, wHalf);
			this.mc.lineTo(width, -wHalf+yShift);
			this.mc.endFill();
			//Side dark bar
			//Fill as gradient (if use3DLighting)
			if (use3DLighting) {
				//You can uncomment the line below if you need the side bar to gradient from light to dark color.
				//colors = [ColorExt.getLightColor(this.color, 0.75), ColorExt.getDarkColor(this.color, 0.45)];
				//By default, we gradient from dark to dark color.
				colors = [ColorExt.getDarkColor(this.color, 0.50),ColorExt.getDarkColor(this.color, 0.75)];
				var matrix:Object = {matrixType:"box", w:width, h:hFront, x:0, y:-hFront, r:0};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				this.mc.beginFill(ColorExt.getDarkColor(this.color, 0.6), 100);
			}
			this.mc.moveTo(0, -wHalf);
			this.mc.lineTo(width, -wHalf);
			this.mc.lineTo(width+xShift, -wHalf-yShift);
			this.mc.lineTo(xShift, -wHalf-yShift);
			this.mc.lineTo(0, -wHalf);
			this.mc.endFill();
			//Shift the entire movie clip
			this.mc._x = x;
			this.mc._y = y;
			//Set the 9 scale grid for animation.
			var grid:Rectangle = new Rectangle(1, -wHalf-yShift+1, width+xShift-2, wHalf-2);
			this.mc.scale9Grid = grid;			
		} else {
			//Negative bar - draw it accordingly
			//Front bar - Fill as gradient (if use3DLighting)
			if (use3DLighting) {
				colors = [ColorExt.getLightColor(this.color, 0.55), ColorExt.getDarkColor(this.color, 0.65)];
				var matrix:Object = {matrixType:"box", w:width, h:hFront, x:-xShift, y:-wHalf, r:0};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				this.mc.beginFill(parseInt(this.color, 16), 100);
			}
			this.mc.moveTo(-xShift, -wHalf+yShift);
			this.mc.lineTo(width-xShift, -wHalf+yShift);
			this.mc.lineTo(width-xShift, wHalf+yShift);
			this.mc.lineTo(-xShift, wHalf+yShift);
			this.mc.lineTo(-xShift, -wHalf+yShift);
			this.mc.endFill();			
			//Draw the top face
			if (use3DLighting) {
				//Gradient if use3DLighting
				colors = [ColorExt.getDarkColor(this.color, 0.85), ColorExt.getDarkColor(this.color, 0.95)];
				var matrix:Object = {matrixType:"box", w:xShift, h:hFront+yShift, x:-xShift, y:-wHalf, r:135*(Math.PI/180)};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				//Solid fill
				this.mc.beginFill(ColorExt.getDarkColor(this.color, 0.75), 100);
			}
			this.mc.moveTo(-xShift, -wHalf+yShift);
			this.mc.lineTo(0, -wHalf);
			this.mc.lineTo(0, wHalf);
			this.mc.lineTo(-xShift, wHalf+yShift);
			this.mc.lineTo(-xShift, -wHalf+yShift);
			this.mc.endFill();
			//Side dark bar
			//Fill as gradient (if use3DLighting)
			if (use3DLighting) {
				colors = [ColorExt.getDarkColor(this.color, 0.75), ColorExt.getDarkColor(this.color, 0.50)];
				var matrix:Object = {matrixType:"box", w:width-xShift, h:hFront, x:0, y:-wHalf, r:0};
				this.mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
			} else {
				this.mc.beginFill(ColorExt.getDarkColor(this.color, 0.6), 100);
			}
			this.mc.moveTo(0, -wHalf);
			this.mc.lineTo(-xShift, -wHalf+yShift);
			this.mc.lineTo(width-xShift, -wHalf+yShift);
			this.mc.lineTo(width, -wHalf);
			this.mc.lineTo(0, -wHalf);
			this.mc.endFill();
			//Shift the entire movie clip
			this.mc._x = x+xShift;
			this.mc._y = y-yShift;			
		}
		//Cache it as bitmap.
		this.mc.cacheAsBitmap = true;
	}
	/**
	* calcShifts method calculates the bar 3D shifts, height distribution
	* ratio, depths etc.
	*	@param	height	Total vertical height available for the bar
	*	@param	angle	Tilt angle for bar
	*	@param	depth	Depth (in pixels) of the shadow component of bar
	*	@return			An object containing the following information:
	*					hFront, hShadow, depth, xShift, yShift
	*/
	public static function calcShifts(height:Number, angle:Number, depth:Number):Object {
		//Step 1: First check if the given depth can be accomodated in
		//the given height. Claculate 
		//We need atleast one pixel to draw the bar front (height)
		var depthV:Number = depth*Math.sin(angle*(Math.PI/180));
		if (depthV>=height-1) {
			depthV = height-1;
			depth = depthV/Math.sin(angle*(Math.PI/180));
		}
		//Variables to store height of front part and shadow part. 
		var hFront:Number, hShadow:Number;
		//Initial ratio= front part:shadow=2:1
		hFront = height*(2/3);
		//Calculate the depth based on height of bar
		if (height>=25){
			//Restrict only if there is no user specified depth
			depth = (depth == - 1) ? 10 : depth;	
			//Get the height of front portion based on depth
			hFront = (height-(depth*(Math.sin(angle*(Math.PI/180)))));
		} else {
			//If the entire bar height is less than 25 pixels, then we decrease
			//the depth of the shadow to h/3 pixels to give a flat look (required for better
			//readability in 3D Bar). Otherwise, the top face look too prominent, thereby
			//renderind a distorted 3D view.
			//However, the bar face would still be 2/3rd of the entire width available
			//Although it will not seem so owing to the depth
			depth = (depth == - 1) ? (height/3) : (depth);
		}
		//Calculate the vertical height of shadow
		hShadow = depth*Math.cos(angle*(Math.PI/180));
		//Now, we've the height of front part and vertical height of shadow in
		//hFront and hShadow respectively.
		//Create a return object
		var rtnObj:Object = new Object();
		rtnObj.hFront = hFront;
		rtnObj.hShadow = hShadow;
		rtnObj.depth = depth;
		rtnObj.yShift = hShadow;
		//We need to calculate the xShift .
		rtnObj.xShift = hShadow/Math.tan(angle*(Math.PI/180));
		//Return
		return rtnObj;
	}
}
