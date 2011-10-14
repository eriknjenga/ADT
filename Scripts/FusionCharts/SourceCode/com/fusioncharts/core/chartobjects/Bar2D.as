 /**
* @class Bar2D
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
*
* Bar2D extends the movie clip class and represents a single
* 2D bar to be drawn on the chart. It takes in the required
* parameters (dimensions) and draws a bar.
*/
//Import required classes
import com.fusioncharts.extensions.MathExt;
import com.fusioncharts.extensions.DrawingExt;
class com.fusioncharts.core.chartobjects.Bar2D extends MovieClip 
{
	//Instance variables
	//Movie clip container
	private var mc : MovieClip;
	//Width and height
	private var w : Number;
	private var h : Number;
	//Border Color, Border Alpha, Border Thickness
	private var borderColor : String;
	private var borderAlpha : Number;
	private var borderThickness : Number;
	//Background Color, Alpha, Ratio, Angle
	private var bgColor : Array;
	private var bgAlpha : Array;
	private var bgRatio : Array;
	private var bgAngle : Number;
	//Flag whether we need to draw start border
	private var drawStartBorder : Boolean;
	//Dash properties
	private var isBorderDashed : Boolean;
	private var dashLen : Number;
	private var dashGap : Number;
	/**
	* Constructor method. Takes in parameters and stores
	* in local variables.
	*/
	function Bar2D (target : MovieClip, w : Number, h : Number, borderColor : String, borderAlpha : Number, borderThickness : Number, bgColor : Array, bgAlpha : Array, bgRatio : Array, bgAngle : Number, drawStartBorder : Boolean, isBorderDashed : Boolean, dashLen : Number, dashGap : Number)
	{
		//Store parameters in instance variables
		this.mc = target;
		this.w = w;
		this.h = h;
		this.borderColor = borderColor;
		this.borderAlpha = borderAlpha;
		this.borderThickness = borderThickness;
		this.bgColor = bgColor;
		this.bgAlpha = bgAlpha;
		this.bgRatio = bgRatio;
		this.bgAngle = bgAngle;
		this.drawStartBorder = drawStartBorder;
		this.isBorderDashed = isBorderDashed;
		this.dashLen = dashLen;
		this.dashGap = dashGap;
	}
	/**
	* draw method draws the bar
	*/
	public function draw () : Void 
	{
		//Set line style if it's not dashed border
		if ( ! this.isBorderDashed)
		{
			this.mc.lineStyle (this.borderThickness, parseInt (this.borderColor, 16) , this.borderAlpha);
		} else 
		{
			//Set empty line style
			//Set empty line style, as we've already drawn dashed border
			this.mc.lineStyle ();
		}
		this.mc.moveTo (0, - h / 2);
		//Create matrix object
		var matrix : Object = {
			matrixType : "box", w : w, h : h, x : 0, y : - h / 2, r : MathExt.toRadians (this.bgAngle)
		};
		//Start the fill.
		this.mc.beginGradientFill ("linear", this.bgColor, this.bgAlpha, this.bgRatio, matrix);
		//Draw rectangle
		this.mc.lineTo (w, - h / 2);
		this.mc.lineTo (w, h / 2);
		this.mc.lineTo (0, h / 2);
		if ( ! drawStartBorder)
		{
			//If start border is not to be drawn
			this.mc.lineStyle ();
		}
		this.mc.lineTo (0, - h / 2);
		//End fill
		this.mc.endFill ();
		//If dashed border is required, then draw it
		if (this.isBorderDashed)
		{
			//Set line style
			this.mc.lineStyle (this.borderThickness, parseInt (this.borderColor, 16) , this.borderAlpha);
			//Draw the dash
			DrawingExt.dashTo (this.mc, 0, - h / 2, w, - h / 2, this.dashLen, this.dashGap);
			DrawingExt.dashTo (this.mc, w, - h / 2, w, h / 2, this.dashLen, this.dashGap);
			DrawingExt.dashTo (this.mc, w, h / 2, 0, h / 2, this.dashLen, this.dashGap);
			if (drawStartBorder)
			{
				//If start border is to be drawn
				DrawingExt.dashTo (this.mc, 0, h / 2, 0, - h / 2, this.dashLen, this.dashGap);
			}
		}
	}
}
