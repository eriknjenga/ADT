// Import the Delegate class
import mx.utils.Delegate;
// Import the MathExt class
import com.fusioncharts.extensions.MathExt;
// Import the ColorExt class
import com.fusioncharts.extensions.ColorExt;
// Import the Doughnut2DChart class (to fix a flash issue)
import com.fusioncharts.core.charts.Doughnut2DChart;
/**
 * @class 		Doughnut2D
 * @version		1.0
 * @author		InfoSoft Global (P) Ltd.
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2006
 
 * Doughnut2D class is responsible of creating a 2D pie slice.
 * The pie slice is drawn on its instantiation with passing
 * of parameters. Each instance is passed a (common) object
 * with a host of properties in them, the movieclip 
 * reference in which to draw the pie.
 */
class com.fusioncharts.core.chartobjects.Doughnut2D {
	// stores the reference of the basic 2D pie chart class (stored but not yet used)
	private var chartClass;
	// stores the object, with a host of properties, passed as parameter during instantiation of this class
	private var objData:Object;
	// stores the reference of the movieclip constituting the whole pie slice
	private var mcMain:MovieClip;
	// strores the reference of MathExt.toNearestTwip()
	private var toNT:Function;
	//
	/**
	 * Constructor function for the class. Calls the primary 
	 * drawPie method.
	 * @param	chartClassRef	Name of class instance instantiating this.
	 * @param	mcPie			A movie clip reference passed from the
	 *							main movie. This movie clip is the clip
	 *							inside which we'll draw the 2D Pie
	 *							slice. Has to be necessarily provided.
	 * @param	obj				Object with various properties necessary
	 *							for drawing pie slices. 
	 */
	public function Doughnut2D(chartClassRef, mcPie:MovieClip, obj:Object) {
		// stores the referene of the basic class for creating a 2D pie chart 
		chartClass = chartClassRef;
		// stores the reference of the movieclip inside which all rendering either pie or label or both, 
		// for this pie, need to be done.
		mcMain = mcPie;
		// stores the object, with a host of properties
		objData = obj;
		// storing the refernce of MathExt.toNearestTwip()
		toNT = MathExt.toNearestTwip;
		// drawing of the pie slice is initialised 
		drawPie();
	}
	/**
	 * drawPie method is called from constructor function.
	 * It works to generate a pie slice as an 'object'.
	 * It calls drawFace and/or drawLabel method as per
	 * requirement.
	 */
	private function drawPie():Void {
		var a:Array = objData.arrFinal;
		//----------------------------------------------
		// movieclip reference stored in local variable
		var mcPieCanvas:MovieClip = mcMain;
		// inverting the movieclip vertically ... this removes conflict in convention of co-ordinate axes between
		// flash and traditional coordinate geometry ... applicable for this movieclip and its sub-movies ... done
		// only for the sake of simplifying the visualization process
		mcPieCanvas._yscale = -100;
		// shifts the origin of coordinate axes to the lower left corner of the root movieclip ... this completes 
		// the above mentioned attempt
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		if (objData.isPlotAnimationOver || objData.isInitialised) {
			mcPieCanvas._x = 0;
			mcPieCanvas._y = objData.chartHeight;
		} else {
			mcPieCanvas._x = objData.centerX;
			mcPieCanvas._y = objData.centerY;
		}
		// stores the collection of properties in the pie movieclip itsef for further use
		mcPieCanvas.store = a;
		// movement status for the pie when drawn is flagged initially (centered in)
		if (objData.isInitialised) {
			mcPieCanvas.isSlicedIn = (a['isSliced']) ? false : true;
		} else {
			mcPieCanvas.isSlicedIn = true;
		}
		var insRef:Doughnut2D = this;
		// objData.isPieHolder == true - to restrict call of movePie() for one of the two
		// constituting each pie. movePie() call for the other one is from this call ... see movePie() for details.
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		if (a['isSliced'] && !objData.isInitialised && objData.isPlotAnimationOver && objData.isPieHolder) {
			mcPieCanvas.onEnterFrame = function() {
				insRef.movePie();
				delete this.onEnterFrame;
			};
		}
		// if not rotatable and not yet initialised  and its not a singleton case      
		if (!(objData.isRotatable || objData.isInitialised) && objData.isPieHolder != null) {
			mcPieCanvas.enabled = false;
		}
		//-------------------------------------                                     
		// if this pie2D instance is to create the pie graphic OR singleton case
		if (objData.isPieHolder || objData.isPieHolder == null) {
			drawFace();
		}
		//                                                                                               
		if (!mcPieCanvas.isSlicedIn) {
			mcPieCanvas.isMoved = true;
		}
		// if labelProps is defined and this Doughnut2D instance is for rendering labels OR singleton case                          
		if ((a['labelProps'] && !objData.isPieHolder) || objData.isPieHolder == null) {
			drawLabel();
		}
	}
	/**
	 * drawFace method is called from drawPie
	 * method. It draws fills and border of pie.
	 */
	private function drawFace():Void {
		var mcCanvas:MovieClip = mcMain.createEmptyMovieClip('mcFace', 1);
		var a:Array = objData.arrFinal;
		var radius:Number = objData.radius;
		var innerRadius:Number = objData.innerRadius;
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		if (objData.isPlotAnimationOver || objData.isInitialised) {
			var xcenter:Number = objData.centerX;
			var ycenter:Number = objData.centerY;
		} else {
			var xcenter:Number = 0;
			var ycenter:Number = 0;
		}
		var borderThickness:Number = objData.borderThickness;
		var borderColor:Number = a['borderColor'];
		var fillAlpha:Number = a['fillAlpha'];
		var borderAlpha:Number = (a.isDashed) ? 0 : a['borderAlpha'];
		// for singleton chart, border of start and end faces coincide and should be of zero opacity
		var endBorderAlpha:Number = (a['sweepAngle'] == 360) ? 0 : borderAlpha;
		var xcontrol:Number, ycontrol:Number, xend:Number, yend:Number;
		// setting values from store in Doughnut2D instance                    
		var steps:Number = a['no45degCurves'];
		var xtra:Number = a['remainderAngle'];
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		var startAng:Number = (objData.isPlotAnimationOver || objData.isInitialised) ? a['startAngle'] : -MathExt.toRadians(a['sweepAngle'])/2;
		var endAng:Number = (objData.isPlotAnimationOver || objData.isInitialised) ? MathExt.toRadians(a['endAngle']) : MathExt.toRadians(a['sweepAngle'])/2;
		//
		if (objData.gradientFill) {
			// central radial gradient applied
			var strFillType:String = 'radial';
			var shadowIntensity:Number = Math.floor((0.85-0.2*(1-objData.gradientRadius/255))*100)/100;
			var shadowColor:Number = ColorExt.getDarkColor(a['pieColor'].toString(16), shadowIntensity);
			var highLightIntensity:Number = Math.floor((1-0.5*objData.gradientRadius/255)*100)/100;
			var highLight:Number = ColorExt.getLightColor(a['pieColor'].toString(16), highLightIntensity);
			var arrColors:Array = [shadowColor, highLight, highLight, shadowColor];
			var arrAlphas:Array = [fillAlpha, fillAlpha, fillAlpha, fillAlpha];
			// the ratio in 255 scale corresponding to the inner periphery
			var ratio1:Number = Math.round(innerRadius*255/radius)-5;
			ratio1 = (ratio1<0) ? 0 : ratio1;
			// The gradient is applied as if 2 seperate gradients applied equally about the mid-radius of the doughnut.
			// the ratio value in (255-ratio1) scale
			var ratioAdjust:Number = Math.round(((255-ratio1)/2)*objData.gradientRadius/255);
			// ratio adjusted for highlight from the inner periphery
			var ratio2:Number = ratio1+ratioAdjust;
			// ratio adjusted for highlight from the outer periphery
			var ratio3:Number = 255-ratioAdjust;
			var arrRatios:Array = [ratio1, ratio2, ratio3, 255];
			//
			var xGrad:Number = xcenter-radius;
			var yGrad:Number = ycenter-radius;
			var widthGrad:Number = 2*radius;
			var heightGrad:Number = 2*radius;
			//
			var objMatrix:Object = {matrixType:"box", x:xGrad, y:yGrad, w:widthGrad, h:heightGrad, r:0};
			mcCanvas.beginGradientFill(strFillType, arrColors, arrAlphas, arrRatios, objMatrix);
		} else {
			mcCanvas.beginFill(a['pieColor'], fillAlpha);
		}
		//---------------------------------------------------------//
		var xstart:Number = toNT(xcenter+radius*Math.cos(startAng));
		var ystart:Number = toNT(ycenter+radius*Math.sin(startAng));
		var xInStart:Number = toNT(xcenter+innerRadius*Math.cos(startAng));
		var yInStart:Number = toNT(ycenter+innerRadius*Math.sin(startAng));
		mcCanvas.moveTo(xInStart, yInStart);
		mcCanvas.lineStyle(borderThickness, borderColor, endBorderAlpha, true, "normal", "round", "round");
		mcCanvas.lineTo(xstart, ystart);
		mcCanvas.lineStyle(borderThickness, borderColor, borderAlpha, true, "normal", "round", "round");
		//------------------ drawing outer curve -------------------//
		// drawing 45 degree curves
		for (var j:Number = 1; j<=steps; ++j) {
			// 
			var t:Number = startAng+(Math.PI/4)*j;
			// 
			xend = toNT(xcenter+radius*Math.cos(t));
			yend = toNT(ycenter+radius*Math.sin(t));
			// 
			xcontrol = toNT(xcenter+radius*Math.cos((2*(startAng+(Math.PI/4)*(j-1))+(Math.PI/4))/2)/Math.cos((Math.PI/4)/2));
			ycontrol = toNT(ycenter+radius*Math.sin((2*(startAng+(Math.PI/4)*(j-1))+(Math.PI/4))/2)/Math.cos((Math.PI/4)/2));
			// 
			mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		}
		// drawing remainder curve
		var s:Number = startAng+(Math.PI/4)*steps+xtra;
		xend = toNT(xcenter+radius*Math.cos(s));
		yend = toNT(ycenter+radius*Math.sin(s));
		var xInEnd:Number = toNT(xcenter+innerRadius*Math.cos(s));
		var yInEnd:Number = toNT(ycenter+innerRadius*Math.sin(s));
		xcontrol = toNT(xcenter+radius*Math.cos((2*(startAng+(Math.PI/4)*steps)+xtra)/2)/Math.cos(xtra/2));
		ycontrol = toNT(ycenter+radius*Math.sin((2*(startAng+(Math.PI/4)*steps)+xtra)/2)/Math.cos(xtra/2));
		//
		mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		//
		mcCanvas.lineStyle(borderThickness, borderColor, endBorderAlpha, true, "normal", "round", "round");
		mcCanvas.lineTo(xInEnd, yInEnd);
		//------------------ drawing inner curve -------------------//
		// drawing 45 degree curves
		for (var j:Number = 1; j<=steps; ++j) {
			// 
			var t:Number = endAng-(Math.PI/4)*j;
			// 
			xend = toNT(xcenter+innerRadius*Math.cos(t));
			yend = toNT(ycenter+innerRadius*Math.sin(t));
			// 
			xcontrol = toNT(xcenter+innerRadius*Math.cos((2*(endAng-(Math.PI/4)*(j-1))-(Math.PI/4))/2)/Math.cos((Math.PI/4)/2));
			ycontrol = toNT(ycenter+innerRadius*Math.sin((2*(endAng-(Math.PI/4)*(j-1))-(Math.PI/4))/2)/Math.cos((Math.PI/4)/2));
			// 
			mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		}
		// drawing remainder curve
		var s:Number = endAng-(Math.PI/4)*steps-xtra;
		xcontrol = toNT(xcenter+innerRadius*Math.cos((2*(endAng-(Math.PI/4)*steps)-xtra)/2)/Math.cos(xtra/2));
		ycontrol = toNT(ycenter+innerRadius*Math.sin((2*(endAng-(Math.PI/4)*steps)-xtra)/2)/Math.cos(xtra/2));
		//
		mcCanvas.curveTo(xcontrol, ycontrol, xInStart, yInStart);
		//-----------------------------------------------------------//
		mcCanvas.endFill();
		// call to draw the dashed border, if applicable for this pie
		if (a.isDashed) {
			drawDashedBorder(mcCanvas);
		}
	}
	/**
	 * drawDashedBorder method is called to draw dashed border
	 * holding movieclips.
	 * @param	_mc		reference of the mc to draw in
	 */
	private function drawDashedBorder(_mc:MovieClip):Void {
		var a:Array = objData.arrFinal;
		var radius:Number = objData.radius;
		var innerRadius:Number = objData.innerRadius;
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		if (objData.isPlotAnimationOver || objData.isInitialised) {
			var xcenter:Number = objData.centerX;
			var ycenter:Number = objData.centerY;
		} else {
			var xcenter:Number = 0;
			var ycenter:Number = 0;
		}
		//
		var borderThickness:Number = objData.borderThickness;
		var borderColor:Number = a['borderColor'];
		var borderAlpha:Number = a['borderAlpha'];
		var endBorderAlpha:Number = (a['sweepAngle'] == 360) ? 0 : borderAlpha;
		//
		// isPlotAnimationOver - for rotational animation ..... isInitialised - for no animation at all
		var startAng:Number = (objData.isPlotAnimationOver || objData.isInitialised) ? a['startAngle'] : -MathExt.toRadians(a['sweepAngle'])/2;
		var endAng:Number = (objData.isPlotAnimationOver || objData.isInitialised) ? MathExt.toRadians(a['endAngle']) : MathExt.toRadians(a['sweepAngle'])/2;
		var sweepAng:Number = a['sweepAngle'];
		//-------------- C A L C U L A T E --------------//
		var dashCurveLength:Number = 5;
		//------------------- outer curve ---------------
		var outerDashAng:Number = MathExt.toDegrees(dashCurveLength/radius);
		var loops:Number = Math.round(sweepAng/outerDashAng);
		if (a['sweepAngle'] != 360) {
			// need odd value of 'loops' so that curve both, starts and ends, with dashes 
			loops = (Math.floor(loops/2) == loops/2) ? loops+1 : loops;
		} else {
			// need even value of 'loops' so that curve starts with dash but ends with blank space
			loops = (Math.floor(loops/2) == loops/2) ? loops : loops+1;
		}
		// recalculating outerDashAng and approximating for optimization
		outerDashAng = MathExt.toRadians(MathExt.toNearestTwip(sweepAng/loops));
		//----------------- inner curve ----------------
		var innerDashAng:Number = MathExt.toDegrees(dashCurveLength/innerRadius);
		var loops1:Number = Math.round(sweepAng/innerDashAng);
		if (a['sweepAngle'] != 360) {
			// need odd value of 'loops1' so that curve both, starts and ends, with dashes 
			loops1 = (Math.floor(loops1/2) == loops1/2) ? loops1+1 : loops1;
		} else {
			// need even value of 'loops1' so that curve starts with dash but ends with blank space
			loops1 = (Math.floor(loops1/2) == loops1/2) ? loops1 : loops1+1;
		}
		// recalculating innerDashAng and approximating for optimization
		innerDashAng = MathExt.toRadians(MathExt.toNearestTwip(sweepAng/loops1));
		//------------------------------------------
		var loopsLine:Number = Math.floor((radius-innerRadius)/dashCurveLength);
		// need odd value of 'loops'
		loopsLine = (Math.floor(loopsLine/2) == loopsLine/2) ? loopsLine+1 : loopsLine;
		var dx:Number = MathExt.toNearestTwip((radius-innerRadius)/loopsLine);
		//--------------- FUNCTION ------------------//
		// rounding off upto 2 significant digits after decimal point
		var roundOff:Function = function (num:Number):Number {
			return Math.floor(num*100)/100;
		};
		//---------------  D R A W  -----------------//
		var mcCanvas:MovieClip = _mc.createEmptyMovieClip('mcDashBorder', _mc.getNextHighestDepth());
		//
		var xInStart:Number = toNT(xcenter+innerRadius*Math.cos(startAng));
		var yInStart:Number = toNT(ycenter+innerRadius*Math.sin(startAng));
		var xInEnd:Number = toNT(xcenter+innerRadius*Math.cos(endAng));
		var yInEnd:Number = toNT(ycenter+innerRadius*Math.sin(endAng));
		//
		mcCanvas.moveTo(xInStart, yInStart);
		// dashed line along starting angle is drawn
		for (var i:Number = 1; i<=loopsLine; ++i) {
			var alpha:Number = (Math.floor(i/2) == i/2) ? 0 : endBorderAlpha;
			mcCanvas.lineStyle(borderThickness, borderColor, alpha);
			//
			var endX:Number = roundOff(xInStart+i*dx*Math.cos(startAng));
			var endY:Number = roundOff(yInStart+i*dx*Math.sin(startAng));
			//
			mcCanvas.lineTo(endX, endY);
		}
		// outer dashed curve part is drawn
		for (var i:Number = 1; i<=loops; ++i) {
			var alpha:Number = (Math.floor(i/2) == i/2) ? 0 : borderAlpha;
			mcCanvas.lineStyle(borderThickness, borderColor, alpha);
			//
			var endX:Number = roundOff(xcenter+radius*Math.cos(startAng+i*outerDashAng));
			var endY:Number = roundOff(ycenter+radius*Math.sin(startAng+i*outerDashAng));
			//
			var e:Number = radius/Math.cos(outerDashAng/2);
			var b:Number = startAng+i*outerDashAng-outerDashAng/2;
			//
			var controlX:Number = roundOff(xcenter+e*Math.cos(b));
			var controlY:Number = roundOff(ycenter+e*Math.sin(b));
			//
			mcCanvas.curveTo(controlX, controlY, endX, endY);
		}
		// dashed line along ending angle is drawn
		for (var i:Number = loopsLine-1; i>=0; --i) {
			var alpha:Number = (Math.floor(i/2) == i/2) ? endBorderAlpha : 0;
			mcCanvas.lineStyle(borderThickness, borderColor, alpha);
			//
			var endX:Number = roundOff(xInEnd+i*dx*Math.cos(endAng));
			var endY:Number = roundOff(yInEnd+i*dx*Math.sin(endAng));
			//
			mcCanvas.lineTo(endX, endY);
		}
		// inner dashed curve part is drawn
		mcCanvas.moveTo(xInStart, yInStart);
		for (var i:Number = 1; i<=loops1; ++i) {
			var alpha:Number = (Math.floor(i/2) == i/2) ? 0 : borderAlpha;
			mcCanvas.lineStyle(borderThickness, borderColor, alpha);
			//
			var endX:Number = roundOff(xcenter+innerRadius*Math.cos(startAng+i*innerDashAng));
			var endY:Number = roundOff(ycenter+innerRadius*Math.sin(startAng+i*innerDashAng));
			//
			var e:Number = innerRadius/Math.cos(innerDashAng/2);
			var b:Number = startAng+i*innerDashAng-innerDashAng/2;
			//
			var controlX:Number = roundOff(xcenter+e*Math.cos(b));
			var controlY:Number = roundOff(ycenter+e*Math.sin(b));
			//
			mcCanvas.curveTo(controlX, controlY, endX, endY);
		}
	}
	/**
	 * drawLabel method is called to render label for the pie.
	 */
	private function drawLabel():Void {
		// storing generic piechart values required  in local variables
		var a:Array = objData.arrFinal;
		var centerX:Number = objData.centerX;
		var centerY:Number = objData.centerY;
		var radius:Number = objData.radius;
		var objTextProp:Object = objData.objLabelProps;
		//----------------------------------------------
		// creating and storing reference of a new movieclip to render the label with smartline in it
		var _mc:MovieClip = mcMain.createEmptyMovieClip('mcLabel', mcMain.getNextHighestDepth());
		// storing pie specific values required  in local variables
		var xSend:Number = a['labelProps'][0];
		var ySend:Number = a['labelProps'][1];
		var quadrantId:Number = a['labelProps'][2];
		var isIcon:Boolean = (a['labelProps'][3] == 'icon') ? true : false;
		//----------------------------------------------                                        
		// text for display in label
		var txt:String = a['labelText'];
		// textformat object for text field formatting
		var fmtTxt:TextFormat = new TextFormat();
		// properties stored
		fmtTxt.font = objTextProp.font;
		fmtTxt.size = objTextProp.size;
		fmtTxt.color = parseInt(objTextProp.color, 16);
		fmtTxt.bold = objTextProp.bold;
		fmtTxt.italic = objTextProp.italic;
		fmtTxt.underline = objTextProp.underline;
		fmtTxt.letterSpacing = objTextProp.letterSpacing;
		// alignment evaluated
		fmtTxt.align = (quadrantId == 1 || quadrantId == 4) ? "left" : "right";
		// checking for the text field width and height
		var metrics:Object = fmtTxt.getTextExtent(txt);
		var w:Number = metrics.textFieldWidth;
		var h:Number = Math.ceil(metrics.textFieldHeight);
		//-------------------------------------------------
		var xAdjust:Number, yAdjust:Number, yLineAdjust:Number, xTxt:Number, yTxt:Number;
		// adjustment value for label ordinate w.r.t. pie-depth
		var lowerYAdjust:Number = 0;
		// setting adjust values w.r.t. quadrant of - coordinates of label and starting ordinate of smartline
		if (quadrantId == 1) {
			xAdjust = 0;
			yAdjust = h;
			yLineAdjust = h/2;
		} else if (quadrantId == 2) {
			xAdjust = -w;
			yAdjust = h;
			yLineAdjust = h/2;
		} else if (quadrantId == 3) {
			xAdjust = -w;
			yAdjust = lowerYAdjust;
			yLineAdjust = lowerYAdjust-h/2;
		} else if (quadrantId == 4) {
			xAdjust = 0;
			yAdjust = lowerYAdjust;
			yLineAdjust = lowerYAdjust-h/2;
		}
		// final coordinates after adjustments                                                                                                       
		// multi-pie
		if (objData.totalSlices>1) {
			xTxt = xSend+xAdjust;
			yTxt = ySend+yAdjust;
			// singleton
		} else {
			xTxt = xSend-w/2;
			yTxt = ySend+h/2;
		}
		//-------------------------------------------------
		// storing generic piechart values required  in local variables
		var inDisplacement:Number = 0;
		var a1:Number = radius-inDisplacement;
		var b1:Number = a1;
		var a2:Number = radius;
		var b2:Number = a2;
		// mean angle of the pie in radians
		var ang:Number = MathExt.toRadians(a['meanAngle']);
		var startX:Number, startY:Number;
		//-------------------------------------------------
		// starting coordinates of the smartline w.r.t. quadrants
		if (quadrantId == 1 || quadrantId == 2) {
			startX = toNT(centerX+a1*Math.cos(ang));
			startY = toNT(centerY+b1*Math.sin(ang));
		} else {
			startX = toNT(centerX+a2*Math.cos(ang));
			startY = toNT(centerY+b2*Math.sin(ang));
		}
		// if smart labels are enabled and display of label relevant
		if (objData.isSmartLabels && !isIcon) {
			// adjusting labels for few special cases for proper visual display of smartline with label
			if (xTxt<startX && xTxt+w>startX) {
				var m:Number;
				if (quadrantId == 1 || quadrantId == 4) {
					m = startX-xTxt;
					xTxt += (m+5);
					xSend = xTxt;
				} else {
					m = xTxt+w-startX;
					xTxt -= (m+5);
					xSend = xTxt+w;
				}
			} else if (xTxt+w<startX && (quadrantId == 1 || quadrantId == 4)) {
				xTxt = startX+5;
				xSend = xTxt;
			} else if (xTxt>startX && (quadrantId == 2 || quadrantId == 3)) {
				xTxt = startX-w-5;
				xSend = xTxt+w;
			}
			var midX:Number;
			// to find the vertex abscissa of smartline
			// if smartlines are to be slanted
			if (objData.isSmartLabelSlanted) {
				if (quadrantId == 1 || quadrantId == 4) {
					midX = xSend-5;
				} else {
					midX = xSend+5;
				}
				// else, if they are to be vertical
			} else {
				midX = startX;
			}
			//---------------------------------------------
			// coordinates of the smartline end
			var xLineEnd:Number = xSend;
			var yLineEnd:Number = ySend+yLineAdjust;
			// drawing of the smartline in full and one- shot (if initial animation of smartline is over before)
			if (objData.isInitialised) {
				_mc.lineStyle(objData.smartLineThickness, objData.smartLineColor, objData.smartLineAlpha, true, "normal", "round", "round");
				_mc.moveTo(startX, startY);
				_mc.lineTo(midX, yLineEnd);
				_mc.lineTo(xLineEnd, yLineEnd);
			}
			// storing smartline coordinate values for use during slicing animation of the pie                                                             
			_mc._parent.arrLinePoints = [startX, startY, midX, xLineEnd, yLineEnd];
		} else if (objData.isSmartLabels && isIcon) {
		}
		//-------------------------------------------------                                                                                                       
		// if label is to be shown
		if (!isIcon || objData.totalSlices == 0) {
			// textfield created
			_mc.createTextField('label_txt', 11, xTxt, yTxt, w, h);
			// textfield inverted since the whole pie movieclip was inverted initially - a counter-action
			_mc.label_txt._yscale = -100;
			// if chart animation is all over beforehand or a singleton case
			if (objData.isInitialised || objData.totalSlices == 0) {
				_mc.label_txt.text = txt;
				// rendering border of textfield with proper color
				if (objTextProp.borderColor != '') {
					_mc.label_txt.border = true;
					_mc.label_txt.borderColor = parseInt(objTextProp.borderColor, 16);
				}
				// rendering bgColor of textfield with proper color                                                                                                       
				if (objTextProp.bgColor != '') {
					_mc.label_txt.background = true;
					_mc.label_txt.backgroundColor = parseInt(objTextProp.bgColor, 16);
				}
				// else, no text display                                                                                                       
			} else {
				_mc.label_txt.text = '';
				_mc.label_txt.border = false;
				_mc.label_txt.autoSize = true;
			}
			// selection disabled
			_mc.label_txt.selectable = false;
			// filter effect applied to text field if chart animation is already over
			if (objData.isInitialised) {
				chartClass.styleM.applyFilters(_mc.label_txt, chartClass.objects.DATALABELS);
			}
			// text field formatted with the stored properties                                                                                                       
			_mc.label_txt.setTextFormat(fmtTxt);
		}
	}
	/**
	 * movePie method is referenced to onRelease event of
	 * the pie movieclip.It calculates and calls repositionPie 
	 * method at regular intervals for the pie movement.
	 */
	private function movePie():Void {
		var _mc:MovieClip = mcMain;
		// to prevent an infinite loop of movePie() calls
		if (!arguments[0]) {
			_mc.pie2dTwinRef.movePie(true);
		}
		// checking if the pie is currently sliced-in or sliced-out                                                 
		if (_mc.isSlicedIn == true) {
			// will slice-out and hence set false
			_mc.isSlicedIn = false;
		}
		//-------------------------------------                                     
		var m:Number = objData.movement;
		// initialisation
		if (_mc.tracker == undefined) {
			_mc.tracker = 20;
		}
		// value updated for response in this click                                                                                                                    
		_mc.tracker = 20-_mc.tracker;
		// mean angle of this pie is converted to radians
		var meanAng:Number = MathExt.toRadians(_mc.store['meanAngle']);
		// increments in x and y scale movement is set
		var dx:Number = toNT(m*Math.cos(meanAng)/20);
		var dy:Number = toNT(m*Math.sin(meanAng)/20);
		// x and y increments are given sign for slicing in and slicing out of pie 
		dx = (_mc.isMoved) ? -dx : dx;
		// an extra negetive sign is added because the pie movieclips are inverted
		dy = -((_mc.isMoved) ? -dy : dy);
		// clearing setInterval call, if any pending
		clearInterval(_mc.id);
		// function with parameters passed are called by setInterval()
		_mc.id = setInterval(Delegate.create(this, repositionPie), 10, _mc, dx, dy);
		// updating movement status of the pie (moving in or out)
		_mc.isMoved = (_mc.isMoved) ? false : true;
	}
	/**
	 * repositionPie method called repeatedly at regular intervals
	 * from the movePie method. It shifts the pie in small 
	 * units.
	 * @param	_mc		Reference of the movieclip to control
	 * @param	dx		Numeric value increment in x-position
	 * @param	dy		Numeric value increment in y-position
	 */
	private function repositionPie(_mc:MovieClip, dx:Number, dy:Number):Void {
		// if pie movement is not complete                          
		if (_mc.tracker<20) {
			_mc.tracker++;
			//
			if (objData.isSmartLabels) {
				var objPointTxt:Object = new Object();
				objPointTxt.x = _mc.mcLabel.label_txt._x;
				objPointTxt.y = _mc.mcLabel.label_txt._y;
				_mc.localToGlobal(objPointTxt);
				//
				var objPointLine:Object = new Object();
				objPointLine.x = _mc.arrLinePoints[3];
				objPointLine.y = _mc.arrLinePoints[4];
				_mc.localToGlobal(objPointLine);
			}
			//                                                                                                                                  
			// repositioning the pie movieclip
			if (_mc.isSlicedIn == false && !_mc.isMoved && _mc.tracker == 20) {
				_mc._x = 0;
				_mc._y = objData.chartHeight;
			} else {
				_mc._x += dx;
				_mc._y += dy;
			}
			//                        
			if (objData.isSmartLabels) {
				_mc.globalToLocal(objPointTxt);
				_mc.globalToLocal(objPointLine);
				//
				var a:Number = 0;
				var b:Number = dx;
				//
				// repositioning the pie labels for no overlapping
				_mc.mcLabel.label_txt._x = objPointTxt.x+b;
				_mc.mcLabel.label_txt._y = objPointTxt.y;
				//-------------------------------------
				// smartline redrawing process w.r.t. smartline coordinates retrived ... to keep the vertical placement of the labels constant
				_mc.mcLabel.clear();
				//smartline coordinates retrived
				var x1 = _mc.arrLinePoints[0];
				var y1 = _mc.arrLinePoints[1];
				var x2 = _mc.arrLinePoints[2]-a;
				var x3 = objPointLine.x+b;
				var y3 = objPointLine.y;
				// smartline drawn if initial chart animation is over earlier
				if (objData.isInitialised) {
					_mc.mcLabel.lineStyle(objData.smartLineThickness, objData.smartLineColor, objData.smartLineAlpha, true, "normal", "round", "round");
					_mc.mcLabel.moveTo(x1, y1);
					_mc.mcLabel.lineTo(x2, y3);
					_mc.mcLabel.lineTo(x3, y3);
				}
				// smartline coordinates stored for future use                                                                                                       
				_mc.arrLinePoints = [x1, y1, x2, x3, y3];
			}
			//-------------------------------------                                                                                                                                  
			// if pie movement is complete                                                                                            
		} else {
			// actions to be triggered after the completion of inward movement
			if (_mc.isSlicedIn == false && !_mc.isMoved) {
				// isSlicedIn updated for the clicked pie
				_mc.isSlicedIn = true;
			}
			if (!objData.isInitialised) {
				chartClass.iniTrackerUpdate();
			}
			// setInterval is cleared to stop any further repositioning and other actions                                                                                                                                     
			clearInterval(_mc.id);
		}
		// stage updated to get smoother animation effect (processor intensive)
		updateAfterEvent();
	}
}
