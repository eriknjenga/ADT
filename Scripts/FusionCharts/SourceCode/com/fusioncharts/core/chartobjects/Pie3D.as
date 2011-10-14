// Import the Delegate class
import mx.utils.Delegate;
// Import the MathExt class
import com.fusioncharts.extensions.MathExt;
// Import the ColorExt class
import com.fusioncharts.extensions.ColorExt;
// Import the Pie3DChart class (to fix a flash issue)
import com.fusioncharts.core.charts.Pie3DChart;
/**
 * @class 		Pie3D
 * @version		1.0
 * @author		InfoSoft Global (P) Ltd.
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2006
 
 * Pie3D class is responsible of creating a 3d pie slice.
 * The pie slice is drawn on its instantiation with passing
 * of parameters. Each instance is passed a (common) object
 * with a host of properties in them, the movieclip 
 * reference in which to draw the pie and the unique 
 * z-level for proper 3d presentation of the pie set, 
 * mutually. It controls all post creation behavior of the
 * pie slice.
 */
class com.fusioncharts.core.chartobjects.Pie3D {
	// stores the referene of the basic 3d pie chart class (stored but not yet used)
	private var chartClass;
	// stores the reference of the movieclip inside which will all pie slices be drawn, passed as parameter
	// during instantiation of this class
	private var mcParent:MovieClip;
	// stores the reference of the z-scale level, passed as parameter during instantiation of this class
	private var level:Number;
	// stores the object, with a host of properties, passed as parameter during instantiation of this class
	private var objData:Object;
	// stores the referene of the movieclip constituting the whole pie slice
	private var mcMain:MovieClip;
	// strores the refernce of MathExt.toNearestTwip()
	private var toNT:Function;
	//
	/**
	 * Constructor function for the class. Calls the primary 
	 * drawPie method.
	 * @param	chartClassRef	Name of class instance instantiating this.
	 * @param	mcTarget		A movie clip reference passed from the
	 *							main movie. This movie clip is the clip
	 *							inside which we'll draw the 3D Pie
	 *							slice. Has to be necessarily provided.
	 * @param	mcPie			reference of mc inside which all drawings,
	 *							for this pie only, need to be done
	 * @param	obj				Object with various properties necessary
	 *							for drawing pie slices. 
	 */
	public function Pie3D(chartClassRef, mcTarget:MovieClip, mcPie:MovieClip, obj:Object) {
		// stores the referene of the basic class for creating a 3d pie chart 
		chartClass = chartClassRef;
		// stores the reference of the movieclip inside which will all pie slices be drawn
		mcParent = mcTarget;
		// stores the reference of the movieclip inside which all drawings, for this pie only, need to be done
		mcMain = mcPie;
		// stores the object, with a host of properties
		objData = obj;
		// storing the reference of MathExt.toNearestTwip()
		toNT = MathExt.toNearestTwip;
		// drawing of the pie slice is initialised 
		drawPie();
	}
	/**
	 * drawPie method is called from constructor function.
	 * It works to generate a pie slice as an 'object'.
	 * Evaluates drawing criteria for the pie slice and
	 * calls drawFlatFace and drawCurveFace methods as per
	 * requirement. Itself draws the side cut faces of the
	 * pie slice and set reference to functions for post
	 * creation behaviors of the pie slice.
	 */
	private function drawPie():Void {
		// level diagram
		// 0 - bottom face
		// 1 - start face
		// 2 - end face
		// 3 - curve face
		// 4 - top face
		// 5 - border
		// 5/0 - start face border
		// 5/1 - end face border
		// required parameters are stored in local variables
		var a:Array = objData.arrFinal;
		var squeeze:Number = objData.squeeze;
		var radius:Number = objData.radius;
		var xcenter:Number = objData.centerX;
		var ycenter:Number = objData.centerY;
		var depth:Number = objData.pieThickness;
		var borderThickness:Number = objData.borderThickness;
		var borderColor:Number = a.borderColor;
		// length of semi-major axis of ellipse
		var sa:Number = radius;
		// length of semi-minor axis of ellipse
		var sb:Number = radius*squeeze;
		// local variables declared
		var strName:String, mcPieCanvas:MovieClip, mcCanvas:MovieClip, addDepth:Number, fillAlpha:Number, lineAlpha:Number, turns:Number;
		var loops_1:Number, remainder_1:Number, sAng_1:Number, loops_2:Number, remainder_2:Number, sAng_2:Number, loops_3:Number, remainder_3:Number, sAng_3:Number;
		var loops:Number, remainder:Number, sAng:Number, eAng:Number;
		//-------------------------------------------------------------
		// movieclip reference stored in local variable
		mcPieCanvas = mcMain;
		// inverting the movieclip vertically ... this removes conflict in convention of co-ordinate axes between
		// flash and traditional coordinate geometry ... applicable for this movieclip and its sub-movies ... done
		// only for the sake of simplifying the visualization process
		mcPieCanvas._yscale = -100;
		// shifts the origin of coordinate axes to the lower left corner of the root movieclip ... this completes
		// the above mentioned attempt
		mcPieCanvas._y = objData.chartHeight;
		// stores the collection of properties in the pie movieclip itsef for further use
		mcPieCanvas.store = a;
		// movement status for the pie when drawn is flagged initially (centered in)
		if (objData.isInitialised) {
			mcPieCanvas.isSlicedIn = (a['isSliced']) ? false : true;
		} else {
			mcPieCanvas.isSlicedIn = true;
		}
		var insRef:Pie3D = this;
		// setting iniial slicing out animation if applicable
		if (a['isSliced'] && !a['isConjugated'] && !objData.isInitialised && objData.isPlotAnimationOver) {
			mcPieCanvas.onEnterFrame = function() {
				insRef.movePie();
				delete this.onEnterFrame;
			};
		}
		mcPieCanvas.insRef = this;
		// checking whether the pie set is singleton or not                           
		if (objData.totalSlices != 0 && !objData.isRotatable) {
			// if not singleton
			if (!objData.isInitialised) {
				mcPieCanvas.enabled = false;
			}
		}
		// ------------- DRAWING PROCESS BEGINS --------------- //                                                         
		// draws fills (s1=1) and borders (s1=2) of horizontal faces 
		for (var s1 = 1; s1<=2; ++s1) {
			// draws bottom (r=1) and top (r=2)
			// actually - r=1 .... changed to r=2 to remove drawing of bottom fill and border
			for (var r = 2; r<=2; ++r) {
				if (s1 == 1) {
					// r==1 is not possible in new scenenario where bottom face is not drawn
					if (r == 1) {
						// name of momvieclip to be created
						strName = 'mcBottom';
						// empty movieclip created and reference stored
						mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 0);
						// opacity applied on the movieclip to be drawn
						mcCanvas._alpha = objData.bottomAlpha;
					} else {
						strName = 'mcTop';
						mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 4);
						mcCanvas._alpha = objData.topAlpha;
					}
					// actually - r==1 .... changed to r==2 to remove drawing of bottom fill and border
				} else if (r == 2) {
					// no check and actions for r==2 : mcBorder need to created once and used for both values of r (1,2); mcCanvas is local variable defined outside loop and holds the last setting for r==2 
					strName = 'mcBorder';
					mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 5);
					mcCanvas._alpha = objData.borderAlpha;
				}
				// an addition factor denoting the height of a point above the (3d) base of pie chart                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
				addDepth = (r == 1) ? 0 : depth;
				// opacity of the fill portions of the pie
				fillAlpha = (s1 == 1) ? 100 : 0;
				// opacity of the border portions of the pie
				lineAlpha = (s1 == 2 && r == 2) ? 100 : 0;
				//
				// -----------------------------------------------------------------------------------------------
				// following conditional is for drawing horizontal faces of pie - one including (0 or 180 or both)
				// while others without such horizontal boundary issues.
				//
				// face without horizontal boundary issue
				if (!a['sidePie']) {
					// call to draw a flat horizontal face depending on the parametres passed
					drawFlatFace(mcCanvas, fillAlpha, lineAlpha, addDepth, true, true);
					// face with horizontal boundary issue 
				} else {
					// 1. Boundary curves are drawn in multiples of 45 degrees and remainder of the sweep angle thereafter.
					// 2. But pie including 0 or 180 degrees or both is required to draw part by part, to have the curves
					//    in horizontal flat faces and those of cylindrical curve faces be identical (a drawing issue).
					// 3. Curves are splited at 0 degree and 180 degree. Thus two parts for the pie including either of
					//    boundary while three parts for the pie including both of them (mutually exclusive events).
					//
					// default number of parts (and hence loops) is set to 2
					turns = 2;
					// pie including 180 degree
					if (a['sidePie'] == 'left') {
						// For first part:
						// start angle 
						sAng_1 = a['startAngle'];
						// multiples of 45 degree curve draws 
						loops_1 = Math.floor(((180-MathExt.toDegrees(a['startAngle']))/45));
						// remainder of angle to be drawn in continuation of 45 degree curve draws
						remainder_1 = MathExt.toRadians(MathExt.remainderOf(180-MathExt.toDegrees(a['startAngle']), 45));
						// For second part:
						// start angle 
						sAng_2 = Math.PI;
						// multiples of 45 degree curve draws 
						loops_2 = Math.floor(((a['endAngle']-180)/45));
						// remainder of angle to be drawn in continuation of 45 degree curve draws
						remainder_2 = MathExt.toRadians(MathExt.remainderOf(a['endAngle']-180, 45));
						//
						// pie including 0 degree
					} else if (a['sidePie'] == 'right') {
						// For first part:
						// start angle 
						sAng_1 = a['startAngle'];
						// multiples of 45 degree curve draws 
						loops_1 = Math.floor(((360-MathExt.toDegrees(a['startAngle']))/45));
						// remainder of angle to be drawn in continuation of 45 degree curve draws
						remainder_1 = MathExt.toRadians(MathExt.remainderOf(360-MathExt.toDegrees(a['startAngle']), 45));
						// For second part:
						// start angle 
						sAng_2 = 0;
						// multiples of 45 degree curve draws 
						loops_2 = Math.floor((a['endAngle']/45));
						// remainder of angle to be drawn in continuation of 45 degree curve draws
						remainder_2 = MathExt.toRadians(MathExt.remainderOf(a['endAngle'], 45));
						//
						// pie including both
					} else if (a['sidePie'] == 'both') {
						// number of parts (and hence loops) is set to 3
						turns = 3;
						// irrespective of the start angle and sweep angle, for second part:
						// multiples of 45 degree curve draws will be 4 (total of 180 degree)
						loops_2 = 4;
						// hence remainder is 0 degree
						remainder_2 = 0;
						// Two cases: start angle less than 180 degree or not
						// if start angle less than 180 degree
						if (a['startAngle']<Math.PI) {
							//
							loops_1 = Math.floor(((180-MathExt.toDegrees(a['startAngle']))/45));
							remainder_1 = MathExt.toRadians(MathExt.remainderOf(180-MathExt.toDegrees(a['startAngle']), 45));
							//
							loops_3 = Math.floor((a['endAngle']/45));
							remainder_3 = MathExt.toRadians(MathExt.remainderOf(a['endAngle'], 45));
							//
							sAng_1 = a['startAngle'];
							sAng_2 = Math.PI;
							sAng_3 = 0;
							//
							// if start angle is not less than 180 degree
						} else {
							loops_1 = Math.floor(((360-MathExt.toDegrees(a['startAngle']))/45));
							remainder_1 = MathExt.toRadians(MathExt.remainderOf(360-MathExt.toDegrees(a['startAngle']), 45));
							//
							loops_3 = Math.floor(((a['endAngle']-180)/45));
							remainder_3 = MathExt.toRadians(MathExt.remainderOf(a['endAngle']-180, 45));
							//
							sAng_1 = a['startAngle'];
							sAng_2 = 0;
							sAng_3 = Math.PI;
						}
					}
					// loops for each part of drawing                                                                                                                                                                       
					for (var d = 1; d<=turns; ++d) {
						// store the values with respective of suffix
						loops = eval('loops_'+d);
						remainder = eval('remainder_'+d);
						sAng = eval('sAng_'+d);
						// indicates whether to start drawing from centre to starting point of curve and with color fill
						var isInit:Boolean = (d == 1) ? true : false;
						// indicates whether to end drawing from ending point of curve to centre and with end of color fill
						var isFinalize:Boolean = (d == turns) ? true : false;
						// call to draw a flat horizontal face depending on the parametres passed
						drawFlatFace(mcCanvas, fillAlpha, lineAlpha, addDepth, isInit, isFinalize, loops, remainder, sAng);
					}
				}
			}
		}
		//------------------------- curve faces drawn below --------------------------
		//
		// There can be atmost 3 vertical border lines in a pie - at starting point and ending point of
		// cylindrical part of pie while the third at the centre.
		// flag for vertical lines on cylindrical part of pie is set to null initially
		var strEndVerLinesStatus:String = null;
		// storing starting angles, a['startAngle'] is in radian requires conversion to degree
		var startAng:Number = MathExt.toDegrees(a['startAngle']);
		// storing ending angles, a['endAngle'] is already in degree
		var endAng:Number = a['endAngle'];
		// sweep angle stored 
		var sw:Number = toNT(a['sweepAngle']);
		// will track only those pie which will have curve face to draw
		// and sweep angle is greater than zero degree
		//
		// initially checking for sweep angle
		if (sw != 0) {
			// checks for pie with curve face + either including both left and right edges 
			//(and covering the whole of 0 to 180 degrees range) or including none
			if (startAng>=180 && ((endAng>180 && endAng<360) || endAng == 0)) {
				//
				strEndVerLinesStatus = 'bothFace';
				strName = 'mcCurveFace';
				mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 3);
				mcCanvas._alpha = objData.curveFaceAlpha;
				//
				// checks for pie including both edges with the special case of sweep angle = 360
				if ((startAng>endAng && endAng != 0) || sw == 360) {
					//('case 1a');
					// Will have two seperate curve faces for a single pie.
					// right curved face filling:
					lineAlpha = 0;
					loops = Math.floor((360-MathExt.toDegrees(a['startAngle']))/45);
					remainder = MathExt.toRadians(MathExt.remainderOf(360-MathExt.toDegrees(a['startAngle']), 45));
					sAng = undefined;
					eAng = 0;
					// third parameter is set to false for fills while its true for borders.
					drawCurveFace(mcCanvas, lineAlpha, false, loops, remainder, sAng, eAng);
					//
					// left curved face filling:
					lineAlpha = 0;
					loops = Math.floor((a['endAngle']-180)/45);
					remainder = MathExt.toRadians(MathExt.remainderOf((a['endAngle']-180), 45));
					sAng = Math.PI;
					eAng = undefined;
					//
					drawCurveFace(mcCanvas, lineAlpha, false, loops, remainder, sAng, eAng);
					//--------------------------------------------------------------------
					//
					// right curved border tracing:
					mcCanvas = mcPieCanvas.mcBorder;
					//
					lineAlpha = 100;
					loops = Math.floor((360-MathExt.toDegrees(a['startAngle']))/45);
					remainder = MathExt.toRadians(MathExt.remainderOf(360-MathExt.toDegrees(a['startAngle']), 45));
					sAng = undefined;
					eAng = 0;
					//
					drawCurveFace(mcCanvas, lineAlpha, true, loops, remainder, sAng, eAng);
					//
					// left curved border tracing:
					lineAlpha = 100;
					loops = Math.floor((a['endAngle']-180)/45);
					remainder = MathExt.toRadians(MathExt.remainderOf((a['endAngle']-180), 45));
					sAng = Math.PI;
					eAng = undefined;
					//
					drawCurveFace(mcCanvas, lineAlpha, true, loops, remainder, sAng, eAng);
					//
					// for pie including niether edges 
				} else {
					//('case 1b');
					// curved face filling
					lineAlpha = 0;
					drawCurveFace(mcCanvas, lineAlpha, false);
					// curved border tracing
					mcCanvas = mcPieCanvas.mcBorder;
					lineAlpha = 100;
					drawCurveFace(mcCanvas, lineAlpha, true);
				}
				// 
				// for pie having curve face and including right edge only
			} else if (startAng>180 && endAng>0) {
				//('case 2');
				strEndVerLinesStatus = 'startFace';
				//
				strName = 'mcCurveFace';
				mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 3);
				mcCanvas._alpha = objData.curveFaceAlpha;
				//
				lineAlpha = 0;
				loops = Math.floor((360-MathExt.toDegrees(a['startAngle']))/45);
				remainder = MathExt.toRadians(MathExt.remainderOf(360-MathExt.toDegrees(a['startAngle']), 45));
				sAng = undefined;
				eAng = 0;
				//
				drawCurveFace(mcCanvas, lineAlpha, false, loops, remainder, sAng, eAng);
				//
				mcCanvas = mcPieCanvas.mcBorder;
				lineAlpha = 100;
				drawCurveFace(mcCanvas, lineAlpha, true, loops, remainder, sAng, eAng);
				//
				// for pie having curve face and including left edge only
			} else if (startAng<180 && endAng>180) {
				//('case 3');
				//
				strEndVerLinesStatus = 'endFace';
				//
				strName = 'mcCurveFace';
				mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 3);
				mcCanvas._alpha = objData.curveFaceAlpha;
				//
				lineAlpha = 0;
				loops = Math.floor((a['endAngle']-180)/45);
				remainder = MathExt.toRadians(MathExt.remainderOf((a['endAngle']-180), 45));
				sAng = Math.PI;
				eAng = undefined;
				//
				drawCurveFace(mcCanvas, lineAlpha, false, loops, remainder, sAng, eAng);
				//
				mcCanvas = mcPieCanvas.mcBorder;
				lineAlpha = 100;
				drawCurveFace(mcCanvas, lineAlpha, true, loops, remainder, sAng, eAng);
				//
				// checks for pie with curve face and including both left and right edges 
				//(and covering the whole of 180 to 360 degrees range)  with the special case of sweep angle = 360
			} else if ((startAng<=180 && endAng>=0 && (startAng>endAng || endAng == 0)) || sw == 360) {
				//('case 4');
				strEndVerLinesStatus = null;
				//
				strName = 'mcCurveFace';
				mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 3);
				mcCanvas._alpha = objData.curveFaceAlpha;
				//
				lineAlpha = 0;
				loops = 4;
				remainder = 0;
				sAng = Math.PI;
				eAng = 0;
				//
				drawCurveFace(mcCanvas, lineAlpha, false, loops, remainder, sAng, eAng);
				//
				mcCanvas = mcPieCanvas.mcBorder;
				lineAlpha = 100;
				drawCurveFace(mcCanvas, lineAlpha, true, loops, remainder, sAng, eAng);
				//
			}
		} else {
			//('zero sweep pie ... curve face not drawn');
		}
		//
		// ---------------------- inner/cut face drawing follows ------------------------------
		// All necessary movieclips are created and their initial visibility set.
		strName = 'mcStartFaceBorder';
		mcCanvas = mcPieCanvas.mcBorder.createEmptyMovieClip(strName, 0);
		mcCanvas._visible = false;
		//
		strName = 'mcStartFace';
		mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 1);
		mcCanvas._visible = false;
		//
		strName = 'mcEndFaceBorder';
		mcCanvas = mcPieCanvas.mcBorder.createEmptyMovieClip(strName, 1);
		mcCanvas._visible = false;
		//
		strName = 'mcEndFace';
		mcCanvas = mcPieCanvas.createEmptyMovieClip(strName, 2);
		mcCanvas._visible = false;
		//
		// Central vertical line should not be drawn twice - one each with start and end angle cut faces 
		var isVerticalCentralLine:Boolean = null;
		// calculating color of inner faces w.r.t. start/end angle
		// focusAng (angle in 2D along xy-plane) is the angle of light focused on the 3D object
		var focusAng:Number = 245;
		// colorExt.getDarkColor() is used ... so lower limit of darkness is defined by intensity
		var lowerLimit:Number = 0.65;
		// range of darkness over the lower limit is defined ... so upper limit becomes (lowerLimit+range)
		var range:Number = 0.3;
		// calculating the color of inner face along starting angle
		var diffStartAng:Number = Math.abs(startAng-focusAng);
		// to get the acute angle from the line of focus (focusAng) ... the nested ternary operator is due angles between zero degree and extreme end of the line along focusAng 
		var absStartAng:Number = (diffStartAng<=90) ? diffStartAng : ((diffStartAng<=180) ? 180-diffStartAng : diffStartAng-180);
		// the final intensity ratio
		var sRatio:Number = lowerLimit+(absStartAng/90)*range;
		// calculating the color of inner face along ending angle
		var diffEndAng:Number = Math.abs(endAng-focusAng);
		var absEndAng:Number = (diffEndAng<=90) ? diffEndAng : ((diffEndAng<=180) ? 180-diffEndAng : diffEndAng-180);
		var eRatio:Number = lowerLimit+(absEndAng/90)*range;
		//
		var startFaceColor:Number = ColorExt.getDarkColor(a['pieColor'].toString(16), sRatio);
		var endFaceColor:Number = ColorExt.getDarkColor(a['pieColor'].toString(16), eRatio);
		//
		// working with start angle to draw cut (starting) face
		if (startAng>270 || startAng<90) {
			// vertical borders drawn below              
			isVerticalCentralLine = true;
			addDepth = 0;
			mcCanvas = mcPieCanvas.mcBorder.mcStartFaceBorder;
			// both kept zero to minimize central border exposure ... set the issue later
			// no central vertical border currently visible
			var borderOpacity:Number = (a['junctionSide']) ? 0 : 0;
			mcCanvas.lineStyle(borderThickness, borderColor, borderOpacity, true, "normal", "round", "round");
			//
			mcCanvas.moveTo(xcenter, ycenter+depth);
			mcCanvas.lineTo(xcenter, ycenter);
			//
			mcCanvas.lineStyle(borderThickness, borderColor, 100, true, "normal", "round", "round");
			var xstart:Number = toNT(xcenter+sa*Math.cos(a['startAngle']));
			var ystart:Number = toNT(ycenter+addDepth+sb*Math.sin(a['startAngle']));
			mcCanvas.lineTo(xstart, ystart);
			if (!(strEndVerLinesStatus == 'startFace' || strEndVerLinesStatus == 'bothFace')) {
				mcCanvas.lineTo(xstart, ystart+depth);
			}
			//                                                                                                                                                                                                                                                                                                                                                               
			// cut face drawn below
			mcCanvas = mcPieCanvas.mcStartFace;
			mcCanvas._alpha = objData.cutFaceAlpha;
			//
			mcCanvas.lineStyle(borderThickness, borderColor, 0, true, "normal", "round", "round");
			mcCanvas.beginFill(startFaceColor, 100);
			mcCanvas.moveTo(xcenter, ycenter);
			mcCanvas.lineTo(xcenter, ycenter+depth);
			mcCanvas.lineTo(xstart, ystart+depth);
			mcCanvas.lineTo(xstart, ystart);
			mcCanvas.lineTo(xcenter, ycenter);
			mcCanvas.endFill();
		}
		// working with end angle to draw cut (ending) face                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
		if (endAng<270 && endAng>90) {
			// vertical borders drawn below              
			addDepth = 0;
			mcCanvas = mcPieCanvas.mcBorder.mcEndFaceBorder;
			//mcCanvas.lineStyle(borderThickness, borderColor, 100,true);
			//
			var xend:Number = toNT(xcenter+sa*Math.cos(MathExt.toRadians(a['endAngle'])));
			var yend:Number = toNT(ycenter+addDepth+sb*Math.sin(MathExt.toRadians(a['endAngle'])));
			//
			if (isVerticalCentralLine == null) {
				// both kept zero to minimize central border exposure ... set the issue later
				// no central vertical border currently visible
				var borderOpacity:Number = (a['junctionSide']) ? 0 : 0;
				mcCanvas.lineStyle(borderThickness, borderColor, borderOpacity, true, "normal", "round", "round");
				mcCanvas.moveTo(xcenter, ycenter+depth);
				mcCanvas.lineTo(xcenter, ycenter);
				mcCanvas.lineStyle(borderThickness, borderColor, 100, true, "normal", "round", "round");
				mcCanvas.lineTo(xend, yend);
			} else {
				mcCanvas.lineStyle(borderThickness, borderColor, 100, true, "normal", "round", "round");
				mcCanvas.moveTo(xcenter, ycenter);
				mcCanvas.lineTo(xend, yend);
			}
			if (!(strEndVerLinesStatus == 'endFace' || strEndVerLinesStatus == 'bothFace')) {
				mcCanvas.lineTo(xend, yend+depth);
			}
			//                                                                                                                                                                                                                                                                                                                                                            
			// cut face drawn below
			mcCanvas = mcPieCanvas.mcEndFace;
			mcCanvas._alpha = objData.cutFaceAlpha;
			//
			mcCanvas.lineStyle(borderThickness, borderColor, 0, true, "normal", "round", "round");
			mcCanvas.beginFill(endFaceColor, 100);
			mcCanvas.moveTo(xcenter, ycenter);
			mcCanvas.lineTo(xcenter, ycenter+depth);
			mcCanvas.lineTo(xend, yend+depth);
			mcCanvas.lineTo(xend, yend);
			mcCanvas.lineTo(xcenter, ycenter);
			mcCanvas.endFill();
		}
		//                                                                                        
		if (!mcPieCanvas.isSlicedIn) {
			mcPieCanvas.isMoved = true;
		}
		// if labelProps is defined then draw label for the pie                                              
		if (a['labelProps']) {
			drawLabel();
		}
	}
	/**
	 * drawFlatFace method is called repeatedly from drawPie
	 * method. It draws fills and border, depending on the
	 * parameters passed, of top and bottom  faces.Border of 
	 * top face is drawn and controled from this method.
	 * @param	mcCanvas		Reference of movieclip to draw in
	 * @param	fillAlpha		Numeric value of opacity for fills
	 * @param	lineAlpha		Numeric value of opacity for borders
	 * @param	addDepth		Numeric value to add up with ordinates
	 *							which determines the difference in height
	 *							between top and bottom faces.
	 * @param	init			Boolean value to indicate whether to
	 *							start up the drawing process as for a
	 *							flat face fill or not.
	 * @param	finalize		Boolean value to indicate whether to
	 *							end up the drawing process as for a
	 *							flat face fill or not.
	 * @param	loops			(Optional) Number of iterations of 
	 *							45 degrees curve drawing.
	 * @param	remainder		(Optional) Angle for curve drawing
	 *							after iterations are over.
	 * @param	sAng			(Optional) Starting angle of curve	
	 */
	private function drawFlatFace(mcCanvas:MovieClip, fillAlpha:Number, lineAlpha:Number, addDepth:Number, init:Boolean, finalize:Boolean, loops:Number, remainder:Number, sAng:Number):Void {
		// 
		var a:Array = objData.arrFinal;
		var squeeze:Number = objData.squeeze;
		var radius:Number = objData.radius;
		var depth:Number = objData.pieThickness;
		var xcenter:Number = objData.centerX;
		var ycenter:Number = objData.centerY;
		var borderThickness:Number = objData.borderThickness;
		var borderColor:Number = a.borderColor;
		//
		var sa:Number = radius;
		var sb:Number = radius*squeeze;
		//
		if (objData.useLighting) {
			// ----------- face fill gradient ------------ // 
			var strFillType:String = 'radial';
			//getting the original squeeze value
			var scaleOriginal:Number = chartClass.params.pieYScale/100;
			//calculating squeeze dependent ratio for shadow as well as highlight color
			var shadowRatio:Number = 0.85+0.15*(squeeze-scaleOriginal)/(1-scaleOriginal);
			var highlightRatio:Number = 0.5+0.5*(squeeze-scaleOriginal)/(1-scaleOriginal);
			var shadowColor:Number = ColorExt.getDarkColor(a['pieColor'].toString(16), shadowRatio);
			var highlightColor:Number = ColorExt.getLightColor(a['pieColor'].toString(16), highlightRatio);
			var arrColors:Array = [highlightColor, shadowColor];
			var arrAlphas:Array = [100, 100];
			var arrRatios:Array = [0, 255];
			// 90 is set to match the value set for gradient in drawing curve faces (arrRatios)
			var xGrad:Number = xcenter-radius-(128-90)*radius/128;
			var yGrad:Number = depth-sb;
			var widthGrad:Number = 2*radius;
			var heightGrad:Number = 2*ycenter;
			var objMatrix:Object = {matrixType:"box", x:xGrad, y:yGrad, w:widthGrad, h:heightGrad, r:0};
			// ------------ border gradient ------------- //
			var strFillTypeBorder:String = 'linear';
			var ratio1:Number = 5+85*(squeeze-scaleOriginal)/(1-scaleOriginal);
			var ratio3:Number = 250-160*(squeeze-scaleOriginal)/(1-scaleOriginal);
			var arrColorsBorder:Array = [borderColor, 0xffffff, borderColor];
			var arrAlphasBorder:Array = [lineAlpha, 30, lineAlpha];
			var arrRatiosBorder:Array = [ratio1, 90, ratio3];
			// 90 is set to match the value set for gradient in drawing curve faces (arrRatios)
			var xGradBorder:Number = xcenter-radius;
			var yGradBorder:Number = 0;
			var widthGradBorder:Number = 2*radius;
			var heightGradBorder:Number = 2*ycenter;
			var objMatrixBorder:Object = {matrixType:"box", x:xGradBorder, y:yGradBorder, w:widthGradBorder, h:heightGradBorder, r:0};
		}
		// ------------------------ DRAWING ---------------------------//                                   
		var xcontrol:Number, ycontrol:Number, xend:Number, yend:Number;
		// check to draw from centre to starting point of curve and applying color fill 
		//(not the case when drawing pie including 0 or 180 degrees)
		if (init) {
			if (objData.useLighting) {
				mcCanvas.beginGradientFill(strFillType, arrColors, arrAlphas, arrRatios, objMatrix);
			} else {
				mcCanvas.beginFill(a['pieColor'], fillAlpha);
			}
			mcCanvas.moveTo(xcenter, ycenter+addDepth);
			// 
			var xstart:Number = toNT(xcenter+sa*Math.cos(a['startAngle']));
			var ystart:Number = toNT(ycenter+addDepth+sb*Math.sin(a['startAngle']));
			// for conjugated pie, right one will not have starting face border ('both' includes right case too)
			if (a.junctionSide == 'right' || a.junctionSide == 'both') {
				mcCanvas.lineStyle(borderThickness, a['pieColor'], 0, true, "normal", "round", "round");
			} else {
				mcCanvas.lineStyle(borderThickness, borderColor, lineAlpha, true, "normal", "round", "round");
			}
			mcCanvas.lineTo(xstart, ystart);
		}
		if (objData.useLighting && squeeze != 1) {
			mcCanvas.lineGradientStyle(strFillTypeBorder, arrColorsBorder, arrAlphasBorder, arrRatiosBorder, objMatrixBorder);
		}
		// setting default values from store in Pie3D instance if parameters not supplied                                                                                                                                                                                                                                                                                                                    
		var steps:Number = (loops == undefined) ? a['no45degCurves'] : loops;
		var xtra:Number = (remainder == undefined) ? a['remainderAngle'] : remainder;
		var startAng:Number = (sAng == undefined) ? a['startAngle'] : sAng;
		// drawing 45 degree curves
		for (var j:Number = 1; j<=steps; ++j) {
			// 
			var t:Number = startAng+MathExt.toRadians(45)*j;
			// 
			xend = toNT(xcenter+sa*Math.cos(t));
			yend = toNT(ycenter+addDepth+sb*Math.sin(t));
			// 
			xcontrol = toNT(xcenter+sa*Math.cos((2*(startAng+MathExt.toRadians(45)*(j-1))+MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
			ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(startAng+MathExt.toRadians(45)*(j-1))+MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
			// 
			mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		}
		// drawing remainder curve
		var s:Number = startAng+MathExt.toRadians(45)*steps+xtra;
		//
		xend = toNT(xcenter+sa*Math.cos(s));
		yend = toNT(ycenter+addDepth+sb*Math.sin(s));
		// 
		xcontrol = toNT(xcenter+sa*Math.cos((2*(startAng+MathExt.toRadians(45)*steps)+xtra)/2)/Math.cos(xtra/2));
		ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(startAng+MathExt.toRadians(45)*steps)+xtra)/2)/Math.cos(xtra/2));
		// 
		mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		// over-ridding lineGradientStyle with lineStyle
		mcCanvas.lineStyle(borderThickness, borderColor, lineAlpha, true, "normal", "round", "round");
		// check to draw from ending point of curve to centre and ending color fill 
		//(not the case when drawing pie including 0 or 180 degrees)
		if (finalize) {
			// for conjugated pie, left one will not have ending face border ('both' includes left case too)
			if (a.junctionSide == 'left' || a.junctionSide == 'both') {
				mcCanvas.lineStyle(borderThickness, a['pieColor'], 0, true, "normal", "round", "round");
			}
			mcCanvas.lineTo(xcenter, ycenter+addDepth);
			mcCanvas.endFill();
		}
	}
	/**
	 * drawCurveFace method is optionally called repeatedly 
	 * from drawPie method. It draws fills and border, 
	 * depending on the parameters passed, of curved faces.
	 * @param	mcCanvas		Reference of movieclip to draw in
	 * @param	lineAlpha		Numeric value of opacity for borders
	 * @param	borderTruth		Boolean value to indicate whether
	 *							this method is called to generate filled curved
	 *							face or curve borders only.
	 * @param	loops			(Optional) Number of iterations of 
	 *							45 degrees curve drawing.
	 * @param	remainder		(Optional) Angle for curve drawing
	 *							after iterations are over.
	 * @param	sAng			(Optional) Starting angle of curve
	 * @param	eAng			(Optional) Ending angle of curve
	 */
	private function drawCurveFace(mcCanvas:MovieClip, lineAlpha:Number, borderTruth:Boolean, loops:Number, remainder:Number, sAng:Number, eAng:Number):Void {
		//
		var addDepth:Number;
		//
		var a:Array = objData.arrFinal;
		var squeeze:Number = objData.squeeze;
		var radius:Number = objData.radius;
		var xcenter:Number = objData.centerX;
		var ycenter:Number = objData.centerY;
		var depth:Number = objData.pieThickness;
		var borderThickness:Number = objData.borderThickness;
		var borderColor:Number = a.borderColor;
		//
		var sa:Number = radius;
		var sb:Number = radius*squeeze;
		//                                                                                  
		var strFillType:String = 'linear';
		var colorSide:Number = ColorExt.getDarkColor(a['pieColor'].toString(16), 0.8);
		// if lighting effects is to be used to get a more realistic 3D look
		var colorCenter:Number = (objData.useLighting) ? ColorExt.getLightColor(a['pieColor'].toString(16), 0.5) : a['pieColor'];
		var arrColors:Array = [colorSide, colorCenter, colorSide];
		var arrAlphas:Array = [100, 100, 100];
		var arrRatios:Array = [0, 90, 255];
		var xGrad:Number = xcenter-radius;
		var yGrad:Number = 0;
		var widthGrad:Number = 2*radius;
		var heightGrad:Number = 2*ycenter;
		var objMatrix:Object = {matrixType:"box", x:xGrad, y:yGrad, w:widthGrad, h:heightGrad, r:0};
		//
		var xcontrol:Number, ycontrol:Number, xend:Number, yend:Number;
		//--------------------------- DRAWING ------------------------------//
		// settings default values from store in this Pie3D instance if parameters are not supplied
		var steps:Number = (loops == undefined) ? a['no45degCurves'] : loops;
		var xtra:Number = (remainder == undefined) ? a['remainderAngle'] : remainder;
		var startAng:Number = (sAng == undefined) ? a['startAngle'] : sAng;
		var endAng:Number = (eAng == undefined) ? MathExt.toRadians(a['endAngle']) : eAng;
		// Numeric value to add up with ordinates which determines the difference in height
		// between top and bottom faces.
		addDepth = depth;
		mcCanvas.lineStyle(borderThickness, borderColor, lineAlpha, true, "normal", "round", "round");
		var xstart:Number = toNT(xcenter+sa*Math.cos(startAng));
		var ystart:Number = toNT(ycenter+addDepth+sb*Math.sin(startAng));
		// if curve face filling is to be done and not border tracing
		if (!borderTruth) {
			mcCanvas.beginGradientFill(strFillType, arrColors, arrAlphas, arrRatios, objMatrix);
			mcCanvas.moveTo(xstart, ystart);
			// drawing of 45 degree curves
			for (var j = 1; j<=steps; ++j) {
				//
				var t:Number = startAng+MathExt.toRadians(45)*j;
				// 
				xend = toNT(xcenter+sa*Math.cos(t));
				yend = toNT(ycenter+addDepth+sb*Math.sin(t));
				// 
				xcontrol = toNT(xcenter+sa*Math.cos((2*(startAng+MathExt.toRadians(45)*(j-1))+MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
				ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(startAng+MathExt.toRadians(45)*(j-1))+MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
				// 
				mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
			}
			// drawing of remainder curve
			xend = toNT(xcenter+sa*Math.cos(endAng));
			yend = toNT(ycenter+addDepth+sb*Math.sin(endAng));
			// 
			xcontrol = toNT(xcenter+sa*Math.cos((2*(startAng+MathExt.toRadians(45)*steps)+xtra)/2)/Math.cos(xtra/2));
			ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(startAng+MathExt.toRadians(45)*steps)+xtra)/2)/Math.cos(xtra/2));
			// 				
			mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
			// if border tracing is to be done
		} else {
			xend = toNT(xcenter+sa*Math.cos(endAng));
			yend = toNT(ycenter+addDepth+sb*Math.sin(endAng));
			//
			mcCanvas.moveTo(xend, yend);
		}
		// Conjugated pie will not show vertical border at end face of left one with an exception.
		// It will show up if the left one includes both 0 and 180 degrees and end angle is equal to 0 degree.
		if (a.junctionSide == 'left' && eAng != 0) {
			if (mcCanvas._name == 'mcBorder') {
				mcCanvas.lineStyle(borderThickness, borderColor, 0, true, "normal", "round", "round");
			}
		}
		mcCanvas.lineTo(xend, yend-addDepth);
		mcCanvas.lineStyle(borderThickness, borderColor, lineAlpha, true, "normal", "round", "round");
		addDepth = 0;
		//drawing of 45 degree curves
		for (var j = 1; j<=steps; ++j) {
			var t:Number = endAng-MathExt.toRadians(45)*j;
			// 
			xend = toNT(xcenter+sa*Math.cos(t));
			yend = toNT(ycenter+addDepth+sb*Math.sin(t));
			// 
			xcontrol = toNT(xcenter+sa*Math.cos((2*(endAng-MathExt.toRadians(45)*(j-1))-MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
			ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(endAng-MathExt.toRadians(45)*(j-1))-MathExt.toRadians(45))/2)/Math.cos(MathExt.toRadians(45)/2));
			// 
			mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		}
		// drawing of remainder curve
		xend = toNT(xcenter+sa*Math.cos(startAng));
		yend = toNT(ycenter+addDepth+sb*Math.sin(startAng));
		// 
		xcontrol = toNT(xcenter+sa*Math.cos((2*(endAng-MathExt.toRadians(45)*steps)-xtra)/2)/Math.cos(xtra/2));
		ycontrol = toNT(ycenter+addDepth+sb*Math.sin((2*(endAng-MathExt.toRadians(45)*steps)-xtra)/2)/Math.cos(xtra/2));
		// 
		mcCanvas.curveTo(xcontrol, ycontrol, xend, yend);
		// Conjugated pie will not show vertical border at start face of right one with an exception.
		// It will show up if the right one includes both 0 and 180 degrees and start angle is equal to 180 degree.
		if (a.junctionSide == 'right' && sAng != Math.PI) {
			if (mcCanvas._name == 'mcBorder') {
				mcCanvas.lineStyle(borderThickness, borderColor, 0, true, "normal", "round", "round");
			} else {
			}
		}
		mcCanvas.lineTo(xstart, ystart);
		mcCanvas.endFill();
	}
	/**
	 * drawLabel method is called to render label for the pie.
	 */
	private function drawLabel():Void {
		// storing generic piechart values required  in local variables
		var arr:Array = objData.arrFinal;
		var depth:Number = objData.pieThickness;
		var centerX:Number = objData.centerX;
		var centerY:Number = objData.centerY;
		var squeeze:Number = objData.squeeze;
		var radius:Number = objData.radius;
		var objProp:Object = objData.objLabelProps;
		//---------------------------------------------
		// creating and storing reference of a new movieclip to render the label with smartline in it
		var _mc:MovieClip = mcMain.createEmptyMovieClip('mcLabel', mcMain.getNextHighestDepth());
		// storing pie specific values required  in local variables
		var xSend:Number = objData.arrFinal['labelProps'][0];
		var ySend:Number = objData.arrFinal['labelProps'][1];
		var quadrantId:Number = objData.arrFinal['labelProps'][2];
		var isIcon:Boolean = (objData.arrFinal['labelProps'][3] == 'icon') ? true : false;
		// to avoid double labelling for conjugated pies
		if (objData.arrFinal['isLabelInvisible']) {
			_mc._visible = false;
		}
		//---------------------------------------------                                         
		// text for display in label
		var txt:String = objData.arrFinal['labelText'];
		// textformat object for text field formatting
		var fmtTxt:TextFormat = new TextFormat();
		// properties stored
		fmtTxt.font = objProp.font;
		fmtTxt.size = objProp.size;
		fmtTxt.color = parseInt(objProp.color, 16);
		fmtTxt.bold = objProp.bold;
		fmtTxt.italic = objProp.italic;
		fmtTxt.underline = objProp.underline;
		fmtTxt.letterSpacing = objProp.letterSpacing;
		// alignment evaluated
		fmtTxt.align = (quadrantId == 1 || quadrantId == 4) ? "left" : "right";
		// checking for the text field width and height
		var metrics:Object = fmtTxt.getTextExtent(txt);
		var w:Number = metrics.textFieldWidth;
		var h:Number = Math.ceil(metrics.textFieldHeight);
		//-----------------------------------------------
		var xAdjust:Number, yAdjust:Number, yLineAdjust:Number, xTxt:Number, yTxt:Number;
		// adjustment value for label ordinate w.r.t. pie-depth
		if (objData.isSmartLabels) {
			// smaller of the 2 is used to reduce jump between upper and lower quadrants
			var lowerYAdjust:Number = 0;
		} else {
			var lowerYAdjust:Number = 0;
		}
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
			yTxt = ySend+2*h;
		}
		//-------------------------------------------------
		// storing generic piechart values required  in local variables
		var inDisplacement:Number = 0;
		var a1:Number = radius-inDisplacement;
		var b1:Number = a1*squeeze;
		var d1:Number = depth;
		var a2:Number = radius;
		var b2:Number = a2*squeeze;
		var d2:Number = depth/2;
		// mean angle of the pie in radians
		var ang:Number = MathExt.toRadians(arr['meanAngle']);
		var startX:Number, startY:Number;
		//-------------------------------------------------
		// starting coordinates of the smartline w.r.t. quadrants
		if (quadrantId == 1 || quadrantId == 2) {
			startX = toNT(centerX+a1*Math.cos(ang));
			startY = toNT(centerY+d1+b1*Math.sin(ang));
		} else {
			startX = toNT(centerX+a2*Math.cos(ang));
			startY = toNT(centerY+d2+b2*Math.sin(ang));
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
			//-------------------------------------------------
			// coordinates of the smartline end
			var xLineEnd:Number = xSend;
			var yLineEnd:Number = ySend+yLineAdjust;
			// drawing of the smartline iin full and one-shot (if initial animation of smartline is over before)
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
				if (objProp.borderColor != '') {
					_mc.label_txt.border = true;
					_mc.label_txt.borderColor = parseInt(objProp.borderColor, 16);
				}
				// rendering bgColor of textfield with proper color                                              
				if (objProp.bgColor != '') {
					_mc.label_txt.background = true;
					_mc.label_txt.backgroundColor = parseInt(objProp.bgColor, 16);
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
	 * the pie movieclip. Its calculates and calls movePieCallback 
	 * method at regular intervals for the pie movement. It 
	 * controls the side cut face visibility behavior with pie
	 * movement during moving out. The special case of 
	 * animating conjugated pie is also controlled from here.
	 */
	private function movePie():Void {
		var _mc:MovieClip = mcMain;
		// checking if the pie is currently sliced-in or sliced-out
		if (_mc.isSlicedIn == true) {
			// will slice-out and hence set false
			_mc.isSlicedIn = false;
			// for conjugated pair, isSlicedIn should be updated for both 
			if (_mc.store.junctionSide) {
				var _MC:MovieClip;
				// checking for which one of the conjugated pair is clicked ... thus to take care of the other
				if (_mc._name == 'mcPie_0') {
					_MC = mcParent['mcPie_'+(objData.totalSlices-1)];
				} else if (_mc._name == 'mcPie_'+(objData.totalSlices-1)) {
					_MC = mcParent.mcPie_0;
				}
				// isSlicedIn updated for non-clicked pie of the conjugated pair                                                                                                                                                        
				_MC.isSlicedIn = false;
				// cut face visibility setter is called for non-clicked pie of the conjugated pair
				cutFaceVisibilityToggler(_MC);
			}
			// cut face visibility setter is called for clicked pie                                                                                                                                                        
			cutFaceVisibilityToggler(_mc);
		}
		//                                                                                                                                                                                                                                                                  
		//-------------------------------------------------------------
		var m:Number = objData.movement;
		var s:Number = objData.squeeze;
		var _MC:MovieClip;
		if (_mc.store.junctionSide) {
			// to get the unclicked pie of the pair
			if (_mc._name == 'mcPie_0') {
				_MC = mcParent['mcPie_'+(objData.totalSlices-1)];
			} else {
				_MC = mcParent.mcPie_0;
			}
		}
		// initialisation                                                          
		if (_mc.tracker == undefined) {
			// irrespective of _MC is defined or not
			_MC.tracker = 20;
			_mc.tracker = 20;
		}
		// value updated for response in this click                                                           
		// irrespective of _MC is defined or not
		_MC.tracker = 20-_MC.tracker;
		_mc.tracker = 20-_mc.tracker;
		// mean angle of this pie is converted to radians
		var meanAng:Number = MathExt.toRadians(_mc.store['meanAngle']);
		// increments in x and y scale movement is set
		var dx:Number = toNT(m*Math.cos(meanAng)/20);
		var dy:Number = toNT(m*s*Math.sin(meanAng)/20);
		// x and y increments are given sign for slicing in and slicing out of pie 
		dx = (_mc.isMoved) ? -dx : dx;
		// an extra negetive sign is added because the pie movieclips are inverted
		dy = -((_mc.isMoved) ? -dy : dy);
		// clearing setInterval call, if any pending
		if (_mc.store.junctionSide) {
			clearInterval(_MC.id);
			clearInterval(_mc.id);
		} else {
			clearInterval(_mc.id);
		}
		// function with parameters passed are called by setInterval at regular intervals of 10 milliseconds
		//if isInitialised is false, then the following conditionals take care of smartLabel text positions (the one
		// with isConjugated == null is required to render proper rendering)
		if (objData.isInitialised) {
			//if _mc have isConjugated set to true, then use the other one i.e. _MC
			if (_mc.store.isConjugated) {
				_MC.id = setInterval(Delegate.create(this, movePieCallback), 10, _MC, dx, dy);
				//else, if _mc have isConjugated set to null(for conjugated case) or undefined (for non-conjugated case), then use _mc
			} else {
				_mc.id = setInterval(Delegate.create(this, movePieCallback), 10, _mc, dx, dy);
			}
			//else, if isInitialised is true
		} else {
			_mc.id = setInterval(Delegate.create(this, movePieCallback), 10, _mc, dx, dy);
		}
		// updating movement status of the pie (moving in or out) 
		// checking for conjugated pie pair
		if (_mc.store.junctionSide) {
			var truth:Boolean = (_mc.isMoved) ? false : true;
			_MC.isMoved = truth;
			_mc.isMoved = truth;
		} else {
			_mc.isMoved = (_mc.isMoved) ? false : true;
		}
	}
	/**
	 * movePieCallback method called repeatedly at regular intervals
	 * from the movePie method. It shifts the pie in small 
	 * units. It controls the side cut face visibility 
	 * behavior with pie movement during moving in.
	 * @param	_mc		Reference of the movieclip to control
	 * @param	dx		Numeric value increment in x-position
	 * @param	dy		Numeric value increment in y-position
	 */
	private function movePieCallback(_mc:MovieClip, dx:Number, dy:Number):Void {
		var _MC:MovieClip;
		if (_mc.store.junctionSide) {
			// to get the unclicked pie of the pair
			if (_mc._name == 'mcPie_0') {
				_MC = mcParent['mcPie_'+(objData.totalSlices-1)];
			} else {
				_MC = mcParent.mcPie_0;
			}
		}
		// if pie movement is not complete                                                          
		if (_mc.tracker<20) {
			_mc.tracker++;
			_MC.tracker++;
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
			// checking for conjugated pair ... to reposition the other pie movieclip too
			if (_mc.store.junctionSide) {
				_MC._x = _mc._x;
				_MC._y = _mc._y;
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
				// if conjugated pie pair is relevant ... then work on the other one of the pair.. logic same as above
				if (_MC) {
					_MC.mcLabel.label_txt._x = objPointTxt.x+b;
					_MC.mcLabel.label_txt._y = objPointTxt.y;
					//-------------------------------------
					_MC.mcLabel.clear();
					var x1 = _MC.arrLinePoints[0];
					var y1 = _MC.arrLinePoints[1];
					var x2 = _MC.arrLinePoints[2]-a;
					var x3 = objPointLine.x+b;
					var y3 = objPointLine.y;
					//
					if (objData.isInitialised) {
						_MC.mcLabel.lineStyle(objData.smartLineThickness, objData.smartLineColor, objData.smartLineAlpha, true, "normal", "round", "round");
						_MC.mcLabel.moveTo(x1, y1);
						_MC.mcLabel.lineTo(x2, y3);
						_MC.mcLabel.lineTo(x3, y3);
					}
					_MC.arrLinePoints = [x1, y1, x2, x3, y3];
				}
			}
			//-------------------------------------                                                                         
			// if pie movement is complete                                                                                            
		} else {
			// actions to be triggered after the completion of inward movement
			if (_mc.isSlicedIn == false && !_mc.isMoved) {
				// isSlicedIn updated for the clicked pie
				_mc.isSlicedIn = true;
				// checking for conjugated pair
				if (_mc.store.junctionSide) {
					// isSlicedIn updated for the unclicked pie of the pair
					_MC.isSlicedIn = true;
					// cut face visibility setter is called for non-clicked pie of the conjugated pair
					cutFaceVisibilityToggler(_MC);
				}
				// cut face visibility setter is called for clicked pie                                                                                                                                                    
				cutFaceVisibilityToggler(_mc);
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
	/**
	 * cutFaceVisibilityToggler method is called by movePie or
	 * movePieCallback methods. It controls the visibility status of
	 * both cut faces of the pie slice.
	 * @param	_mc		Reference of the movieclip to control
	 */
	public static function cutFaceVisibilityToggler(_mc:MovieClip):Void {
		//	SF - start face		EF - end face
		// tracking visibility of the cut face associated with start angle
		var isSF:Boolean = _mc.mcBorder.mcStartFaceBorder._visible;
		// if this face is visible and previous pie slice in anti-clockwise direction is already sliced out ...
		// it should remain visible
		if (isSF && !_mc.prevPieRef.isSlicedIn) {
			isSF = true;
			// for all other cases ... visibility is toggled
		} else {
			isSF = (isSF) ? false : true;
		}
		// visibility is set for border of the cut face associated with start angle
		_mc.mcBorder.mcStartFaceBorder._visible = isSF;
		// visibility is set for fill of the cut face associated with start angle
		_mc.mcStartFace._visible = isSF;
		// visibility is set for border of the cut face of previous pie associated with end angle 
		_mc.prevPieRef.mcBorder.mcEndFaceBorder._visible = isSF;
		// visibility is set for fill of the cut face of previous pie associated with end angle 
		_mc.prevPieRef.mcEndFace._visible = isSF;
		//--------------------------------------------------------------
		// tracking visibility of the cut face associated with end angle
		var isEF:Boolean = _mc.mcBorder.mcEndFaceBorder._visible;
		// if this face is visible and next pie slice in anti-clockwise direction is already sliced out ...
		// it should remain visible
		if (isEF && !_mc.nextPieRef.isSlicedIn) {
			isEF = true;
			// for all other cases ... visibility is toggled
		} else {
			isEF = (isEF) ? false : true;
		}
		// visibility is set for border of the cut face associated with end angle
		_mc.mcBorder.mcEndFaceBorder._visible = isEF;
		// visibility is set for fill of the cut face associated with end angle
		_mc.mcEndFace._visible = isEF;
		// visibility is set for border of the cut face of next pie associated with start angle 
		_mc.nextPieRef.mcBorder.mcStartFaceBorder._visible = isEF;
		// visibility is set for fill of the cut face of next pie associated with start angle 
		_mc.nextPieRef.mcStartFace._visible = isEF;
		//
	}
}
