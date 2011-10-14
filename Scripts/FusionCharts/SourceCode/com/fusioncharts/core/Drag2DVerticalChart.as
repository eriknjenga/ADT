/**
 * @class Drag2DVerticalChart
 * @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
 * @version 3.0
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006
 * Drag2DVerticalChart extends SingleYAxis2DVerticalChart class to encapsulate 
 * functionalities of a draggable single series 2D chart with a single VERTICAL axes. All such
 * charts extend this class.
*/
//Import parent class
import com.fusioncharts.core.SingleYAxis2DVerticalChart;
//Extensions
import com.fusioncharts.extensions.DrawingExt;
//Drop Shadow filter
import flash.filters.DropShadowFilter;
import flash.external.ExternalInterface;
//Delegate
import mx.utils.Delegate;
class com.fusioncharts.core.Drag2DVerticalChart extends SingleYAxis2DVerticalChart {
	//Instance variables
	//DivLines upper and lower limit Objects which hold the reference to textfields and style objects
	private var divLineUpperLimit:Object;
	private var divLineLowerLimit:Object;
	//Cursor MovieClip
	private var resizeHMC:MovieClip;
	/**
	 * Constructor function. We invoke the super class'
	 * constructor.
	*/
	function Drag2DVerticalChart(targetMC:MovieClip, depth:Number, width:Number, height:Number, x:Number, y:Number, debugMode:Boolean, lang:String, scaleMode:String, registerWithJS:Boolean, DOMId:String) {
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
		//Create a global config stack array for Enterframes and listeners
		this.config.stkEnterFrame = new Array();
		this.config.stkEnterFrameLength = 0;
		//Listeners
		this.config.stkListener = new Array();
		this.config.stkListenerLength = 0;
		if (this.registerWithJS==true){
			//Register the JS methods of the chart 
			ExternalInterface.addCallback("getXMLData", this, returnXML);
			ExternalInterface.addCallback("getData", this, returnArray);
			ExternalInterface.addCallback("getDataWithId", this, returnArrayWithID);
		}
	}
	/**
	 * getValue method gets the value from the particular 
	 * point on the axis.
	 *	@param	axisPos			Numerical axis position for which we need a particular Value
	 *	@param	upperLimit		Numerical upper limit for that axis
	 *	@param	lowerLimit		Numerical lower limit for that axis
	 *	@param	startAxisPos	Pixel start position for that axis
	 *	@param	endAxisPos		Pixel end position for that axis
	 *	@param	isYAxis			Flag indicating whether it's y axis
	 *	@param	xPadding		Padding at left and right sides in case of a x-axis
	 *	@returns				The pixel position of the value on the given axis.
	*/
	private function getValue(axisPos:Number, upperLimit:Number, lowerLimit:Number, startAxisPos:Number, endAxisPos:Number, isYAxis:Boolean, xPadding:Number):Number {
		//Define variables to be used locally
		var numericalInterval:Number;
		var positionInterval:Number;
		var value:Number;
		//Get the numerical difference between the limits
		numericalInterval = (upperLimit-lowerLimit);
		if (isYAxis) {
			//If it's y axis, the co-ordinates are opposite in Flash
			positionInterval = (endAxisPos-startAxisPos);
			value = (numericalInterval/positionInterval)*(endAxisPos-axisPos)+lowerLimit;
		} else {
			positionInterval = (endAxisPos-startAxisPos)-(2*xPadding);
			value = ((numericalInterval/positionInterval)*(axisPos-startAxisPos-xPadding))+lowerLimit;
		}
		if (value<lowerLimit) {
			value = lowerLimit;
		}
		if (value>upperLimit) {
			value = upperLimit;
		}
		return value;
	}
	/**
	 * drawAxisLimitsTF method draws the input textfield for the limits on the chart
	 * we defined this method here because we need to handle the limits for axis change.
	 *	@param	tfObject	text field Object which holds which axis has been changed and the textfield reference
	 *	@param	x		X Axis position of the limits
	 *	@param	y		Y Axis position of the limits
	 *	@param	width	width of the limit text field
	 *	@param	height	height of the limit text field
	*/
	private function drawAxisLimitsTF(tfObject:Object, x:Number, y:Number, width:Number, height:Number):Void {
		//Local variable accessible inside onEnterFrame of cursor
		var chartMC:MovieClip = this.cMC;
		//Local Variable accessible inside onRelease
		var lTf:TextField = tfObject.tf;
		//Local variable to refer class
		var chartRef:Object = this;
		lTf._kl = new Object();
		lTf.enterPressed = false;
		//Now if enter key is pressed - we update the chart based on the values 
		//of the editable text field
		lTf._kl.onKeyDown = function() {
			//if the enter key is pressed
			if (Key.isDown(Key.ENTER)) {
				//We set the flag - so that we can check while updating the axis
				// and we do not update for any garbage events generated because of on pressed event
				lTf.enterPressed = true;
				//Remove the key listener
				Key.removeListener(this);
				//Finally update the axis
				chartRef.updateAxis(lTf.text, tfObject.flagUpper);
			}
		};
		//We define the listener once the editable text field is gained focus
		lTf.onSetFocus = function(oldFocus:Object) {
			//Set the properties for the editable textfield
			if(tfObject.flagUpper) {
				//Restrict the input values to only numeric numbers
				this.restrict = "[0-9].";
			}
			else {
				//Restrict the input values to only numeric numbers
				this.restrict = "[0-9].\\-";
			}
			this.type = "input";
			this.border = true;
			this.borderColor = 0xA9C5EB;
			this.tabEnabled = false;
			//We get the text format of the textfield and unformat the limit value
			//so that we get a plain numbers for editing purpose
			var tfFormat:TextFormat = this.getTextFormat(0, this.text.length);
			//Set the initial value
			if (tfObject.flagUpper) {
				//Set the upper limit plain number as the text
				this.text = chartRef.config.yMax;
			} else {
				//Set the lower limit plain number as the text
				this.text = chartRef.config.yMin;
			}
			//Finally, we set the user defined properties to the text box
			this.setTextFormat(tfFormat);
			//Remove the enter key listener - if there is any previously stacked up
			Key.removeListener(this._kl);
			// just in case it didn't remove it before due to some error
			Key.addListener(this._kl);
		};
		//If the focus is lost then we do not update the chart
		// Chart is changed only when the user press the enter key
		lTf.onKillFocus = function(newFocus:Object) {
			if (!this.enterPressed) {
				//Set the input text field border to false - as now we need a label
				this.border = false;
				//Finally update the axis
				chartRef.updateAxis(this.text, tfObject.flagUpper);
			}
			//Remove the listeners          
			Key.removeListener(this._kl);
			//unset the flag
			this.enterPressed = false;
		};
	}
	/**
	 *	Forward Declaration, so that the child class can overwrite it.
	 *  this method just enable us to compile this child class as we 
	 *  need the parent's method defined in the parent class
	 */
	private function updateULAxis():Boolean {
		return false;
	}
	/**
	 *	Forward Declaration, so that the child class can overwrite it.
	 *  this method just enable us to compile this child class as we 
	 *  need the parent's method defined in the parent class
	 */
	private function returnArray():Array {
		return new Array();
	}
	/**
	 *	Forward Declaration, so that the child class can overwrite it.
	 *  this method just enable us to compile this child class as we 
	 *  need the parent's method defined in the parent class
	 */
	private function returnArrayWithID():Array {
		return new Array();
	}
	/**
	 *	Forward Declaration, so that the child class can overwrite it.
	 *  this method just enable us to compile this child class as we 
	 *  need the parent's method defined in the parent class
	 */
	private function returnXML():String {
		return "";
	}
	/**
	 *	Forward Declaration, so that the child class can overwrite it.
	 *  this method just enable us to compile this child class as we 
	 *  need the parent's method defined in the parent class
	 */
	private function updateLLAxis():Boolean {
		return false;
	}
	/**
	 *	updateAxis method handles when the axis new value has been entered
	 *	@param	label		label is the new value entered in the editable text field
	 *	@param	flagUpper	flag to indicate which limit has been handled (lower or upper)
	 */
	private function updateAxis(label:String, flagUpper:Boolean):Void {
		//Text format of the upper limit
		var tfFormat:TextFormat;
		//Flag
		var errorFlag:Boolean = false;
		//Display value
		var displayValue:String;
		//Change the label to its equivalent number
		var num:Number = Number(label);
		//Check whether its a proper number to be set as limit
		if (isNaN(num)) {
			errorFlag = true;
		}
		//Now, set the above number to display format - using format options
		if (this.config.formatDivDecimals && !errorFlag) {
			//Round off the div line value to this.params.yAxisValueDecimals precision
			displayValue = this.formatNumber(num, this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
		} else {
			if (this.config.numberScaleDefined) {
				//If number scale is defined, we round the numbers
				//Round off the div line value to this.params.decimals precision
				displayValue = this.formatNumber(num, this.params.formatNumber, this.params.decimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
			} else {
				//Set decimal places as 10, so that none of the decimals get stripped off
				displayValue = this.formatNumber(num, this.params.formatNumber, 10, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
			}
		}
		if (!errorFlag) {
			if ((num!= this.config.yMax && flagUpper) || (num != this.config.yMin && !flagUpper)) {
				//Update the axis limit based on which limit has been modified
				if (flagUpper) {
					//Update the Upper Axis and check for any error
					errorFlag = this.updateULAxis(3, num);
				} else {
					//Update the Lower Axis and check for any error
					errorFlag = this.updateLLAxis(3, num);
				}
			}
		}
		//If no error found and the Upper limit is modified then update the upper limit label     
		if (!errorFlag && flagUpper) {
			//Text format of the dragged column
			tfFormat = this.divLineUpperLimit.tf.getTextFormat(0, this.divLineUpperLimit.tf.text.length);
			//Set the limit display value in the editable text field
			this.divLineUpperLimit.tf.text = displayValue;
			//Set the user defined properties to the text box
			this.divLineUpperLimit.tf.setTextFormat(tfFormat);
		} else if (!errorFlag && !flagUpper) {
			//If no error found and the Lower limit is modified then update the lower limit label
			//Text format of the dragged column
			tfFormat = this.divLineLowerLimit.tf.getTextFormat(0, this.divLineLowerLimit.tf.text.length);
			//Set the limit display value in the editable text field
			this.divLineLowerLimit.tf.text = displayValue;
			//Set the user defined properties to the text box
			this.divLineLowerLimit.tf.setTextFormat(tfFormat);
		}
		//If error found - then we set back the limits to its previously stored value
		if (errorFlag) {
			if (flagUpper) {
				label = this.config.yMax;
			} else {
				label = this.config.yMin;
			}
			//Now, if numbers are to be restricted to decimal places,
			if (this.config.formatDivDecimals) {
				//Round off the div line value to this.params.yAxisValueDecimals precision
				displayValue = this.formatNumber(Number(label), this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
			} else {
				if (this.config.numberScaleDefined) {
					//If number scale is defined, we round the numbers
					//Round off the div line value to this.params.decimals precision
					displayValue = this.formatNumber(Number(label), this.params.formatNumber, this.params.decimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
				} else {
					//Set decimal places as 5, so that none of the decimals get stripped off
					displayValue = this.formatNumber(Number(label), this.params.formatNumber, 5, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
				}
			}
			//If the upper limit axis has to be updated 
			if (flagUpper) {
				//Text format of the dragged column
				tfFormat = this.divLineUpperLimit.tf.getTextFormat(0, this.divLineUpperLimit.tf.text.length);
				//Set the limit display value in the editable text field
				this.divLineUpperLimit.tf.text = displayValue;
				//Set the user defined properties to the text box
				this.divLineUpperLimit.tf.setTextFormat(tfFormat);
				this.divLineUpperLimit.tf.border = false;
			} else if (!flagUpper) {
				//If no error found and the Lower limit is modified then update the lower limit label
				//Text format of the dragged column
				tfFormat = this.divLineLowerLimit.tf.getTextFormat(0, this.divLineLowerLimit.tf.text.length);
				//Set the limit display value in the editable text field
				this.divLineLowerLimit.tf.text = displayValue;
				//Set the user defined properties to the text box
				this.divLineLowerLimit.tf.setTextFormat(tfFormat);
				this.divLineLowerLimit.tf.border = false;
			}
		}
	}
	/**
	 * drawDivLines method draws the div lines on the chart
	 * we defined this method here because we need to handle the limits for axis change
	*/
	private function drawDivLines():Void {
		var divLineValueObj:Object;
		var divLineFontObj:Object;
		var yPos:Number;
		var depth:Number = this.dm.getDepth("DIVLINES")-1;
		//Movie clip container
		var divLineMC:MovieClip;
		//Get div line font
		divLineFontObj = this.styleM.getTextStyle(this.objects.YAXISVALUES);
		//Set alignment
		divLineFontObj.align = "right";
		divLineFontObj.vAlign = "middle";
		//Iterate through all the div line values
		var i:Number;
		for (i=0; i<=this.params.numDivLines+1; i++) {
			//If it's the first or last div Line (limits), and limits are to be shown
			if ((i == 0) || (i == this.params.numDivLines+1)) {
				if (this.params.showLimits && this.divLines[i].showValue) {
					//Increase the depth
					depth++;
					//Get y position for textbox
					yPos = this.getAxisPosition(this.divLines[i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Create the limits text
					// store the upper and lower limit text field objects
					if (i == 0) {
						//Only if the axis change is set - we draw the editable text 						
						if (this.params.allowAxisChange) {
							delete this.divLineLowerLimit;
							this.divLineLowerLimit.removeTextField();
							this.divLineLowerLimit = divLineValueObj=createText(false, this.divLines[i].displayValue, this.cMC, depth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
							//Draw the hidden rectangle
							this.divLineLowerLimit.flagUpper = false;
							this.divLineLowerLimit.tf.selectable = true;
							this.divLineLowerLimit.tf.type = "input";
							this.drawAxisLimitsTF(this.divLineLowerLimit, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos+8, divLineValueObj.width, divLineValueObj.height);
						} else {
							this.divLineLowerLimit = divLineValueObj=createText(false, this.divLines[i].displayValue, this.cMC, depth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
						}
					} else if (i == this.params.numDivLines+1) {
						//Only if the axis change is set - we draw the editable text 
						if (this.params.allowAxisChange) {
							delete this.divLineUpperLimit;
							this.divLineUpperLimit.removeTextField();
							this.divLineUpperLimit = divLineValueObj = createText(false, this.divLines[i].displayValue, this.cMC, depth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
							this.divLineUpperLimit.tf.selectable = true;
							this.divLineUpperLimit.tf.type = "input";
							//Draw the hidden rectangle
							this.divLineUpperLimit.flagUpper = true;
							this.drawAxisLimitsTF(this.divLineUpperLimit, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos+8, divLineValueObj.width, divLineValueObj.height);
						} else {
							this.divLineUpperLimit = divLineValueObj = createText(false, this.divLines[i].displayValue, this.cMC, depth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
						}
					}
				}
			} else if (this.divLines[i].value == 0) {
				//It's a zero value div line - check if we've to show
				if (this.params.showZeroPlane) {
					//Depth for zero plane
					var zpDepth:Number = this.dm.getDepth("ZEROPLANE");
					//Depth for zero plane value
					var zpVDepth:Number = zpDepth++;
					//Get y position
					yPos = this.getAxisPosition(0, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Render the line
					var zeroPlaneMC = this.cMC.createEmptyMovieClip("ZeroPlane", zpDepth);
					//Draw the line
					zeroPlaneMC.lineStyle(this.params.zeroPlaneThickness, parseInt(this.params.zeroPlaneColor, 16), this.params.zeroPlaneAlpha);
					if (this.params.divLineIsDashed) {
						//Dashed line
						DrawingExt.dashTo(zeroPlaneMC, -this.elements.canvas.w/2, 0, this.elements.canvas.w/2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
					} else {
						//Draw the line keeping 0,0 as registration point
						zeroPlaneMC.moveTo(-this.elements.canvas.w/2, 0);
						//Normal line
						zeroPlaneMC.lineTo(this.elements.canvas.w/2, 0);
					}
					//Re-position the div line to required place
					zeroPlaneMC._x = this.elements.canvas.x+this.elements.canvas.w/2;
					zeroPlaneMC._y = yPos-(this.params.zeroPlaneThickness/2);
					//Apply animation and filter effects to div line
					//Apply animation
					if (this.params.animation) {
						this.styleM.applyAnimation(zeroPlaneMC, this.objects.DIVLINES, this.macro, null, 0, zeroPlaneMC._y, 0, 100, 100, null, null);
					}
					//Apply filters                                                                                                                         
					this.styleM.applyFilters(zeroPlaneMC, this.objects.DIVLINES);
					//So, check if we've to show div line values
					if (this.params.showDivLineValues && this.divLines[i].showValue) {
						//Create the text
						divLineValueObj = createText(false, this.divLines[i].displayValue, this.cMC, zpVDepth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
					}
					//Apply animation and filter effects to div line (y-axis) values                                       
					if (this.divLines[i].showValue) {
						if (this.params.animation) {
							this.styleM.applyAnimation(divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x-this.params.yAxisValuesPadding-divLineValueObj.width, 0, yPos-(divLineValueObj.height/2), 0, 100, null, null, null);
						}
						//Apply filters                                                                                                                         
						this.styleM.applyFilters(divLineValueObj.tf, this.objects.YAXISVALUES);
					}
				}
			} else {
				//It's a div interval - div line
				//Get y position
				yPos = this.getAxisPosition(this.divLines[i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//Render the line
				depth++;
				divLineMC = this.cMC.createEmptyMovieClip("DivLine_"+i, depth);
				//Draw the line
				divLineMC.lineStyle(this.params.divLineThickness, parseInt(this.params.divLineColor, 16), this.params.divLineAlpha);
				if (this.params.divLineIsDashed) {
					//Dashed line
					DrawingExt.dashTo(divLineMC, -this.elements.canvas.w/2, 0, this.elements.canvas.w/2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
				} else {
					//Draw the line keeping 0,0 as registration point
					divLineMC.moveTo(-this.elements.canvas.w/2, 0);
					//Normal line
					divLineMC.lineTo(this.elements.canvas.w/2, 0);
				}
				//Re-position the div line to required place
				divLineMC._x = this.elements.canvas.x+this.elements.canvas.w/2;
				divLineMC._y = yPos-(this.params.divLineThickness/2);
				//Apply animation and filter effects to div line
				//Apply animation
				if (this.params.animation) {
					this.styleM.applyAnimation(divLineMC, this.objects.DIVLINES, this.macro, null, 0, divLineMC._y, 0, 100, 100, null, null);
				}
				//Apply filters                                                                                                                         
				this.styleM.applyFilters(divLineMC, this.objects.DIVLINES);
				//So, check if we've to show div line values
				if (this.params.showDivLineValues && this.divLines[i].showValue) {
					//Increase Depth
					depth++;
					//Create the text
					divLineValueObj = createText(false, this.divLines[i].displayValue, this.cMC, depth, this.elements.canvas.x-this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines[i].showValue) {
				if (this.params.animation) {
					this.styleM.applyAnimation(divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x-this.params.yAxisValuesPadding-divLineValueObj.width, 0, yPos-(divLineValueObj.height/2), 0, 100, null, null, null);
				}
				//Apply filters                                                                                                                         
				this.styleM.applyFilters(divLineValueObj.tf, this.objects.YAXISVALUES);
			}
		}
		delete divLineValueObj;
		delete divLineFontObj;
		//Clear interval
		clearInterval(this.config.intervals.divLines);
	}
	/**
	 * getULErrorMessage method returns the error message to display in Dialog box
	 */
	public function getULErrorMessage():String {
		return "Sorry! Not enough range gap to decrease axis upper limit.<BR> If you want to decrease it further, please decrease data values.";
	}
	/**
	 * getLLErrorMessage method returns the error message to display in Dialog box
	 */
	public function getLLErrorMessage():String {
		return "Sorry! Not enough range gap to increase axis lower limit.<BR> If you want to increase it further, please increase data values.";
	}
	/** 
	* drawResizeHandler method draws a resize handler
	*/
	public function drawResizeHandler():Void {
		//Get the cursor depth
		var depth:Number = this.dm.getDepth("RESIZEHANDLER");
		//Create an empty movie clip
		this.resizeHMC = this.cMC.createEmptyMovieClip("resizeHandler", depth);
		//Begin fill
		this.resizeHMC.beginFill(parseInt("000000", 16), 100);
		//Draw the cursor
		this.resizeHMC.moveTo(-1, 4);
		this.resizeHMC.lineTo(-1, -4);
		this.resizeHMC.lineTo(-3.5, -4);
		this.resizeHMC.lineTo(0, -6);
		this.resizeHMC.lineTo(3.5, -4);
		this.resizeHMC.lineTo(1, -4);
		this.resizeHMC.lineTo(1, 4);
		this.resizeHMC.lineTo(3.5, 4);
		this.resizeHMC.lineTo(0, 6);
		this.resizeHMC.lineTo(-3.5, 4);
		this.resizeHMC.lineTo(-1, 4);
		this.resizeHMC.endFill();
		var shadowFilter:DropShadowFilter = new DropShadowFilter(3, 45, 0x999999, 0.8, 4, 4, 1, 1, false, false, false);
		this.resizeHMC.filters = [shadowFilter];
		//Hide the cursor initially
		this.resizeHMC._visible = false;
		//Store the movie clip in config
		this.config.resizeHMC = this.resizeHMC;
	}
	/**
	 * addToEnterFrameStk method adds an object to stack. These Objects are one which 
	 * needs to be deleted from memory  for efficiency purpose.
	 *	@param	obj		Object which needs to be added to stack list
	*/
	public function addToEnterFrameStk(obj:Object):Boolean {
		var presentInArr:Boolean = false;
		//Add only if it is not present
		for (var i:Number = 0; i<this.config.stkEnterFrameLength; i++) {
			if (this.config.stkEnterFrame[i] == obj) {
				presentInArr = true;
				break;
			}
		}
		if (!presentInArr) {
			this.config.stkEnterFrame.push(obj);
			this.config.stkEnterFrameLength++;
		}
		return (!presentInArr);
	}
	/**
	 * deleteFromEnterFrameStk method deletes the topmost object from array
	*/
	public function deleteFromEnterFrameStk():Object {
		return this.config.stkEnterFrame.pop();
	}
	/**
	 * addToListenerStk method adds listeners to stack. These listeners have to  
	 * be deleted from memory  for efficiency purpose.
	 *	@param	obj		Object which needs to be added to stack list
	 *	@param	type	type of event
	 *	@param	lHandler	listener reference which needs to be removed
	*/
	public function addToListenerStk(obj:Object, type:String, lHandler:Object):Void {
		//Add it to stack
		//We store all the properties of the listener - so as to make sure we remove the 
		// specific listner and not unnecessary listeners
		this.config.stkListener[this.config.stkListenerLength++] = new Object();
		this.config.stkListener[this.config.stkListenerLength-1].obj = obj;
		this.config.stkListener[this.config.stkListenerLength-1].lType = type;
		this.config.stkListener[this.config.stkListenerLength-1].lHandler = lHandler;
	}
	/**
	 * reInit method re-initializes the chart. This method is basically called
	 * when the user changes chart data through JavaScript. In that case, we need
	 * to re-initialize the chart, set new XML data and again render.
	*/
	public function reInit():Void {
		//Invoke super class's reInit
		super.reInit();
		var movieRef:Object;
		while (this.config.stkEnterFrameLength>0) {
			movieRef = this.deleteFromEnterFrameStk();
			//Only if the movie clip exists
			if (movieRef._name != "") {
				//delete the movie clip from memory
				delete movieRef.onEnterFrame;
				//Reduce the stack length for enter frame list
				this.config.stkEnterFrameLength--;
			}
		}
		//Remove all the listeners
		while (this.config.stkListenerLength>0) {
			//Remove the required listener
			this.config.stkListener[this.config.stkListenerLength].obj.removeEventListener(this.config.stkListener[this.config.stkListenerLength].lType, this.config.stkListener[this.config.stkListenerLength].lHandler);
			//Reduce the listener stack length
			this.config.stkListenerLength--;
		}
		//Reinitialize the array and set length to 0
		this.config.stkEnterFrame = new Array();
		this.config.stkEnterFrameLength = 0;
		this.config.stkListener = new Array();
		this.config.stkListenerLength = 0;
	}
}
