/**
* @class DualYAxis2DChart
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
* DualYAxis2DChart extends DualYAxisChart class to encapsulate
* functionalities of a 2D chart with dual axes. All such
* charts extend this class.
*/
//Import parent class
import com.fusioncharts.core.DualYAxisChart;
//Extensions
import com.fusioncharts.extensions.ColorExt;
import com.fusioncharts.extensions.StringExt;
import com.fusioncharts.extensions.MathExt;
import com.fusioncharts.extensions.DrawingExt;
//Delegate
import mx.utils.Delegate;
class com.fusioncharts.core.DualYAxis2DChart extends DualYAxisChart 
{
	//Instance variables
	/**
	* Constructor function. We invoke the super class'
	* constructor.
	*/
	function DualYAxis2DChart (targetMC : MovieClip, depth : Number, width : Number, height : Number, x : Number, y : Number, debugMode : Boolean, lang : String, scaleMode:String, registerWithJS:Boolean, DOMId:String)
	{
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
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
		this.macro.addMacro ("$canvasStartX", this.elements.canvas.x);
		this.macro.addMacro ("$canvasStartY", this.elements.canvas.y);
		this.macro.addMacro ("$canvasWidth", this.elements.canvas.w);
		this.macro.addMacro ("$canvasHeight", this.elements.canvas.h);
		this.macro.addMacro ("$canvasEndX", this.elements.canvas.toX);
		this.macro.addMacro ("$canvasEndY", this.elements.canvas.toY);
		this.macro.addMacro ("$canvasCenterX", this.elements.canvas.x + (this.elements.canvas.w / 2));
		this.macro.addMacro ("$canvasCenterY", this.elements.canvas.y + (this.elements.canvas.h / 2));
	}
	/**
	* drawCanvas method renders the chart canvas.
	*	@return	Nothing
	*/
	private function drawCanvas () : Void 
	{
		//Create a new movie clip container for canvas
		var canvasMC = this.cMC.createEmptyMovieClip ("Canvas", this.dm.getDepth ("CANVAS"));
		
		//Parse the color, alpha and ratio array
		var canvasColor : Array = ColorExt.parseColorList (this.params.canvasBgColor);
		var canvasAlpha : Array = ColorExt.parseAlphaList (this.params.canvasBgAlpha, canvasColor.length);
		var canvasRatio : Array = ColorExt.parseRatioList (this.params.canvasBgRatio, canvasColor.length);
			
		//Create matrix object
		var matrix : Object = {
			matrixType : "box", w : this.elements.canvas.w, h : this.elements.canvas.h, x : - (this.elements.canvas.w / 2) , y : - (this.elements.canvas.h / 2) , r : MathExt.toRadians (this.params.canvasBgAngle)
		};
		//Start the fill.
		canvasMC.beginGradientFill ("linear", canvasColor, canvasAlpha, canvasRatio, matrix);
		
		if (this.params.useRoundEdges==true){
			//Rounded Canvas
			DrawingExt.drawRoundedRect(canvasMC, -this.elements.canvas.w/2, -this.elements.canvas.h/2, this.elements.canvas.w, this.elements.canvas.h, {tl:this.roundEdgeRadius,tr:this.roundEdgeRadius,bl:0,br:0}, {t:"", l:"", b:"", r:""}, {t:0, b:0, l:0, r:0}, {t:0, l:0, b:0, r:0});
			canvasMC._x = this.elements.canvas.x + this.elements.canvas.w/2;
			canvasMC._y = this.elements.canvas.y + this.elements.canvas.h/2;
		}else{		
			//Normal Canvas - Rectangular			
			//Set border properties - not visible
			//canvasMC.lineStyle(this.params.canvasBorderThickness, parseInt(this.params.canvasBorderColor, 16), this.params.canvasBorderAlpha);
			canvasMC.lineStyle ();
			//Move to (-w/2, 0);
			canvasMC.moveTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
			
			//Draw the rectangle with center registration point
			canvasMC.lineTo (this.elements.canvas.w / 2, - (this.elements.canvas.h / 2));
			canvasMC.lineTo (this.elements.canvas.w / 2, this.elements.canvas.h / 2);
			canvasMC.lineTo ( - (this.elements.canvas.w / 2) , this.elements.canvas.h / 2);
			canvasMC.lineTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
			//Set the x and y position
			canvasMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
			canvasMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
			//End Fill
			canvasMC.endFill ();
			// --------------------------- DRAW CANVAS BORDER --------------------------//
			//Canvas Border
			if (this.params.canvasBorderAlpha > 0)
			{
				//Create a new movie clip container for canvas
				var canvasBorderMC = this.cMC.createEmptyMovieClip ("CanvasBorder", this.dm.getDepth ("CANVASBORDER"));
				//Set border properties
				canvasBorderMC.lineStyle (this.params.canvasBorderThickness, parseInt (this.params.canvasBorderColor, 16) , this.params.canvasBorderAlpha);
				//Move to (-w/2, 0);
				canvasBorderMC.moveTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
				//Draw the rectangle with center registration point
				canvasBorderMC.lineTo (this.elements.canvas.w / 2, - (this.elements.canvas.h / 2));
				canvasBorderMC.lineTo (this.elements.canvas.w / 2, this.elements.canvas.h / 2);
				canvasBorderMC.lineTo ( - (this.elements.canvas.w / 2) , this.elements.canvas.h / 2);
				canvasBorderMC.lineTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
				//Set the x and y position
				canvasBorderMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
				canvasBorderMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
			}			
		}
		//Apply animation
		if (this.params.animation)
		{
			if (this.params.useRoundEdges==false || this.params.useRoundEdges==undefined){
				this.styleM.applyAnimation (canvasBorderMC, this.objects.CANVAS, this.macro, canvasBorderMC._x, - this.elements.canvas.w / 2, canvasBorderMC._y, - this.elements.canvas.h / 2, 100, 100, 100, null);
			}
			this.styleM.applyAnimation (canvasMC, this.objects.CANVAS, this.macro, canvasMC._x, - this.elements.canvas.w / 2, canvasMC._y, - this.elements.canvas.h / 2, 100, 100, 100, null);
		}
		//Apply filters
		this.styleM.applyFilters (canvasMC, this.objects.CANVAS);
		clearInterval (this.config.intervals.canvas);
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
				this.trendLines [i].y = this.getAxisPosition (this.trendLines [i].startValue, (this.trendLines [i].parentYAxis == "P") ?this.config.PYMax : this.config.SYMax, (this.trendLines [i].parentYAxis == "P") ?this.config.PYMin : this.config.SYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//If end value is different from start value
				if (this.trendLines [i].startValue != this.trendLines [i].endValue)
				{
					//Calculate y for end value
					this.trendLines [i].toY = this.getAxisPosition (this.trendLines [i].endValue, (this.trendLines [i].parentYAxis == "P") ?this.config.PYMax : this.config.SYMax, (this.trendLines [i].parentYAxis == "P") ?this.config.PYMin : this.config.SYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
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
	//---------------------------- VISUAL RENDERING METHODS ------------------------------//
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
					vLineLabel = createText (false, this.vLines[i].label, this.cMC, labelDepth, this.vLines[i].x, this.elements.canvas.y + (this.elements.canvas.h*this.vLines[i].labelPosition), 0, vLineFont, false, 0, 0);
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
					vLineMC.lineTo (0, - this.elements.canvas.h);
				} else 
				{
					//Dashed Line line
					DrawingExt.dashTo (vLineMC, 0, 0, 0, - this.elements.canvas.h, this.vLines [i].dashLen, this.vLines [i].dashGap);
				}
				//Re-position line
				vLineMC._x = this.vLines [i].x;
				vLineMC._y = this.elements.canvas.toY;
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
	* drawTrendLines method draws the trend lines on the chart
	* with their respective values.
	*/
	private function drawTrendLines () : Void 
	{
		var trendFontObj : Object;
		var trendValueObj : Object;
		var lineBelowDepth : Number = this.dm.getDepth ("TRENDLINESBELOW");
		var valueBelowDepth : Number = this.dm.getDepth ("TRENDVALUESBELOW");
		var lineAboveDepth : Number = this.dm.getDepth ("TRENDLINESABOVE");
		var valueAboveDepth : Number = this.dm.getDepth ("TRENDVALUESABOVE");
		var lineDepth : Number;
		var valueDepth : Number;
		var tbAnimX : Number = 0;
		//Movie clip container
		var trendLineMC : MovieClip;
		//Delegate handler function
		var fnRollOver:Function;
		//Get font
		trendFontObj = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		//Set vertical alignment
		trendFontObj.vAlign = "middle";
		//Loop variable
		var i : Number;
		//Iterate through all the trend lines
		for (i = 1; i <= this.numTrendLines; i ++)
		{
			if (this.trendLines [i].isValid == true)
			{
				//If it's a valid trend line
				//Get the depth and update counters
				if (this.trendLines [i].showOnTop)
				{
					//If the trend line is to be shown on top.
					lineDepth = lineAboveDepth;
					valueDepth = valueAboveDepth;
					lineAboveDepth ++;
					valueAboveDepth ++;
				} else 
				{
					//If it's to be shown below columns.
					lineDepth = lineBelowDepth;
					valueDepth = valueBelowDepth;
					lineBelowDepth ++;
					valueBelowDepth ++;
				}
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
					trendLineMC.lineTo (this.elements.canvas.w, - (this.trendLines [i].h / 2));
					trendLineMC.lineTo (this.elements.canvas.w, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, 0);
					//Re-position
					trendLineMC._x = this.elements.canvas.x;
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
						trendLineMC.lineTo (this.elements.canvas.w, this.trendLines [i].h);
					}
					//Just draw line
					trendLineMC.lineStyle (this.trendLines [i].thickness, parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Now, if dashed line is to be drawn
					if ( ! this.trendLines [i].isDashed)
					{
						//Draw normal line line keeping 0,0 as registration point
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.elements.canvas.w, this.trendLines [i].h);
					} else 
					{
						//Dashed Line line
						DrawingExt.dashTo (trendLineMC, 0, 0, this.elements.canvas.w, this.trendLines [i].h, this.trendLines [i].dashLen, this.trendLines [i].dashGap);
					}
					//Re-position line
					trendLineMC._x = this.elements.canvas.x;
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
					trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.elements.canvas.x - this.params.yAxisValuesPadding, this.trendLines [i].tbY, 0, trendFontObj, false, 0, 0);
					//X-position for text box animation
					tbAnimX = this.elements.canvas.x - this.params.yAxisValuesPadding - trendValueObj.width;
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
			}
		}
		delete trendLineMC;
		delete trendValueObj;
		delete trendFontObj;
		//Clear interval
		clearInterval (this.config.intervals.trend);
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
			//If it's the first or last div Line (limits), and limits are to be shown
			if ((i == 0) || (i == this.divLines.length - 1))
			{
				if (this.params.showLimits && this.divLines [i].showValue)
				{
					depth ++;
					//Get y position for textbox
					yPos = this.getAxisPosition (this.divLines [i].value, this.config.PYMax, this.config.PYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Create the limits text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			} else if (this.divLines [i].value == 0)
			{
				//It's a zero value div line - check if we've to show
				if (this.params.showZeroPlane)
				{
					//Depth for zero plane
					var zpDepth : Number = this.dm.getDepth ("ZEROPLANE");
					//Depth for zero plane value
					var zpVDepth : Number = zpDepth ++;
					//Get y position
					yPos = this.getAxisPosition (0, this.config.PYMax, this.config.PYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Render the line
					var zeroPlaneMC = this.cMC.createEmptyMovieClip ("ZeroPlane", zpDepth);
					//Draw the line
					zeroPlaneMC.lineStyle (this.params.zeroPlaneThickness, parseInt (this.params.zeroPlaneColor, 16) , this.params.zeroPlaneAlpha);
					if (this.params.divLineIsDashed)
					{
						//Dashed line
						DrawingExt.dashTo (zeroPlaneMC, - this.elements.canvas.w / 2, 0, this.elements.canvas.w / 2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
					} else 
					{
						//Draw the line keeping 0,0 as registration point
						zeroPlaneMC.moveTo ( - this.elements.canvas.w / 2, 0);
						//Normal line
						zeroPlaneMC.lineTo (this.elements.canvas.w / 2, 0);
					}
					//Re-position the div line to required place
					zeroPlaneMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
					zeroPlaneMC._y = yPos - (this.params.zeroPlaneThickness / 2);
					//Apply animation and filter effects to div line
					//Apply animation
					if (this.params.animation)
					{
						this.styleM.applyAnimation (zeroPlaneMC, this.objects.DIVLINES, this.macro, null, 0, zeroPlaneMC._y, 0, 100, 100, null, null);
					}
					//Apply filters
					this.styleM.applyFilters (zeroPlaneMC, this.objects.DIVLINES);
					//So, check if we've to show div line values
					if (this.params.showDivLineValues && this.divLines [i].showValue)
					{
						//Create the text
						divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, zpVDepth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
					}
					//Apply animation and filter effects to div line (y-axis) values
					if (this.divLines [i].showValue)
					{
						if (this.params.animation)
						{
							this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x - this.params.yAxisValuesPadding - divLineValueObj.width, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
						}
						//Apply filters
						this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
					}
				}
			} else 
			{
				//It's a div interval - div line
				//Get y position
				yPos = this.getAxisPosition (this.divLines [i].value, this.config.PYMax, this.config.PYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//Render the line
				depth ++;
				divLineMC = this.cMC.createEmptyMovieClip ("DivLine_" + i, depth);
				//Draw the line
				divLineMC.lineStyle (this.params.divLineThickness, parseInt (this.params.divLineColor, 16) , this.params.divLineAlpha);
				if (this.params.divLineIsDashed)
				{
					//Dashed line
					DrawingExt.dashTo (divLineMC, - this.elements.canvas.w / 2, 0, this.elements.canvas.w / 2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
				} else 
				{
					//Draw the line keeping 0,0 as registration point
					divLineMC.moveTo ( - this.elements.canvas.w / 2, 0);
					//Normal line
					divLineMC.lineTo (this.elements.canvas.w / 2, 0);
				}
				//Re-position the div line to required place
				divLineMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
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
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines [i].showValue)
			{
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x - this.params.yAxisValuesPadding - divLineValueObj.width, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
			}
		}
		// ---------- SECONDARY DIV LINE VALUES ------------//
		//Change alignment position
		divLineFontObj.align = "left";
		//Flag whether to show the secondary div line value
		var showSDivValue : Boolean = false;
		//Draw the secondary div line values
		for (i = 0; i < this.sDivLines.length; i ++)
		{
			//Set flag to false
			showSDivValue = false;
			//If it's the upper or lower limit
			if ((i == 0) || (i == this.sDivLines.length - 1))
			{
				if (this.params.showSecondaryLimits && this.sDivLines [i].showValue)
				{
					showSDivValue = true;
				}
			} else if (this.params.showDivLineSecondaryValue && this.sDivLines [i].showValue)
			{
				showSDivValue = true;
			}
			//Now, if the div line value is to be shown
			if (showSDivValue)
			{
				//Increase Depth
				depth ++;
				//Get y position
				yPos = this.getAxisPosition (this.sDivLines [i].value, this.config.SYMax, this.config.SYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//Create the text
				divLineValueObj = createText (false, this.sDivLines [i].displayValue, this.cMC, depth, this.elements.canvas.toX + this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.toX + this.params.yAxisValuesPadding, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
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
	* drawHGrid method draws the horizontal grid background color
	*/
	private function drawHGrid () : Void 
	{
		//If we're required to draw horizontal grid color
		//and numDivLines > 3
		if (this.params.showAlternateHGridColor && this.divLines.length > 3)
		{
			//Movie clip container
			var gridMC : MovieClip;
			//Loop variable
			var i : Number;
			//Get depth
			var depth : Number = this.dm.getDepth ("HGRID");
			//Y Position
			var yPos : Number, yPosEnd : Number;
			var height : Number;
			for (i = 1; i < this.divLines.length - 1; i = i + 2)
			{
				//Get y position
				yPos = this.getAxisPosition (this.divLines [i].value, this.config.PYMax, this.config.PYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				yPosEnd = this.getAxisPosition (this.divLines [i + 1].value, this.config.PYMax, this.config.PYMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				height = yPos - yPosEnd;
				//Create the movie clip
				gridMC = this.cMC.createEmptyMovieClip ("GridBg_" + i, depth);
				//Set line style to null
				gridMC.lineStyle ();
				//Set fill color
				gridMC.moveTo ( - (this.elements.canvas.w / 2) , - (height / 2));
				gridMC.beginFill (parseInt (this.params.alternateHGridColor, 16) , this.params.alternateHGridAlpha);
				//Draw rectangle
				gridMC.lineTo (this.elements.canvas.w / 2, - (height / 2));
				gridMC.lineTo (this.elements.canvas.w / 2, height / 2);
				gridMC.lineTo ( - (this.elements.canvas.w / 2) , height / 2);
				gridMC.lineTo ( - (this.elements.canvas.w / 2) , - (height / 2));
				//End Fill
				gridMC.endFill ();
				//Place it in right location
				gridMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
				gridMC._y = yPos - (height) / 2;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (gridMC, this.objects.HGRID, this.macro, null, 0, gridMC._y, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (gridMC, this.objects.HGRID);
				//Increase depth
				depth ++;
			}
		}
		//Clear interval
		clearInterval (this.config.intervals.hGrid);
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
		
	}
}
