 /**
* @class SingleYAxis3DChart
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
* SingleYAxis3DChart extends SingleYAxisChart class to encapsulate
* functionalities of a single series 3D chart with a single axes. All such
* charts extend this class.
*/
//Import parent class
import com.fusioncharts.core.SingleYAxisChart;
//Column 3D Class
import com.fusioncharts.core.chartobjects.Column3D;
//Extensions
import com.fusioncharts.extensions.ColorExt;
import com.fusioncharts.extensions.StringExt;
import com.fusioncharts.extensions.MathExt;
import com.fusioncharts.extensions.DrawingExt;
//Delegate
import mx.utils.Delegate;
class com.fusioncharts.core.SingleYAxis3DChart extends SingleYAxisChart 
{
	//Instance variables
	//Number of negative columns
	private var numNeg : Number;
	//Number of positive columns
	private var numPos : Number;
	/**
	* Constructor function. We invoke the super class'
	* constructor.
	*/
	function SingleYAxis3DChart (targetMC : MovieClip, depth : Number, width : Number, height : Number, x : Number, y : Number, debugMode : Boolean, lang : String, scaleMode:String, registerWithJS:Boolean, DOMId:String)
	{
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
		//Initialize number of negative and positive columns to 0
		numNeg = 0;
		numPos = 0;
	}
	/**
	* calcTrendLinePos method helps us calculate the y-co ordinates for the
	* trend lines
	* NOTE: validateTrendLines and calcTrendLinePos could have been composed
	*			into a single method. However, in calcTrendLinePos, we need the
	*			canvas position, which is possible only after calculatePoints
	*			method has been called. But, in calculatePoints, we need the
	*			displayValue of each trend line, which is being set in
	*			validateTrendLines. So, validateTrendLines is invoked before
	*			calculatePoints method and calcTrendLinePos is invoked after.
	*	@return		Nothing
	*/
	private function calcTrendLinePos ()
	{
		//Loop variable
		var i : Number;
		for (i = 0; i <= this.numTrendLines; i ++)
		{
			//We proceed only if the trend line is valid
			if (this.trendLines [i].isValid == true)
			{
				//Calculate and store y-positions
				this.trendLines [i].y = this.getAxisPosition (this.trendLines [i].startValue, this.config.yMax, this.config.yMin, this.elements.canvasBg.y, this.elements.canvasBg.toY, true, 0);
				//If end value is different from start value
				if (this.trendLines [i].startValue != this.trendLines [i].endValue)
				{
					//Calculate y for end value
					this.trendLines [i].toY = this.getAxisPosition (this.trendLines [i].endValue, this.config.yMax, this.config.yMin, this.elements.canvasBg.y, this.elements.canvasBg.toY, true, 0);
					//Now, if it's a trend zone, we need mid value
					if (this.trendLines [i].isTrendZone)
					{
						//For textbox y position, we need mid value.
						this.trendLines [i].tbY = Math.min (this.trendLines [i].y, this.trendLines [i].toY) + (Math.abs (this.trendLines [i].y - this.trendLines [i].toY) / 2);
					} else 
					{
						//If the value is to be shown on left, then at left
						if (this.trendLines [i].valueOnRight)
						{
							this.trendLines [i].tbY = this.trendLines [i].toY;
						} else 
						{
							this.trendLines [i].tbY = this.trendLines [i].y;
						}
					}
					//Height
					this.trendLines [i].h = (this.trendLines [i].toY - this.trendLines [i].y);
				} else 
				{
					//Just copy
					this.trendLines [i].toY = this.trendLines [i].y;
					//Set same position for value tb
					this.trendLines [i].tbY = this.trendLines [i].y;
					//Height
					this.trendLines [i].h = 0;
				}
			}
		}
	}
	/**
	* feedMacros method feeds macros and their respective values
	* to the macro instance. This method is to be called after
	* calculatePoints, as we set the canvas and chart co-ordinates
	* in this method, which is known to us only after calculatePoints.
	*	@return	Nothing
	*/
	private function feedMacros () : Void
	{
		//Feed macros one by one
		//Chart dimension macros
		this.macro.addMacro ("$chartStartX", this.x);
		this.macro.addMacro ("$chartStartY", this.y);
		this.macro.addMacro ("$chartWidth", this.width);
		this.macro.addMacro ("$chartHeight", this.height);
		this.macro.addMacro ("$chartEndX", this.width);
		this.macro.addMacro ("$chartEndY", this.height);
		this.macro.addMacro ("$chartCenterX", this.width / 2);
		this.macro.addMacro ("$chartCenterY", this.height / 2);
		//Canvas dimension macros
		this.macro.addMacro ("$canvasStartX", this.elements.canvasBg.x);
		this.macro.addMacro ("$canvasStartY", this.elements.canvasBg.y);
		this.macro.addMacro ("$canvasWidth", this.elements.canvasBg.w);
		this.macro.addMacro ("$canvasHeight", this.elements.canvasBg.h);
		this.macro.addMacro ("$canvasEndX", this.elements.canvasBg.toX);
		this.macro.addMacro ("$canvasEndY", this.elements.canvasBg.toY);
		this.macro.addMacro ("$canvasCenterX", this.elements.canvasBg.x + (this.elements.canvasBg.w / 2));
		this.macro.addMacro ("$canvasCenterY", this.elements.canvasBg.y + (this.elements.canvasBg.h / 2));
	}
	/**
	* drawCanvas method renders the chart canvas. There are two parts to chart canvas:
	* canvas background and canvas base.
	*	@return	Nothing
	*/
	private function drawCanvas () : Void 
	{
		//Draw canvas base first (if required)
		if (this.params.showCanvasBase)
		{
			//Create a new movie clip container for canvas base
			var canvasBaseMC = this.cMC.createEmptyMovieClip ("CanvasBase", this.dm.getDepth ("CANVASBASE"));
			var canvasBase : Column3D = new Column3D (canvasBaseMC, this.elements.canvasBase.x - this.config.shifts.xShift + (this.elements.canvasBase.w / 2) , this.elements.canvasBase.toY + this.params.canvasBaseDepth - 0.1, this.elements.canvasBase.w, this.params.canvasBaseDepth, this.config.shifts.xShift, this.config.shifts.yShift, this.params.canvasBaseColor, false, "", null);
			canvasBase.draw (this.params.use3DLighting);
			//Apply filters
			this.styleM.applyFilters (canvasBaseMC, this.objects.CANVAS);
			if (this.params.animation)
			{
				this.styleM.applyAnimation (canvasBaseMC, this.objects.CANVAS, this.macro, null, 0, null, 0, 100, null, null, null);
			}
		}
		if (this.params.showCanvasBg)
		{
			//Draw the canvas backround now (if required)
			var canvasBgMC = this.cMC.createEmptyMovieClip ("CanvasBg", this.dm.getDepth ("CANVASBG"));
			if (this.params.use3DLighting)
			{
				var colors : Array = new Array ();
				var alphas : Array = [this.params.canvasBgAlpha, this.params.canvasBgAlpha];
				var ratios : Array = [0, 255];
				//Gradient if use3DLighting
				colors = [ColorExt.getDarkColor (this.params.canvasBgColor, 0.85) , ColorExt.getLightColor (this.params.canvasBgColor, 0.55)];
				var matrix : Object = {
					matrixType : "box", w : this.elements.canvasBg.w, h : this.elements.canvasBg.h, x : this.elements.canvasBg.x, y : this.elements.canvasBg.y, r : 45 * (Math.PI / 180)
				};
				canvasBgMC.beginGradientFill ("linear", colors, alphas, ratios, matrix);
			} else 
			{
				canvasBgMC.beginFill (parseInt (this.params.canvasBgColor, 16) , this.params.canvasBgAlpha);
			}
			//Draw front face
			canvasBgMC.moveTo (this.elements.canvasBg.x, this.elements.canvasBg.y);
			canvasBgMC.lineTo (this.elements.canvasBg.toX, this.elements.canvasBg.y);
			canvasBgMC.lineTo (this.elements.canvasBg.toX, this.elements.canvasBg.toY);
			canvasBgMC.lineTo (this.elements.canvasBg.x, this.elements.canvasBg.toY);
			canvasBgMC.lineTo (this.elements.canvasBg.x, this.elements.canvasBg.y);
			canvasBgMC.endFill ();
			//Draw depth (right side 3D Projection)
			//Set dark fill
			canvasBgMC.beginFill (ColorExt.getDarkColor (this.params.canvasBgColor, 0.80) , this.params.canvasBgAlpha);
			canvasBgMC.moveTo (this.elements.canvasBg.toX, this.elements.canvasBg.y);
			canvasBgMC.lineTo (this.elements.canvasBg.toX + this.params.canvasBgDepth, this.elements.canvasBg.y + this.params.canvasBgDepth);
			canvasBgMC.lineTo (this.elements.canvasBg.toX + this.params.canvasBgDepth, this.elements.canvasBg.toY - this.params.canvasBgDepth);
			canvasBgMC.lineTo (this.elements.canvasBg.toX, this.elements.canvasBg.toY);
			canvasBgMC.lineTo (this.elements.canvasBg.toX, this.elements.canvasBg.y);
			canvasBgMC.endFill ();
			//Apply filters
			this.styleM.applyFilters (canvasBgMC, this.objects.CANVAS);
			if (this.params.animation)
			{
				this.styleM.applyAnimation (canvasBgMC, this.objects.CANVAS, this.macro, null, 0, null, 0, 100, null, null, null);
			}
		}
		clearInterval (this.config.intervals.canvas);
	}
	/**
	* drawDivLines method draws the div lines on the chart
	*/
	private function drawDivLines () : Void 
	{
		var divLineValueObj : Object;
		var divLineFontObj : Object;
		var yPos : Number;
		var depth : Number = this.dm.getDepth ("DIVLINES") - 1;
		//Movie clip container
		var divLineMC : MovieClip;
		//Get div line font
		divLineFontObj = this.styleM.getTextStyle (this.objects.YAXISVALUES);
		//Set alignment
		divLineFontObj.align = "right";
		divLineFontObj.vAlign = "middle";
		//Iterate through all the div line values
		var i : Number;
		for (i = 0; i < this.divLines.length; i ++)
		{
			//Draw the zero plane for any 0 value apart from yMin
			if (this.divLines [i].value == 0 && this.divLines [i].value != this.config.yMin)
			{
				//It's a zero value div line - draw the zero plane
				this.drawZeroPlane (i);
			} 
			else if ((i == 0) || (i == this.divLines.length - 1))
			{
				//If it's the first or last div Line (limits), and limits are to be shown
				if (this.params.showLimits && this.divLines [i].showValue)
				{
					depth ++;
					//Get y position for textbox
					yPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvasBg.y, this.elements.canvasBg.toY, true, 0);
					//Create the limits text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvasBg.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			} else 
			{
				//It's a div interval - div line
				//Get y position
				yPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvasBg.y, this.elements.canvasBg.toY, true, 0);
				//Render the line
				depth ++;
				divLineMC = this.cMC.createEmptyMovieClip ("DivLine_" + i, depth);
				//Draw the line
				divLineMC.lineStyle (this.params.divLineThickness, parseInt (this.params.divLineColor, 16) , this.params.divLineAlpha);
				if (this.params.divLineIsDashed)
				{
					//Dashed line
					DrawingExt.dashTo (divLineMC, - this.elements.canvasBg.w / 2, 0, this.elements.canvasBg.w / 2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
				} else 
				{
					//Draw the line keeping 0,0 as registration point
					divLineMC.moveTo ( - this.elements.canvasBg.w / 2, 0);
					//Normal line
					divLineMC.lineTo (this.elements.canvasBg.w / 2, 0);
				}
				//Re-position the div line to required place
				divLineMC._x = this.elements.canvasBg.x + this.elements.canvasBg.w / 2;
				divLineMC._y = yPos - (this.params.divLineThickness / 2);
				//Apply animation and filter effects to div line
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineMC, this.objects.DIVLINES, this.macro, null, 0, divLineMC._y, 0, 100, 100, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineMC, this.objects.DIVLINES);
				//So, check if we've to show div line values
				if (this.params.showDivLineValues && this.divLines [i].showValue)
				{
					//Increase Depth
					depth ++;
					//Create the text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvasBg.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines [i].showValue)
			{
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvasBg.x - this.params.yAxisValuesPadding - divLineValueObj.width, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
			}
		}
		delete divLineValueObj;
		delete divLineFontObj;
		//Clear interval
		clearInterval (this.config.intervals.divLines);
	}
	/**
	* drawZeroPlane method draws the zero plane on chart
	*	@param	i	Index of zero plane in divLines array
	*/
	private function drawZeroPlane (i) : Void
	{
		if (this.params.showZeroPlane)
		{
			var zeroPlaneFontObj : Object;
			//Get zero line font
			zeroPlaneFontObj = this.styleM.getTextStyle (this.objects.YAXISVALUES);
			//Set alignment
			zeroPlaneFontObj.align = "right";
			zeroPlaneFontObj.vAlign = "middle";
			//Depth for zero plane
			var zpDepth : Number = this.dm.getDepth ("ZEROPLANE");
			//Depth for zero plane value
			var zpVDepth : Number = zpDepth ++;
			//Get y position
			var yPos : Number = this.getAxisPosition (0, this.config.yMax, this.config.yMin, this.elements.canvasBg.y, this.elements.canvasBg.toY, true, 0);
			//Render the line
			var zeroPlaneMC = this.cMC.createEmptyMovieClip ("ZeroPlane", zpDepth);
			//Create zero plane as column 3D with 1 pixel height
			var zeroPlane : Column3D = new Column3D (zeroPlaneMC, this.elements.canvasBase.x - this.config.shifts.xShift + (this.elements.canvasBase.w / 2) , yPos + this.config.shifts.yShift + 1, this.elements.canvasBase.w, 1, this.config.shifts.xShift, this.config.shifts.yShift, this.params.zeroPlaneColor, this.params.zeroPlaneShowBorder, this.params.zeroPlaneBorderColor, 100);
			zeroPlane.draw (this.params.use3DLighting);
			//Apply alpha
			zeroPlaneMC._alpha = this.params.zeroPlaneAlpha;
			//Apply animation and filter effects to zero plane
			//Apply animation
			if (this.params.animation)
			{
				this.styleM.applyAnimation (zeroPlaneMC, this.objects.DIVLINES, this.macro, null, 0, null, 0, this.params.zeroPlaneAlpha, null, null, null);
			}
			//Apply filters
			this.styleM.applyFilters (zeroPlaneMC, this.objects.DIVLINES);
			//So, check if we've to show div line values
			if (this.params.showDivLineValues && this.divLines [i].showValue)
			{
				//Create the text
				var zeroPlaneValueObj : Object = createText (false, this.divLines [i].displayValue, this.cMC, zpVDepth, this.elements.canvasBg.x - this.params.yAxisValuesPadding, yPos, 0, zeroPlaneFontObj, false, 0, 0);
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines [i].showValue)
			{
				if (this.params.animation)
				{
					this.styleM.applyAnimation (zeroPlaneValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvasBg.x - this.params.yAxisValuesPadding - zeroPlaneValueObj.width, 0, yPos - (zeroPlaneValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (zeroPlaneValueObj.tf, this.objects.YAXISVALUES);
			}
		}
	}
	/**
	* drawTrendLines method draws the trend lines on the chart
	* with their respective values.
	*/
	private function drawTrendLines () : Void 
	{
		var trendFontObj : Object;
		var trendValueObj : Object;
		var lineDepth : Number = this.dm.getDepth ("TRENDLINES");
		var valueDepth : Number = this.dm.getDepth ("TRENDVALUES");
		var tbAnimX : Number = 0;
		//Movie clip container
		var trendLineMC : MovieClip;
		//Get font
		trendFontObj = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		//Set vertical alignment
		trendFontObj.vAlign = "middle";
		//Delegate handler function
		var fnRollOver:Function;
		//Loop variable
		var i : Number;
		//Iterate through all the trend lines
		for (i = 1; i <= this.numTrendLines; i ++)
		{
			if (this.trendLines [i].isValid == true)
			{
				//If it's a valid trend line
				//Get the depth and update counters
				trendLineMC = this.cMC.createEmptyMovieClip ("TrendLine_" + i, lineDepth);
				//Now, draw the line or trend zone
				if (this.trendLines [i].isTrendZone)
				{
					//Create rectangle
					trendLineMC.lineStyle ();
					//Absolute height value
					this.trendLines [i].h = Math.abs (this.trendLines [i].h);
					//We need to align rectangle at L,M
					trendLineMC.moveTo (0, 0);
					//Begin fill
					trendLineMC.beginFill (parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Draw rectangle
					trendLineMC.lineTo (0, - (this.trendLines [i].h / 2));
					trendLineMC.lineTo (this.elements.canvasBg.w, - (this.trendLines [i].h / 2));
					trendLineMC.lineTo (this.elements.canvasBg.w, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, 0);
					//Re-position
					trendLineMC._x = this.elements.canvasBg.x;
					trendLineMC._y = this.trendLines [i].tbY;
				} else 
				{
					//If the tooltext is to be shown for this trend line and the thickness is less than 3 pixels
					//we increase the hit area to 4 pixels with 0 alpha.
					if (this.params.showToolTip && (this.trendLines[i].toolText != "") && (this.trendLines [i].thickness < 4)) {
						//Set line style with alpha 0
						trendLineMC.lineStyle (4, parseInt (this.trendLines [i].color, 16) , 0);
						//Draw the hit area
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.elements.canvasBg.w, this.trendLines [i].h);
					}
					//Just draw line
					trendLineMC.lineStyle (this.trendLines [i].thickness, parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Now, if dashed line is to be drawn
					if ( ! this.trendLines [i].isDashed)
					{
						//Draw normal line line keeping 0,0 as registration point
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.elements.canvasBg.w, this.trendLines [i].h);
					} else 
					{
						//Dashed Line line
						DrawingExt.dashTo (trendLineMC, 0, 0, this.elements.canvasBg.w, this.trendLines [i].h, this.trendLines [i].dashLen, this.trendLines [i].dashGap);
					}
					//Re-position line
					trendLineMC._x = this.elements.canvasBg.x;
					trendLineMC._y = this.trendLines [i].y;
				}
				//Set the trend line tool-text
				if (this.params.showToolTip && this.trendLines[i].toolText != "") {
					//Do not use hand cursor
					trendLineMC.useHandCursor = false;
					//Create Delegate for roll over function showToolTip
					fnRollOver = Delegate.create (this, showToolTip);
					//Set the tool text
					fnRollOver.toolText = this.trendLines[i].toolText;
					//Assing the delegates to movie clip handler
					trendLineMC.onRollOver = fnRollOver;
					//Set roll out and mouse move too.
					trendLineMC.onRollOut = trendLineMC.onReleaseOutside = Delegate.create (this, hideToolTip);
					trendLineMC.onMouseMove = Delegate.create (this, repositionToolTip);
				}
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendLineMC, this.objects.TRENDLINES, this.macro, null, 0, trendLineMC._y, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendLineMC, this.objects.TRENDLINES);
				//---------------------------------------------------------------------------//
				//Set color
				trendFontObj.color = this.trendLines [i].color;
				//Now, render the trend line value, based on its position
				if (this.trendLines [i].valueOnRight == false)
				{
					//Value to be placed on right
					trendFontObj.align = "right";
					//Create text
					trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.elements.canvasBg.x - this.params.yAxisValuesPadding, this.trendLines [i].tbY, 0, trendFontObj, false, 0, 0);
					//X-position for text box animation
					tbAnimX = this.elements.canvasBg.x - this.params.yAxisValuesPadding - trendValueObj.width;
				} else 
				{
					//Left side
					trendFontObj.align = "left";
					//Create text
					trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.elements.canvas.toX + this.params.yAxisValuesPadding, this.trendLines [i].tbY, 0, trendFontObj, false, 0, 0);
					//X-position for text box animation
					tbAnimX = this.elements.canvas.toX + this.params.yAxisValuesPadding;
				}
				//Animation and filter effect
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendValueObj.tf, this.objects.TRENDVALUES, this.macro, tbAnimX, 0, this.trendLines [i].tbY - (trendValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendValueObj.tf, this.objects.TRENDVALUES);
				//Increment depth
				lineDepth ++;
				valueDepth ++;
			}
		}
		delete trendLineMC;
		delete trendValueObj;
		delete trendFontObj;
		//Clear interval
		clearInterval (this.config.intervals.trend);
	}
	/**
	* drawVLines method draws the vertical axis lines on the chart
	*/
	private function drawVLines () : Void 
	{
		var depth : Number = this.dm.getDepth ("VLINES");
		//Movie clip container
		var vLineMC : MovieClip;
		//Depth of label
		var labelDepth : Number = this.dm.getDepth("VLINELABELS");
		//Label
		var vLineLabel:Object;
		//Get the font properties for v-line labels
		var vLineFont:Object = this.styleM.getTextStyle (this.objects.VLINELABELS);
		//Loop var
		var i : Number;
		//Iterate through all the v div lines
		for (i = 1; i <= this.numVLines; i ++)
		{
			if (this.vLines [i].isValid == true)
			{
				//If it's a valid line, proceed
				//Check if we've to draw the label of the same
				if (this.vLines[i].label != "") {
					//Customize the font properties for the same.
					vLineFont.borderColor = (this.vLines[i].showLabelBorder == true)?(this.vLines[i].color):("");
					//Set the color as well
					vLineFont.color = this.vLines[i].color;
					//Set the alignment position
					vLineFont.align = this.vLines[i].labelHAlign;
					vLineFont.vAlign = this.vLines[i].labelVAlign;
					//Create the label now
					vLineLabel = createText (false, this.vLines[i].label, this.cMC, labelDepth, this.vLines[i].x + this.config.shifts.xShift, this.elements.canvasBg.y + (this.elements.canvasBg.h*this.vLines[i].labelPosition), 0, vLineFont, false, 0, 0);
					//Apply filters
					this.styleM.applyFilters (vLineLabel.tf, this.objects.VLINELABELS);
					//Animation 
					if (this.params.animation){
						this.styleM.applyAnimation (vLineLabel.tf, this.objects.VLINELABELS, this.macro, vLineLabel.tf._x, 0, vLineLabel.tf._y, 0, 100, null, null, null);
					}
					//Increment depth
					labelDepth++;
				}
				//Create a movie clip for the line
				vLineMC = this.cMC.createEmptyMovieClip ("vLine_" + i, depth);
				//Just draw line
				vLineMC.lineStyle (this.vLines [i].thickness, parseInt (this.vLines [i].color, 16) , this.vLines [i].alpha);
				//Now, if dashed line is to be drawn
				if ( ! this.vLines [i].isDashed)
				{
					//Draw normal line line keeping 0,0 as registration point
					vLineMC.moveTo (0, 0);
					vLineMC.lineTo (0, - this.elements.canvasBg.h);
				} else 
				{
					//Dashed Line line
					DrawingExt.dashTo (vLineMC, 0, 0, 0, - this.elements.canvasBg.h, this.vLines [i].dashLen, this.vLines [i].dashGap);
				}
				//Re-position line
				vLineMC._x = this.vLines [i].x + this.config.shifts.xShift ;
				vLineMC._y = this.elements.canvasBg.toY;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (vLineMC, this.objects.VLINES, this.macro, vLineMC._x, 0, vLineMC._y, 0, 100, null, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (vLineMC, this.objects.VLINES);
				//Increase depth
				depth ++;
			}
		}
		delete vLineMC;
		//Clear interval
		clearInterval (this.config.intervals.vLine);
	}
	/**
	* reInit method re-initializes the chart. This method is basically called
	* when the user changes chart data through JavaScript. In that case, we need
	* to re-initialize the chart, set new XML data and again render.
	*/
	public function reInit () : Void 
	{
		//Invoke super class's reInit
		super.reInit ();
		//Change local parameters here
		numNeg = 0;
		numPos = 0;
	}
}
