 /**
* @class Column3D
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
*
* Column3D extends the movie clip class and represents a single
* 3D Column to be drawn on the chart. It takes in the required
* parameters (dimensions) and draws a 3D column.
*/
//Import required classes
import flash.geom.Rectangle;
import com.fusioncharts.extensions.ColorExt;
class com.fusioncharts.core.chartobjects.Column3D extends MovieClip 
{
	//Instance variables
	//Movie clip in which we've to draw column
	var mc : MovieClip;
	//Center X and center Y Position of front bar
	var x : Number, y : Number;
	//Width of front part and height required for column
	var wFront : Number, height : Number;
	//X and Y Shifts
	var xShift : Number, yShift : Number;
	//Color of column
	var color : String;
	//Border properties
	var showBorder : Boolean, borderColor : String, borderAlpha : Number;
	//Constructor method
	function Column3D (target : MovieClip, x : Number, y : Number, wFront : Number, height : Number, xShift : Number, yShift : Number, color : String, showBorder : Boolean, borderColor : String, borderAlpha : Number)
	{
		//Store the parameters in instance variables
		this.mc = target;
		this.x = x;
		this.y = y;
		this.wFront = wFront;
		this.height = height;
		this.xShift = xShift;
		this.yShift = yShift;
		this.color = color;
		this.showBorder = showBorder;
		this.borderColor = borderColor;
		this.borderAlpha = borderAlpha;
	}
	/**
	* draw method draws the column
	* 	@param	use3DLighting	Boolean value to indicate whether 3D lighting
	*							would be used while plotting the column.
	*/
	public function draw (use3DLighting : Boolean) : Void 
	{
		//Get half width
		var wHalf : Number = this.wFront / 2;
		//Origin X and Origin Y
		var ox : Number, oy : Number;
		//Set line style (if border is to be drawn)
		if (this.showBorder)
		{
			this.mc.lineStyle (1, parseInt (this.borderColor, 16) , this.borderAlpha);
		}
		//Arrays for 3D Lighting
		if (use3DLighting)
		{
			var colors : Array = new Array ();
			var alphas : Array = [100, 100];
			var ratios : Array = [0, 255];
		}
		//If it's a positive column we draw it normally
		if (height >= 0)
		{
			//Front bar - Fill as gradient (if use3DLighting)
			if (use3DLighting)
			{
				colors = [ColorExt.getLightColor (this.color, 0.55) , ColorExt.getDarkColor (this.color, 0.65)];
				var matrix : Object = {
					matrixType : "box", w : wFront, h : height, x : 0, y : - height, r : 90 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				this.mc.beginFill (parseInt (this.color, 16) , 100);
			}
			this.mc.moveTo ( - wHalf, 0);
			this.mc.lineTo ( - wHalf, - height);
			this.mc.lineTo (wHalf, - height);
			this.mc.lineTo (wHalf, 0);
			this.mc.lineTo ( - wHalf, 0);
			this.mc.endFill ();
			//Draw the top face
			if (use3DLighting)
			{
				//Gradient if use3DLighting
				colors = [ColorExt.getDarkColor (this.color, 0.85) , ColorExt.getLightColor (this.color, 0.35)];
				var matrix : Object = {
					matrixType : "box", w : wFront + xShift, h : - yShift, x : - wHalf, y : - height, r : 45 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				this.mc.beginFill (ColorExt.getDarkColor (this.color, 0.75) , 100);
			}
			this.mc.moveTo ( - wHalf, - height);
			this.mc.lineTo ( - wHalf + xShift, - height - yShift);
			this.mc.lineTo (xShift + wHalf, - height - yShift);
			this.mc.lineTo (wHalf, - height);
			this.mc.lineTo ( - wHalf, - height);
			this.mc.endFill ();
			//Side dark bar
			//Fill as gradient (if use3DLighting)
			if (use3DLighting)
			{
				//You can uncomment the line below if you need the side bar to gradient from light to dark color.
				colors = [ColorExt.getLightColor (this.color, 0.75) , ColorExt.getDarkColor (this.color, 0.45)];
				//By default, we gradient from dark to dark color.
				colors = [ColorExt.getDarkColor (this.color, 0.75) , ColorExt.getDarkColor (this.color, 0.35)];
				var matrix : Object = {
					matrixType : "box", w : wFront, h : height, x : wHalf, y : - height, r : 90 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				this.mc.beginFill (ColorExt.getDarkColor (this.color, 0.6) , 100);
			}
			this.mc.moveTo (wHalf, 0);
			this.mc.lineTo (wHalf, - height);
			this.mc.lineTo (wHalf + xShift, - height - yShift);
			this.mc.lineTo (wHalf + xShift, - yShift);
			this.mc.lineTo (wHalf, 0);
			this.mc.endFill ();
			//Shift the entire movie clip
			this.mc._x = x;
			this.mc._y = y;
			//Set the 9 scale grid for animation.
			var grid : Rectangle = new Rectangle ( - wHalf + 1, - height, wFront + xShift - 2, (height - yShift));
			this.mc.scale9Grid = grid;
		} else 
		{
			//Negative column - draw it accordingly
			//Front bar - Fill as gradient (if use3DLighting)
			if (use3DLighting)
			{
				colors = [ColorExt.getLightColor (this.color, 0.55) , ColorExt.getDarkColor (this.color, 0.65)];
				var matrix : Object = {
					matrixType : "box", w : wFront, h : - height, x : - wHalf - xShift, y : yShift, r : 90 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				this.mc.beginFill (parseInt (this.color, 16) , 100);
			}
			this.mc.moveTo ( - wHalf - xShift, yShift);
			this.mc.lineTo ( - wHalf - xShift, yShift - height);
			this.mc.lineTo (wHalf - xShift, yShift - height);
			this.mc.lineTo (wHalf - xShift, yShift);
			this.mc.lineTo ( - wHalf - xShift, yShift);
			this.mc.endFill ();
			//Draw the top face
			if (use3DLighting)
			{
				//Gradient if use3DLighting
				colors = [ColorExt.getDarkColor (this.color, 0.85) , ColorExt.getLightColor (this.color, 0.35)];
				var matrix : Object = {
					matrixType : "box", w : wFront + xShift, h : - yShift, x : - wHalf - xShift, y : yShift, r : 45 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				//Solid fill
				this.mc.beginFill (ColorExt.getDarkColor (this.color, 0.75) , 100);
			}
			this.mc.moveTo ( - wHalf - xShift, yShift);
			this.mc.lineTo ( - wHalf, 0);
			this.mc.lineTo (wHalf, 0);
			this.mc.lineTo (wHalf - xShift, yShift);
			this.mc.lineTo ( - wHalf - xShift, yShift);
			this.mc.endFill ();
			//Side dark bar
			//Fill as gradient (if use3DLighting)
			if (use3DLighting)
			{
				colors = [ColorExt.getDarkColor (this.color, 0.75) , ColorExt.getDarkColor (this.color, 0.35)];
				var matrix : Object = {
					matrixType : "box", w : wFront, h : - height, x : wHalf, y : 0, r : 90 * (Math.PI / 180)
				};
				this.mc.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				this.mc.beginFill (ColorExt.getDarkColor (this.color, 0.6) , 100);
			}
			this.mc.moveTo (wHalf, 0);
			this.mc.lineTo (wHalf - xShift, yShift);
			this.mc.lineTo (wHalf - xShift, yShift - height);
			this.mc.lineTo (wHalf, - height);
			this.mc.lineTo (wHalf, 0);
			this.mc.endFill ();
			//Shift the entire movie clip
			this.mc._x = x + xShift;
			this.mc._y = y - yShift;
			//Set the 9 scale grid for animation.
			//Tricky: We scale from 1 pixel left to -1 pixel right. Otherwise, it scales normally.
			var grid : Rectangle = new Rectangle ( - wHalf - xShift + 1, yShift, wFront + xShift - 2, - height - yShift);
			this.mc.scale9Grid = grid;
		}
		//Cache it as bitmap.
		this.mc.cacheAsBitmap = true;
	}
	/**
	* calcShifts method calculates the column 3D shifts, width distribution
	* ratio, depths etc.
	*	@param	width	Total width for the column
	*	@param	angle	Tilt angle for column
	*	@param	depth	Depth (in pixels) of the shadow component of column
	*	@return		An object containing the following information:
	*					wFront, wShadow, depth, xShift, yShift
	*/
	public static function calcShifts (width : Number, angle : Number, depth : Number) : Object 
	{
		//Step 1: First check if the given depth can be accomodated in
		//the given width.
		//We need atleast one pixel to draw the column front
		var depthH : Number = depth * Math.cos (angle * (Math.PI / 180));
		if (depthH >= width - 1)
		{
			depthH = width - 1;
			depth = depthH / Math.cos (angle * (Math.PI / 180));
		}
		//Width of front part and shadow part.
		var wFront : Number, wShadow : Number;
		//Initial ratio= front part:shadow=2:1
		wFront = width * (2 / 3);
		//If the column width is more than 25 pixels, restrict the depth to max 15 pixels
		if (width >= 25)
		{
			//Restrict only if there is no user specified depth
			depth = (depth == - 1) ? 15 : depth;
			//Get the width of front portion based on depth
			wFront = (width - (depth * (Math.cos (angle * (Math.PI / 180)))));
		} else 
		{
			//If the entire column width is less than 25 pixels, then we increase
			//the depth of the shadow to 20 pixels to give a richer 3D look.
			//However, the column face would still be 2/3rd of the entire width available
			//Although it will not seem so owing to the column depth
			depth = (depth == - 1) ? 20 : depth;
		}
		//Calculate the horizontal width of shadow
		wShadow = depth * Math.cos (angle * (Math.PI / 180));
		//Now, we've the width of front part and horizontal width of shadow in
		//wFront and wShadow respectively.
		//Create a return object
		var rtnObj : Object = new Object ();
		rtnObj.wFront = wFront;
		rtnObj.wShadow = wShadow;
		rtnObj.depth = depth;
		rtnObj.xShift = wShadow;
		//We need to calculate the yShift .
		rtnObj.yShift = wShadow * Math.tan (angle * (Math.PI / 180));
		//Return
		return rtnObj;
	}
}
