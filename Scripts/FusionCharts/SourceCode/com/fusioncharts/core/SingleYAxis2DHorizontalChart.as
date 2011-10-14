 /**
* @class SingleYAxis2DHorizontalChart
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
* SingleYAxis2DHorizontalChart extends SingleYAxis2DChart class to encapsulate
* functionalities of a single series 2D chart with a single HORIZONTAL axes. All such
* charts extend this class.
*/
//Import parent class
import com.fusioncharts.core.SingleYAxis2DChart;
//Extensions
import com.fusioncharts.extensions.ColorExt;
import com.fusioncharts.extensions.StringExt;
import com.fusioncharts.extensions.MathExt;
import com.fusioncharts.extensions.DrawingExt;
//Delegate
import mx.utils.Delegate;
//Import Logger Class
import com.fusioncharts.helper.Logger;
class com.fusioncharts.core.SingleYAxis2DHorizontalChart extends SingleYAxis2DChart 
{
	//Instance variables
	/**
	* Constructor function. We invoke the super class'
	* constructor.
	*/
	function SingleYAxis2DHorizontalChart (targetMC : MovieClip, depth : Number, width : Number, height : Number, x : Number, y : Number, debugMode : Boolean, lang : String, scaleMode:String, registerWithJS:Boolean, DOMId:String)
	{
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
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
				this.trendLines [i].x = this.getAxisPosition (this.trendLines [i].startValue, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
				//If end value is different from start value
				if (this.trendLines [i].startValue != this.trendLines [i].endValue)
				{
					//Calculate X for end value
					this.trendLines [i].toX = this.getAxisPosition (this.trendLines [i].endValue, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
					//Now, if it's a trend zone, we need mid value
					if (this.trendLines [i].isTrendZone)
					{
						//For textbox x position, we need mid value.
						this.trendLines [i].tbX = Math.min (this.trendLines [i].x, this.trendLines [i].toX) + (Math.abs (this.trendLines [i].x - this.trendLines [i].toX) / 2);
					} else 
					{
						this.trendLines [i].tbX = this.trendLines [i].toX;
					}
					//Width
					this.trendLines [i].w = (this.trendLines [i].toX - this.trendLines [i].x);
				} else 
				{
					//Just copy
					this.trendLines [i].toX = this.trendLines [i].x;
					//Set same position for value tb
					this.trendLines [i].tbX = this.trendLines [i].x;
					//Width
					this.trendLines [i].w = 0;
				}
			}
		}
	}
	//---------------------------- VISUAL RENDERING METHODS ------------------------------//
	/**
	* drawVLines method draws the vertical axis lines on the chart. On the horizontal charts,
	* they're actually horizontal lines - but we still refer to them as VLINES to maintain
	* uniformity amongst charts and to keep a single XML valid across multiple charts.
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
					vLineFont.align = (this.vLines[i].labelPosition<0.6)?"left":"right";
					vLineFont.vAlign = "middle";
					//Create the label now
					vLineLabel = createText (false, this.vLines[i].label, this.cMC, labelDepth, this.elements.canvas.x + (this.elements.canvas.w*this.vLines[i].labelPosition), this.vLines [i].y, 0, vLineFont, false, 0, 0);
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
					vLineMC.lineTo (this.elements.canvas.w, 0);
				} else 
				{
					//Dashed Line line
					DrawingExt.dashTo (vLineMC, 0, 0, this.elements.canvas.w, 0, this.vLines [i].dashLen, this.vLines [i].dashGap);
				}
				//Re-position line
				vLineMC._x = this.elements.canvas.x;
				vLineMC._y = this.vLines [i].y;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (vLineMC, this.objects.VLINES, this.macro, vLineMC._x, 0, vLineMC._y, 0, 100, 100, null, null);
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
		//Get font
		trendFontObj = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		//Set vertical alignment
		trendFontObj.vAlign = "bottom";
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
					//Absolute width value
					this.trendLines [i].w = Math.abs (this.trendLines [i].w);
					//We need to align rectangle at C,B
					trendLineMC.moveTo (0, 0);
					//Begin fill
					trendLineMC.beginFill (parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Draw rectangle
					trendLineMC.lineTo ( - (this.trendLines [i].w / 2) , 0);
					trendLineMC.lineTo ( - (this.trendLines [i].w / 2) , this.elements.canvas.h);
					trendLineMC.lineTo (this.trendLines [i].w / 2, this.elements.canvas.h);
					trendLineMC.lineTo (this.trendLines [i].w / 2, 0);
					trendLineMC.lineTo ( - (this.trendLines [i].w / 2) , 0);
					//Re-position
					trendLineMC._x = this.trendLines [i].tbX;
					trendLineMC._y = this.elements.canvas.y;
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
						trendLineMC.lineTo (this.trendLines [i].w, this.elements.canvas.h);
					} else 
					{
						//Dashed Line line
						DrawingExt.dashTo (trendLineMC, 0, 0, this.trendLines [i].w, this.elements.canvas.h, this.trendLines [i].dashLen, this.trendLines [i].dashGap);
					}
					//Re-position line
					trendLineMC._x = this.trendLines [i].x;
					trendLineMC._y = this.elements.canvas.y;
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
					this.styleM.applyAnimation (trendLineMC, this.objects.TRENDLINES, this.macro, trendLineMC._x, 0, null, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendLineMC, this.objects.TRENDLINES);
				//---------------------------------------------------------------------------//
				//Set color
				trendFontObj.color = this.trendLines [i].color;
				//Now, render the trend line value
				trendFontObj.align = "center";
				//Create text
				trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.trendLines [i].tbX, this.elements.canvas.toY + this.config.yValAreaHeight + this.params.yAxisValuesPadding, 0, trendFontObj, false, 0, 0);
				//Animation and filter effect
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendValueObj.tf, this.objects.TRENDVALUES, this.macro, trendValueObj.tf._x, 0, trendValueObj.tf._y, 0, 100, null, null, null);
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
		var xPos : Number;
		var depth : Number = this.dm.getDepth ("DIVLINES") - 1;
		//Movie clip container
		var divLineMC : MovieClip;
		//Get div line font
		divLineFontObj = this.styleM.getTextStyle (this.objects.YAXISVALUES);
		//Set alignment
		divLineFontObj.align = "center";
		divLineFontObj.vAlign = "bottom";
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
					//Get x position for textbox
					xPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
					//Create the limits text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, xPos, this.elements.canvas.toY + this.params.yAxisValuesPadding, 0, divLineFontObj, false, 0, 0);
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
					//Get x position
					xPos = this.getAxisPosition (0, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
					//Render the line
					var zeroPlaneMC = this.cMC.createEmptyMovieClip ("ZeroPlane", zpDepth);
					//Draw the line
					zeroPlaneMC.lineStyle (this.params.zeroPlaneThickness, parseInt (this.params.zeroPlaneColor, 16) , this.params.zeroPlaneAlpha);
					if (this.params.divLineIsDashed)
					{
						//Dashed line
						DrawingExt.dashTo (zeroPlaneMC, 0, - this.elements.canvas.h / 2, 0, this.elements.canvas.h / 2, this.params.divLineDashLen, this.params.divLineDashGap);
					} else 
					{
						//Draw the line keeping 0,0 as registration point
						zeroPlaneMC.moveTo (0, - this.elements.canvas.h / 2);
						//Normal line
						zeroPlaneMC.lineTo (0, this.elements.canvas.h / 2);
					}
					//Re-position the div line to required place
					zeroPlaneMC._x = xPos - (this.params.zeroPlaneThickness / 2);
					zeroPlaneMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
					//Apply animation and filter effects to div line
					//Apply animation
					if (this.params.animation)
					{
						this.styleM.applyAnimation (zeroPlaneMC, this.objects.DIVLINES, this.macro, null, 0, zeroPlaneMC._y, 0, 100, null, 100, null);
					}
					//Apply filters
					this.styleM.applyFilters (zeroPlaneMC, this.objects.DIVLINES);
					//So, check if we've to show div line values
					if (this.params.showDivLineValues && this.divLines [i].showValue)
					{
						divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, zpVDepth, xPos, this.elements.canvas.toY + this.params.yAxisValuesPadding, 0, divLineFontObj, false, 0, 0);
					}
					//Apply animation and filter effects to div line (y-axis) values
					if (this.divLines [i].showValue)
					{
						if (this.params.animation)
						{
							this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, divLineValueObj.tf._x, 0, divLineValueObj.tf._y, 0, 100, null, null, null);
						}
						//Apply filters
						this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
					}
				}
			} else 
			{
				//It's a div interval - div line
				//Get x position
				xPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
				//Render the line
				depth ++;
				divLineMC = this.cMC.createEmptyMovieClip ("DivLine_" + i, depth);
				//Draw the line
				divLineMC.lineStyle (this.params.divLineThickness, parseInt (this.params.divLineColor, 16) , this.params.divLineAlpha);
				if (this.params.divLineIsDashed)
				{
					//Dashed line
					DrawingExt.dashTo (divLineMC, 0, - this.elements.canvas.h / 2, 0, this.elements.canvas.h / 2, this.params.divLineDashLen, this.params.divLineDashGap);
				} else 
				{
					//Draw the line keeping 0,0 as registration point
					divLineMC.moveTo (0, - this.elements.canvas.h / 2);
					//Normal line
					divLineMC.lineTo (0, this.elements.canvas.h / 2);
				}
				//Re-position the div line to required place
				divLineMC._x = xPos - (this.params.zeroPlaneThickness / 2);
				divLineMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
				//Apply animation and filter effects to div line
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineMC, this.objects.DIVLINES, this.macro, divLineMC._x, 0, null, 0, 100, null, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineMC, this.objects.DIVLINES);
				//So, check if we've to show div line values
				if (this.params.showDivLineValues && this.divLines [i].showValue)
				{
					//Increase Depth
					depth ++;
					//Create the text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, xPos, this.elements.canvas.toY + this.params.yAxisValuesPadding, 0, divLineFontObj, false, 0, 0);
				}
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines [i].showValue)
			{
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, divLineValueObj.tf._x, 0, divLineValueObj.tf._y, 0, 100, null, null, null);
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
	* drawVGrid method draws the vertical grid background color
	*/
	private function drawVGrid () : Void 
	{
		//If we're required to draw vertical grid color
		//and numDivLines > 3
		if (this.params.showAlternateVGridColor && this.divLines.length > 3)
		{
			//Movie clip container
			var gridMC : MovieClip;
			//Loop variable
			var i : Number;
			//Get depth
			var depth : Number = this.dm.getDepth ("VGRID");
			//X Position
			var xPos : Number, xPosEnd : Number;
			var width : Number;
			for (i = 1; i < this.divLines.length - 1; i = i + 2)
			{
				//Get x position
				xPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
				xPosEnd = this.getAxisPosition (this.divLines [i + 1].value, this.config.yMax, this.config.yMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
				width = Math.abs (xPos - xPosEnd);
				//Create the movie clip
				gridMC = this.cMC.createEmptyMovieClip ("GridBg_" + i, depth);
				//Set line style to null
				gridMC.lineStyle ();
				//Set fill color
				gridMC.moveTo ( - (width / 2) , - (this.elements.canvas.h / 2));
				gridMC.beginFill (parseInt (this.params.alternateVGridColor, 16) , this.params.alternateVGridAlpha);
				//Draw rectangle
				gridMC.lineTo (width / 2, - (this.elements.canvas.h / 2));
				gridMC.lineTo (width / 2, this.elements.canvas.h / 2);
				gridMC.lineTo ( - (width / 2) , this.elements.canvas.h / 2);
				gridMC.lineTo ( - (width / 2) , - (this.elements.canvas.h / 2));
				//End Fill
				gridMC.endFill ();
				//Place it in right location
				gridMC._x = xPos + (width / 2);
				gridMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (gridMC, this.objects.VGRID, this.macro, gridMC._x, 0, null, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (gridMC, this.objects.VGRID);
				//Increase depth
				depth ++;
			}
		}
		//Clear interval
		clearInterval (this.config.intervals.vGrid);
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
