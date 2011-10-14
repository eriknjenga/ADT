/**
* @class RoundColumn2D
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0.3
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
*
* RoundColumn2D extends the movie clip class and represents a single
* 2D rounded Column to be drawn on the chart. It takes in the required
* parameters (dimensions) and draws a column.
*/
//Import required classes
import com.fusioncharts.extensions.MathExt;
import com.fusioncharts.extensions.DrawingExt;
import com.fusioncharts.extensions.ColorExt;
import flash.filters.ColorMatrixFilter;
class com.fusioncharts.core.chartobjects.RoundColumn2D extends MovieClip {
	//Instance variables
	//Movie clip container
	private var mc:MovieClip;
	//Width and height
	private var w:Number;
	private var h:Number;
	//Color
	private var color:String;
	//Border properties
	private var borderThickness:Number;
	private var borderAlpha:Number;
	//Constant
	private var radius:Number;
	/**
	 * Constructor method. Takes in parameters and stores
	 * in local variables.
	*/
	function RoundColumn2D(target:MovieClip, w:Number, h:Number, r:Number, color:String, borderThickness:Number, borderAlpha:Number) {
		//Store parameters in instance variables
		this.mc = target;
		this.w = w;
		this.radius = r;
		//Negate to cancel Flash's reverse Y Co-ordinate system
		this.h = -h;
		this.color = color;
		this.borderThickness = borderThickness;
		this.borderAlpha = borderAlpha;
		//If the height is less than round radius, we adjust round radius
		if (Math.abs(this.h)<this.radius){
			this.radius = Math.floor(Math.abs(this.h)/2);
		}		
	}
	/**
	 * draw method draws the column
	*/
	public function draw():Void {
		this.mc.lineStyle(borderThickness, ColorExt.getDarkColor(this.color, 0.7), borderAlpha, true, "none", "round", "miter", 1);
		//Darker color shade
		var colorShade:Number = ColorExt.getDarkColor(this.color, 0.63);
		//Create matrix object
		var matrix:Object = {matrixType:"box", w:w, h:h, x:-w/2, y:0, r:0};
		//If you need without press effect - uncomment this line - this.mc.beginGradientFill("linear", [ColorExt.getDarkColor(this.color, 0.75), ColorExt.getLightColor(this.color, 0.85), ColorExt.getDarkColor(this.color, 0.8)], [100, 100, 100], [0, 205, 255], matrix);
		this.mc.beginGradientFill("linear", [ColorExt.getDarkColor(this.color, 0.75), ColorExt.getLightColor(this.color, 0.25), ColorExt.getDarkColor(this.color, 0.8), ColorExt.getLightColor(this.color, 0.65), ColorExt.getDarkColor(this.color, 0.8)], [100, 100, 100, 100, 100], [0, 25, 60, 205, 255], matrix);
		//Draw rectangle
		if (h<0) {
			//For positive columns
			DrawingExt.drawRoundedRect(this.mc, -w/2, h, w, -h, {tl:this.radius, tr:this.radius, bl:0, br:0}, {t:colorShade, r:colorShade, l:colorShade, b:colorShade}, {t:borderAlpha, r:borderAlpha, l:borderAlpha, b:0}, {t:borderThickness, r:borderThickness, l:borderThickness, b:borderThickness});
		} else {
			//Negative Columns
			DrawingExt.drawRoundedRect(this.mc, -w/2, 0, w, h, {bl:this.radius, br:this.radius, tl:0, tr:0}, {t:colorShade, r:colorShade, l:colorShade, b:colorShade}, {t:0, r:borderAlpha, l:borderAlpha, b:borderAlpha}, {t:borderThickness, r:borderThickness, l:borderThickness, b:borderThickness});
		}
		this.mc.endFill();
		//We now need to brighten the column to get the glassy effect. However, if the color
		//itself is very light, we do not brighten. 
		//We assume that a color which has a luminance less than 85% is a light color
		var hslObj:Object = ColorExt.RGB2HSL(parseInt(this.color, 16));

		if (hslObj.l<=85 && hslObj.s<=100) {
			//Brighten the column and then change contrast to get the glassy effect
			var aBrighten:Array = [1.25, 0, 0, 0, 9.125, 0, 1.25, 0, 0, 9.125, 0, 0, 1.25, 0, 9.125, 0, 0, 0, 1, 0];
			this.mc.filters = [new ColorMatrixFilter(aBrighten)];
		}		
	}
}
