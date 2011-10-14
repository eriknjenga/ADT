/**
* @class Render
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Render class is responsible for all renderings.
*/
// import engine3D package
import com.fusioncharts.engine3D.*;
// import MathExt class
import com.fusioncharts.extensions.MathExt;
// import BitmapData class
import flash.display.BitmapData;
// class definition
class com.fusioncharts.engine3D.Render {
	/**
	 * Render class constructor.
	 */
	private function Render() {
	}
	/**
	 * clearUp method is called to clean up chart for next
	 * recreation.
	 * @param	mcBase			MC to clean in
	 * @param	arrMcBlocks		set of MC to remove interactivity
	 */
	public static function clearUp(mcBase:MovieClip, arrMcBlocks:Array):Void {
		var mcBlock:MovieClip;
		for (var i = 0; i<arrMcBlocks.length; ++i) {
			// reference of the MC with interactivity
			mcBlock = arrMcBlocks[i];
			// interactivities removed
			delete mcBlock.onRollOver;
			delete mcBlock.onRollOut;
			delete mcBlock.onMouseMove;
		}
		// remove all MC in  mcBase
		for (var i in mcBase) {
			if (mcBase[i] instanceof MovieClip) {
				mcBase[i].removeMovieClip();
			}
		}
	}
	/**
	 * createMcData method returns the path of MC created
	 * to render data items in.
	 * @param		mcBase		parent container
	 * @return					path of MC created
	 */
	public static function createMcData(mcBase:MovieClip):MovieClip {
		// level of the MC to be created
		var _depth:Number = mcBase.getNextHighestDepth();
		// name of MC
		var strNameMC:String = "mcData";
		// remove any preexisting MC by the same name
		if (mcBase[strNameMC] instanceof MovieClip) {
			mcBase[strNameMC].removeMovieClip();
		}
		// create it                           
		var mcData:MovieClip = mcBase.createEmptyMovieClip(strNameMC, _depth);
		// return the path
		return mcData;
	}
	/**
	 * createMcAxes method returns the path of MC created
	 * to render axes in.
	 * @param		mcBase		parent container
	 * @return					path of MC created
	 */
	public static function createMcAxes(mcBase:MovieClip):MovieClip {
		// level of the MC to be created
		var _depth:Number = mcBase.getNextHighestDepth();
		// name of MC
		var strNameMC:String = "mcAxes";
		// remove any preexisting MC by the same name
		if (mcBase[strNameMC] instanceof MovieClip) {
			mcBase[strNameMC].removeMovieClip();
		}
		// create it                           
		var mcAxes:MovieClip = mcBase.createEmptyMovieClip(strNameMC, _depth);
		// return the path
		return mcAxes;
	}
	/**
	 * renderObj method is one of the primary rendering method
	 * responsible for rendering everything related to data 
	 * items.
	 * @param		mcBase					parent container for all rendering
	 * @param		arr3DPlots				data item model in screen plane
	 * @param		arrDepths				depths of all items
	 * @param		arrColors				set of colors
	 * @param		arrFaces				renderable faces
	 * @param		arrChartType			series chart types
	 * @param		arrZeroPlanePlots		zero plane model in screen plane
	 * @param		objZeroPlane			zero plane params
	 * @param		dataPlotBorder			if plot border be shown
	 * @return								paths of data item MCs
	 */
	public static function renderObj(mcBase:MovieClip, arr3DPlots:Array, arrDepths:Array, arrColors:Object, arrFaces:Array, arrChartType:Array, arrZeroPlanePlots:Array, objZeroPlane:Object, dataPlotBorder:Boolean):Array {
		// chart type
		var strChartType:String;
		// array to hold all MCs corresponding/representing data for charting
		var arrMcData:Array = (arguments[10] == undefined) ? [] : arguments[10];
		// iterate over for data model items
		for (var u = 0; u<arr3DPlots.length; ++u) {
			// flag for skipping zero plane drawing
			var skipZeroPlaneDraw:Boolean = true;
			// chart type of the series
			strChartType = (arguments[9] == undefined) ? arrChartType[u] : arguments[9];
			// depth
			var _depth:Number = arrDepths[u]['depth'];
			// retrive MC at the depth
			var mc:MovieClip = mcBase.getInstanceAtDepth(_depth);
			// if no such MC exists
			if (mc == undefined) {
				// and chart type undefined meaning this is not a recursive call
				if (arguments[9] == undefined) {
					// name of data item block MC prefix for the series
					var strNameMC:String = 'mcBlock';
				} else {
					// else if a recursive call
					// update flag
					var skipZeroPlaneDraw:Boolean = true;
					// get the name of the parent MC to draw in
					var strNameMC:String = mcBase._name;
				}
				// create sub-container MC
				mc = mcBase.createEmptyMovieClip(strNameMC+'_'+_depth, _depth);
				// update flag
				skipZeroPlaneDraw = false;
			}
			// if a recursive call                                                     
			if (arguments[10] != undefined) {
				// store path of MC for interactivity
				arrMcData.push(mc);
			}
			// if not the pertinent data model level to work in                              
			if (typeof arr3DPlots[u] == 'object' && typeof arr3DPlots[u][0][0] == 'object') {
				// series id
				var seriesId:Number = u;
				// call recursively itself to dig to the required data model level
				arrMcData = arguments.callee(mc, arr3DPlots[u], arrDepths[u]['children'], arrColors[u], arrFaces[u], null, arrZeroPlanePlots, objZeroPlane, dataPlotBorder, strChartType, arrMcData, seriesId);
				// drawing of zero planes if not LINE
				if (strChartType != "LINE") {
					// face id of zero plane to be visible
					var faceId:Number = arrDepths[u]['children']['zeroPlane']['faceId'];
					// depth of zero plane
					var depth:Number = arrDepths[u]['children']['zeroPlane']['depth'];
					// face map of the zero plane
					var arrFaceMap:Array = Primitive.getFaceMap(faceId, 2);
					// if zero plane be drawn at this level
					if (!skipZeroPlaneDraw) {
						// render the zero plane for this series
						Render.drawZeroPlane(mc, depth, arrZeroPlanePlots[u], arrFaceMap, objZeroPlane);
					} else {
						//('zero plane drawing skipped');
					}
				}
			} else {
				//  else,if this is the data item level, render them 
				// series id
				var seriesId:Number = arguments[11];
				// data item/block id
				var blockId:Number = u;
				// number of sides of the 2D shape primitive
				var numSides:Number = (arr3DPlots[u].length-((strChartType == "LINE") ? 1 : 0))/2;
				// iterate for renderable faces
				for (var i = 0; i<arrFaces[u].length; ++i) {
					// face id
					var faceId = arrFaces[u][i];
					// face map
					var arrFaceMap:Array = Primitive.getFaceMap(faceId, numSides);
					var depth:Number = arrDepths[u]['children'][faceId]
					// render the face
					Render.drawFace(mc, depth, arr3DPlots[u], arrFaceMap, arrColors[u][faceId], dataPlotBorder, blockId, seriesId);
				}
			}
		}
		// return the path of MCs responsible for interactivity
		return arrMcData;
	}
	/**
	  * renderAxes method is a primary method responsible
	  * for rendering of axesBox with a host of various
	  * items associated to it.
	  * @param		mcAxes						container for drawing in
	  * @param		arrFaces					renderable axesBox faces
	  * @param		arrWallsPlots				thick axesBox model in 
	  *											screen plane
	  * @param		arrWallsFaces				renderable faces of axesWalls
	  * @param		arrMiscColors				host of various colors
	  * @param		arrAxesPlusPlots			axesPlus model in screen 
	  *											plane
	  * @param		objAxesPlusParams			axesPlus rendering params
	  * @param		arrLabelsPlot				axesLabels model in screen
	  *											plane
	  * @param		arrAxesNamesPlot			axesName positions
	  * @param		objLabels					axes label params
	  * @param		objtxtProps					text formats
	  * @param		chartToppled				if chart is toppled
	  * @param		showAlternateHGridColor		if bi-color axes walls
	  * @param		strDivLineEffect			divLine effect
	  * @param		objAxesNames				axesName params
	  * @param		objCamera					camera angles
	  */
	public static function renderAxes(mcAxes:MovieClip, arrFaces:Array, arrWallsPlots:Array, arrWallsFaces:Array, arrMiscColors:Array, arrAxesPlusPlots:Array, objAxesPlusParams:Object, arrLabelsPlot:Array, arrAxesNamesPlot:Array, objLabels:Object, objtxtProps:Object, chartToppled:Boolean, showAlternateHGridColor:Boolean, strDivLineEffect:String, objAxesNames:Object, objCamera:Object):Void {
		// primary axes color-set
		var arrColors1:Array = arrMiscColors['color'];
		// alternate axes color-set
		var arrColors2:Array = arrMiscColors['otherColor'];
		// divLine color-set
		var arrColorHLines:Array = arrMiscColors['HLines'];
		// trendLine color-set
		var arrColorTLines:Array = arrMiscColors['TLines'];
		// 6 walls are associated with 6 faces of the hypothetical axesBox. But, 6 faces of each walls are oriented
		// in different manner than those of the imaginary axesbox. To get appropriate color for each axesWall face,
		// a one-one mapping is hardcoded here. Like zeroth wall's zeroth face will take the color due same orientation
		// with fourth face of the imaginary axesBox. This is in accord with Primitive.getMap() returned arrays. 
		var arrColorMap:Array = [[4, 1, 5, 3, 2, 0], [4, 2, 5, 0, 3, 1], [4, 3, 5, 1, 0, 2], [4, 0, 5, 2, 1, 3], [3, 2, 1, 0, 5, 4], [3, 0, 1, 2, 4, 5]];
		// MC name prefix
		var strNameMC:String = "mcAxes";
		// container of MC paths of axes labels
		var arrMc:Array = [];
		// label mode
		var labelMode:String = "withFront";
		// axes labels be shown
		var yLabel:Boolean = true;
		var xLabel:Boolean = true;
		// for axes name placement
		// initialisations of face availability
		var bottomFace:Boolean = true;
		var leftFace:Boolean = true;
		var backFace:Boolean = true;
		// for axesBox renderable faces
		for (var i = 0; i<arrFaces.length; ++i) {
			// setting label mode
			if (arrFaces[i] == 5) {
				labelMode = "withBack";
			}
			// for axes name placement                          
			// setting face availability
			if (arrFaces[i] == 2) {
				leftFace = false;
			}
			if (arrFaces[i] == 1) {
				bottomFace = false;
			}
		}
		if (labelMode == "withFront") {
			backFace = false;
		}
		// --------- LABEL ROTATION ANGLE -------------//                          
		// to get rotation angle of xAxisName
		var delX:Number = arrAxesNamesPlot[0][0][0]-arrAxesNamesPlot[1][0][0];
		var delY:Number = arrAxesNamesPlot[0][0][1]-arrAxesNamesPlot[1][0][1];
		// rotation angle calculated
		var rotationAngle:Number = (Math.atan2(delY, delX))*180/Math.PI;
		// angle minimised
		if (rotationAngle>90) {
			rotationAngle -= 180;
		} else if (rotationAngle<-90) {
			rotationAngle += 180;
		}
		// -------------//                                                                                                                                                                                                                                                                                      
		// faceId below gives the face to be visible on the axesBox; its corresponding color to be derived from
		// that face of the hypothetical cube given in the map below.
		var arrInternalFaceMapForColor:Array = [2, 3, 0, 1, 5, 4];
		// create container for axes names
		var mcXLabel:MovieClip = mcAxes.createEmptyMovieClip('mcAxesNameX', mcAxes.getNextHighestDepth());
		var mcYLabel:MovieClip = mcAxes.createEmptyMovieClip('mcAxesNameY', mcAxes.getNextHighestDepth());
		// check to see if labels be shown w.r.t. camera angles
		var labels:Boolean = Render.labelsBeShown(objCamera);
		// is axesBox border be shown w.r.t. camera angle
		var axesBoxBorder:Boolean = (objCamera.angY == 0) ? true : false;
		// iterate for each renderable wall
		for (var i = 0; i<arrFaces.length; ++i) {
			// axesBox face id
			var faceId:Number = arrFaces[i];
			// container for the wall rendering created
			var mcWall:MovieClip = mcAxes.createEmptyMovieClip(strNameMC+'_'+faceId, 100+arrFaces.length-i);
			// iterate for wall faces to be rendered
			for (var j = 0; j<arrWallsFaces[faceId].length; ++j) {
				// wall face id
				var faceWallId:Number = arrWallsFaces[faceId][j];
				// face map
				var arrFaceMap:Array = Primitive.getFaceMap(faceWallId, 4, false);
				// color
				var _color:Number = arrColors1[arrColorMap[faceId][faceWallId]];
				// render the wall face and return the MC drawn in
				var _mc:MovieClip = Render.drawFace(mcWall, j, arrWallsPlots[faceId], arrFaceMap, _color, axesBoxBorder);
			}
			// -------------- axesPlus params -------------//
			// face id for getting colors
			var colorFaceId:Number = arrInternalFaceMapForColor[faceId];
			// getting the bi-color
			var arrBiColor:Array = [arrColors1[colorFaceId], arrColors2[colorFaceId]];
			// divLine color
			var hLineColor:Number = arrColorHLines[colorFaceId];
			// get the trendLine colors
			var arrTLineFaceColors:Array = [];
			for (var m = 0; m<arrAxesPlusPlots['TLines'].length; ++m) {
				arrTLineFaceColors.push(arrColorTLines[m][colorFaceId]);
			}
			// -------------------------------------------//
			// call to render all axesPlus items (HLine, TLine)
			Render.drawAxesPlus(mcWall, faceId, arrBiColor, arrAxesPlusPlots, objAxesPlusParams, showAlternateHGridColor, hLineColor, arrTLineFaceColors, strDivLineEffect);
			//------------------//
			// if labels be rendered
			if (labels) {
				// for faces other than front and back
				if (faceId<4) {
					// draw axes labels
					var mcLabelRef:MovieClip = Render.drawLabels(mcWall, arrLabelsPlot, objLabels, objtxtProps, faceId, labelMode, yLabel, xLabel, rotationAngle, chartToppled, objCamera);
					// type of label rendered
					var strLabelId:String = (faceId == 0 || faceId == 2) ? 'yLabel' : 'xLabel';
					// store the MC container for the axes labels
					arrMc[strLabelId] = mcLabelRef;
				}
			}
		}
		// if labels be shown
		if (labels) {
			// render axesname labels			
			Render.renderAxesNames(mcAxes, mcXLabel, mcYLabel, arrAxesNamesPlot, objAxesNames, leftFace, bottomFace, rotationAngle, backFace, chartToppled, arrMc, objtxtProps, objCamera);
		}
	}
	/**
	 * labelsBeShown method determines if axes labels be shown
	 * w.r.t. camera angles to avoid odd presentation.
	 * @param		objCamera		camera angles
	 * @return						if labels be shown
	 */
	private static function labelsBeShown(objCamera:Object):Boolean {
		var angX:Number = MathExt.minimiseAngle(objCamera.angX);
		var angY:Number = MathExt.minimiseAngle(objCamera.angY);
		//
		if (angX == 90 || angX == -90 || angY == 90 || angY == -90) {
			return false;
		}
		return true;
	}
	/**
	 * drawLabels method renders the axes labels.
	 * @param		mc					parent container MC
	 * @param		arrLabelsPlot		label positions
	 * @param		objLabels			label rendering params
	 * @param		objtxtProps			text formats
	 * @param		faceId				axesBox face id
	 * @param		labelMode			label mode for placement
	 * @param		yLabel				if y labels be shown
	 * @param		xLabel				if x labels be shown
	 * @param		rotationAngle		rotation angle for x labels
	 * @param		chartToppled		is chart toppled
	 * @param		objCamera			camera angles
	 * @return							path of MC drawn in
	 */
	private static function drawLabels(mc:MovieClip, arrLabelsPlot:Array, objLabels:Object, objtxtProps:Object, faceId:Number, labelMode:String, yLabel:Boolean, xLabel:Boolean, rotationAngle:Number, chartToppled:Boolean, objCamera:Object):MovieClip {
		// text format map
		var objTxtPropMap:Object = {xLabels:'DATALABELS', yLabels:'YAXISVALUES', tLabels:'TRENDVALUES'};
		// local variables
		var lineEndId:Number, color:Number, thickness:Number, alpha:Number, endId1:Number, endId2:Number, level:Number;
		var arrSubData:Array, arrSubData_i:Array;
		// iterate for each label type
		for (var labelsType in arrLabelsPlot) {
			// checking mismatch of label type with face id
			if ((labelsType == 'xLabels' && (faceId == 0 || faceId == 2)) || (labelsType != 'xLabels' && (faceId == 1 || faceId == 3))) {
				// no more action for this mismatched combination
				continue;
			}
			// create container for drawing label in                        
			var mc1:MovieClip = mc.createEmptyMovieClip('mc_'+labelsType, mc.getNextHighestDepth());
			// rotate label container for x-labels
			if (labelsType == 'xLabels') {
				mc1._rotation = rotationAngle;
			}
			// alias of label specific data                       
			arrSubData = arrLabelsPlot[labelsType];
			// iterate for each line
			for (var i = 0; i<arrSubData.length; ++i) {
				// alias for line data
				arrSubData_i = arrSubData[i];
				// depth to draw label items in - text and joining line
				level = mc1.getNextHighestDepth();
				// sub-container for label text rendering
				var _mc:MovieClip = mc1.createEmptyMovieClip('mc_labels_'+level, level);
				// for x-label
				if (labelsType == 'xLabels') {
					// compensate back the rotation angle
					_mc._rotation = -rotationAngle;
					// this rotation and anti-rotation is necessary for proper placement of xAxisName; first rotation
					// of parent container inclines the MC and xAxisname is require to be alligned to the lower/upper
					// edge of it. Parent container includes all x-labels to provide good bounding metrics. Anyhow, 
					// yAxisName is also placed using the same bounding metrics workflow.
				}
				// if the label be shown                       
				if (objLabels[labelsType][i]['showLabel']) {
					// joining line cosmetics
					color = 0xdddddd;
					thickness = 1;
					alpha = 100;
					// linestyle
					_mc.lineStyle(thickness, color, alpha);
				} else {
					// if label be not shown, still the lines are drawn to place axesnames keeping the gap
					_mc.lineStyle();
				}
				// join the line
				var x1 = arrSubData_i[0][0];
				var y1 = arrSubData_i[0][1];
				_mc.moveTo(x1, y1);
				//
				var x2 = arrSubData_i[1][0];
				var y2 = arrSubData_i[1][1];
				_mc.lineTo(x2, y2);
				//---------------------//
				// if label be shown
				if (objLabels[labelsType][i]['showLabel']) {
					// the shifting factor for x-labels so as not to overlap the axesBox or very far from it
					var xLabelShiftFactor:Number = ((chartToppled && faceId == 3) || (!chartToppled && faceId == 1)) ? -1 : 1;
					// render the label
					Render.createLabel(_mc, x2, y2, objLabels[labelsType][i]['label'], (x2-x1), (y2-y1), objtxtProps[objTxtPropMap[labelsType]], rotationAngle, xLabelShiftFactor, labelsType);
				}
			}
			// store the reference of the MC to be returned, so required for placement of axesnames
			if (labelsType == 'xLabels' || labelsType == 'yLabels') {
				var mcLabelRef:MovieClip = mc1;
			}
		}
		// return
		return mcLabelRef;
	}
	/**
	 * createLabel method renders a text label.
	 * @param		mc						container to render in
	 * @param		xPos					x position
	 * @param		yPos					y position
	 * @param		strLabel				label text
	 * @param		delX					characteristic value
	 * @param		delY					characteristic value
	 * @param		objProp					text format
	 * @param		rotationAngle			rotation angle
	 * @param		xLabelShiftFactor		shift facor for x-label
	 * @param		labelsType				label type
	 */
	private static function createLabel(mc:MovieClip, xPos:Number, yPos:Number, strLabel:String, delX:Number, delY:Number, objProp:Object, rotationAngle:Number, xLabelShiftFactor:Number, labelsType:String):Void {
		// get the bitmap to be rendered for the label text
		var _bmp:BitmapData = Render.getTxtBmp(mc, strLabel, objProp);
		// The factors to reset label positions are set to zero by default( zero will help avoid label positioning ).
		var xMultiplier:Number = 0;
		var yMultiplier:Number = 0;
		// MC level
		var level:Number = mc.getNextHighestDepth();
		// MC render the bitmap in
		var mcLabel:MovieClip = mc.createEmptyMovieClip('mcLabelTxt_'+level, level);
		// position it
		mcLabel._x = xPos;
		mcLabel._y = yPos;
		// actual MC to hold the bitmap
		var mcBmp:MovieClip = mcLabel.createEmptyMovieClip('mcBmp', 0);
		// attach it
		mcBmp.attachBitmap(_bmp, mcBmp.getNextHighestDepth());
		// flag kept in the container Mc to indicate that it holds a bitmap
		mcBmp.bitmap = true;
		// now, get the position shifting required
		// for y-axis based Labels  
		if (labelsType == 'yLabels' || labelsType == 'tLabels') {
			yMultiplier = -0.5;
			if (delX<0) {
				xMultiplier = -1;
			}
		}
		//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
		// xLabel ... delX always zero                                                                            
		if (labelsType == 'xLabels') {
			xMultiplier = -0.5;
			if (delY<0) {
				yMultiplier = -1;
			}
		}
		// for top or bottom viewing                      
		if (delX == 0 && delY == 0) {
			// no more action
			return;
		}
		// shift it                                                                                                                                                                 
		mcBmp._x = mcBmp._width*xMultiplier;
		mcBmp._y = mcBmp._height*yMultiplier;
		// for xLabels
		if (labelsType == 'xLabels') {
			// get the shift
			var xLabelShift:Number = xLabelShiftFactor*(rotationAngle/90)*mcBmp._width;
			// add the shift
			mcBmp._x -= xLabelShift;
			// rearrangement of shift for proper placement w.r.t. axesBox edge and joining line
			if (mcBmp._x>0) {
				mcBmp._x = 0;
			} else if (mcBmp._x+mcBmp._width<0) {
				mcBmp._x = -mcBmp._width;
			}
			// getting the overall factor for x adjustment                                                                                                                                                                                
			xMultiplier = mcBmp._x/mcBmp._width;
		}
		// Storing the label positioning factors in the movieclip holding the textfield (once on recreation only ...                       
		// recreation as well as scaling, both uses these to reset positions).
		mcBmp.xMultiplier = xMultiplier;
		mcBmp.yMultiplier = yMultiplier;
	}
	/**
	 * getTxtBmp method creates a bitmap of label text
	 * and returns it.
	 * @param		mc			container to render text in whose bitmap 
	 *							is created
	 * @param		strText		label text
	 * @param		objProp		text format
	 * @return					the created bitmap
	 */
	private static function getTxtBmp(mc:MovieClip, strText:String, objProp:Object):BitmapData {
		// using passed mc was giving error in _txt._width as well as _bmp.width; primarily was a problem 
		// in drawing _txt in scaled status. So, let _root be the mc with 100% scaling.
		mc = _root;
		// sub-container for rendering text
		var _mc:MovieClip = mc.createEmptyMovieClip('mcTxt', mc.getNextHighestDepth());
		// create text field
		var _txt:TextField = _mc.createTextField('txtfld', 0, 0, 0, null, null);
		_txt.autoSize = true;
		// adding a space character on both ends actually eliminates the scope of last character cutting off - a very
		// weird case ... occuring only for "s"/"v"/"y" occuring at word end of certain permutation - combination of 
		// characters and that too when the text is at certain places ... like "February" occuring as xLabel for first
		// and second category is showing the problem, only for the default starting angles. Moreover, if movie scaled 
		// up, there is absolutely no issue. It seems like encountering one of the many other (flash player) rendering 
		// issues.
		_txt.text = ' '+strText+' ';
		// format the text
		Render.formatText(_txt, objProp);
		//  create a bitmap canvas
		var _bmp:BitmapData = new BitmapData(_mc._width, _mc._height, true, 0x0);
		// draw content in the canvas, content being the formatted text
		_bmp.draw(_mc);
		// remove the text container
		_mc.removeMovieClip();
		// return
		return _bmp;
	}
	/**
	 * resetLabels method is called to maintain text type 
	 * items in its original view size.
	 * @param		mc			resetting be done for items in this
	 * @param		scaleValue	scale value to be applied to items
	 */
	public static function resetLabels(mc:MovieClip, scaleValue:Number):Void {
		// iterating over passed movieclip to reset label textfields scaling and x,y positions.
		for (var i in mc) {
			// if is a movieclip
			if (mc[i] instanceof MovieClip) {
				// if not a bitmap
				if (!mc[i].bitmap) {
					// check within the movieclip for textfields
					arguments.callee(mc[i], scaleValue);
				} else {
					// if params stored for axesName resetting
					if (mc[i].objParams) {
						// get the current settings
						var objSettings:Object = Render.getAxesNameLabelSettings(mc[i].objParams);
						// switch control
						switch (mc[i].objParams['strAxis']) {
						case 'x' :
							// for xAxisName
							// parent positioned
							mc[i]._parent._x = mc[i]._parent._y=0;
							// item scaled
							mc[i]._xscale = scaleValue;
							mc[i]._yscale = scaleValue;
							// remap position from parent system to grand parent system
							var objPt:Object = Render.remapPoint(mc[i]._parent, mc[i]._parent._parent, {x:objSettings.x, y:objSettings.y});
							// parent repositioned
							mc[i]._parent._x = objPt.x;
							mc[i]._parent._y = objPt.y;
							// item positioned w.r.t. shifting factors
							mc[i]._x = mc[i]._width*objSettings.xShiftFactor;
							mc[i]._y = mc[i]._height*objSettings.yShiftFactor;
							break;
						case 'y' :
							// for yAxisName
							// item scaled
							mc[i]._xscale = scaleValue;
							mc[i]._yscale = scaleValue;
							// parent positioned
							mc[i]._parent._x = objSettings.x;
							mc[i]._parent._y = objSettings.y;
							// item positioned w.r.t. shifting factors
							mc[i]._x = mc[i]._width*objSettings.xShiftFactor;
							mc[i]._y = mc[i]._height*objSettings.yShiftFactor;
							//
							break;
						}
					} else {
						// for axesLabels
						// scale item
						mc[i]._xscale = scaleValue;
						mc[i]._yscale = scaleValue;
						// position item
						mc[i]._x = mc[i]._width*mc[i].xMultiplier;
						mc[i]._y = mc[i]._height*mc[i].yMultiplier;
					}
				}
				// if is a textfield
			} else if (mc[i] instanceof TextField) {
				// scale up/down, the label textfield to keep the labels maintain same width and height dimensions visibly.
				mc[i]._xscale = scaleValue;
				mc[i]._yscale = scaleValue;
				// Now, after scaling is over, _width and _height gives the actual pixel dimensions of the textfield.
				// We just reassign the textfield's x and y positions for different axes walls visible. For that we 
				// use the x and y multiplying factors, for the current recreation of the chart3D orientations.
				mc[i]._x = mc[i]._width*mc.xMultiplier;
				mc[i]._y = mc[i]._height*mc.yMultiplier;
			}
		}
	}
	/**
	 * renderAxesNames method renders the axesname labels.
	 * @param		mc					container for use to get Bitmap
	 * @param		mcXLabel			MC for drawing xLabel
	 * @param		mcYLabel			MC for drawing yLabel
	 * @param		arrPositions		positions
	 * @param		objAxesNames		rendering params
	 * @param		leftFace			is left face of axesBox visible
	 * @param		bottomFace			is bottom face of axesBox visible
	 * @param		rotationAngle		rotation angle
	 * @param		backFace			is back face of axesBox visible
	 * @param		chartToppled		is chart toppled
	 * @param		arrLabelMcRef		MC references of axesLabel containers
	 * @param		objtxtProps			text formats
	 */
	public static function renderAxesNames(mc:MovieClip, mcXLabel:MovieClip, mcYLabel:MovieClip, arrPositions:Array, objAxesNames:Object, leftFace:Boolean, bottomFace:Boolean, rotationAngle:Number, backFace:Boolean, chartToppled:Boolean, arrLabelMcRef:Array, objtxtProps:Object):Void {
		// displace labels by amounts specified from XML?
		// axis names
		var xAxisName:String = objAxesNames.xAxisName;
		var yAxisName:String = objAxesNames.yAxisName;
		// MCs to draw in
		var mcXLabelRef:MovieClip = arrLabelMcRef['xLabel'];
		var mcYLabelRef:MovieClip = arrLabelMcRef['yLabel'];
		// bitmaps created
		var x_bmp:BitmapData = Render.getTxtBmp(mc, xAxisName, objtxtProps['XAXISNAME']);
		var y_bmp:BitmapData = Render.getTxtBmp(mc, yAxisName, objtxtProps['YAXISNAME']);
		//------------------ Y AXIS NAME -------------------------------------------//
		// rendering params
		var objLabelSettings:Object = Render.getAxesNameLabelSettings({strAxis:"y", mcForBound:mcYLabelRef, chartToppled:chartToppled, backFace:backFace, leftFace:leftFace, bottomFace:bottomFace});
		// MC to draw in
		var mcLabel:MovieClip = mcYLabel;
		// apply rotation
		mcLabel._rotation = objLabelSettings.rotation;
		// position it
		mcLabel._x = objLabelSettings.x;
		mcLabel._y = objLabelSettings.y;
		// create MC to hold the bitmap
		var mcBmp:MovieClip = mcLabel.createEmptyMovieClip('mcBmpY', 0);
		// attach bitmap
		mcBmp.attachBitmap(y_bmp, mcBmp.getNextHighestDepth());
		// position the bitmap container
		mcBmp._x = objLabelSettings.xShiftFactor*mcBmp._width;
		mcBmp._y = objLabelSettings.yShiftFactor*mcBmp._height;
		// flag to indicate that it holds bitmap
		mcBmp.bitmap = true;
		// positioning factors stored for use during resetting
		mcBmp.xMultiplier = objLabelSettings.xShiftFactor;
		mcBmp.yMultiplier = objLabelSettings.yShiftFactor;
		// resetting params stored
		mcBmp.objParams = {strAxis:"y", mcForBound:mcYLabelRef, chartToppled:chartToppled, backFace:backFace, leftFace:leftFace, bottomFace:bottomFace};
		//
		//------------------ X AXIS NAME --------------------------------------------//
		// rendering params
		var objLabelSettings:Object = Render.getAxesNameLabelSettings({strAxis:"x", mcForBound:mcXLabelRef, chartToppled:chartToppled, backFace:backFace, leftFace:leftFace, bottomFace:bottomFace});
		// rotation angle added
		objLabelSettings.rotation = rotationAngle;
		// MC to draw in
		var mcLabel:MovieClip = mcXLabel;
		// apply rotation
		mcLabel._rotation = objLabelSettings.rotation;
		// remap after rotation applied
		var objPt:Object = Render.remapPoint(mcLabel, mc, {x:objLabelSettings.x, y:objLabelSettings.y});
		// position it
		mcLabel._x = objPt.x;
		mcLabel._y = objPt.y;
		// create MC to hold the bitmap
		var mcBmp:MovieClip = mcLabel.createEmptyMovieClip('mcBmpX', 0);
		// attach bitmap
		mcBmp.attachBitmap(x_bmp, mcBmp.getNextHighestDepth());
		// position the bitmap container
		mcBmp._x = objLabelSettings.xShiftFactor*mcBmp._width;
		mcBmp._y = objLabelSettings.yShiftFactor*mcBmp._height;
		// flag to indicate that it holds bitmap
		mcBmp.bitmap = true;
		// positioning factors stored for use during resetting
		mcBmp.xMultiplier = objLabelSettings.xShiftFactor;
		mcBmp.yMultiplier = objLabelSettings.yShiftFactor;
		// resetting params stored
		mcBmp.objParams = {strAxis:"x", mcForBound:mcXLabelRef, chartToppled:chartToppled, backFace:backFace, leftFace:leftFace, bottomFace:bottomFace};
		//
	}
	/**
	 * getAxesNameLabelSettings method returns the axes name 
	 * label setting params.
	 * @param		objParams		params to process over
	 * @return						label setting params
	 */
	private static function getAxesNameLabelSettings(objParams:Object):Object {
		// passed params stored in local variables
		var strAxis:String = objParams.strAxis;
		var mcForBound:MovieClip = objParams.mcForBound;
		var chartToppled:Boolean = objParams.chartToppled;
		var backFace:Boolean = objParams.backFace;
		var leftFace:Boolean = objParams.leftFace;
		var bottomFace:Boolean = objParams.bottomFace;
		// container to be returned
		var objSettings:Object = {};
		// getting model bounds
		var objBounds:Object = mcForBound.getBounds();
		// bound metrics
		var x1:Number = objBounds.xMin;
		var x2:Number = objBounds.xMax;
		var y1:Number = objBounds.yMin;
		var y2:Number = objBounds.yMax;
		// for placement of axesName label along y-axis, both yLabels and tLabels must be considered. Metrics along 
		// y-axis is taken w.r.t. passed MC reference (that holding the yLabels) while the metrics along x-axis, the
		// crucial part, is taken w.r.t. the parent of the passed MC (the axesBox container).
		if (strAxis == 'y') {
			var objBounds_1:Object = mcForBound._parent.getBounds();
			// bound metrics
			x1 = objBounds_1.xMin;
			x2 = objBounds_1.xMax;
		}
		//    
		var x:Number, y:Number, rotation:Number, xShiftFactor:Number, yShiftFactor:Number;
		// full set of calculations to eval position and shifting factors
		if (strAxis == 'y') {
			if (chartToppled) {
				if (backFace) {
					if (leftFace) {
						x = x2;
						rotation = 90;
					} else {
						x = x1;
						rotation = -90;
					}
				} else {
					if (leftFace) {
						x = x1;
						rotation = -90;
					} else {
						x = x2;
						rotation = 90;
					}
				}
			} else {
				if (backFace) {
					if (leftFace) {
						x = x1;
						rotation = -90;
					} else {
						x = x2;
						rotation = 90;
					}
				} else {
					if (leftFace) {
						x = x2;
						rotation = 90;
					} else {
						x = x1;
						rotation = -90;
					}
				}
			}
			y = (y1+y2)/2;
			xShiftFactor = -0.5;
			yShiftFactor = -1;
			//
		} else if (strAxis == 'x') {
			//
			if (chartToppled) {
				if (backFace) {
					if (bottomFace) {
						y = y1;
						yShiftFactor = -1;
					} else {
						y = y2;
						yShiftFactor = 0;
					}
				} else {
					if (bottomFace) {
						y = y1;
						yShiftFactor = -1;
					} else {
						y = y2;
						yShiftFactor = 0;
					}
				}
			} else {
				if (backFace) {
					if (bottomFace) {
						y = y2;
						yShiftFactor = 0;
					} else {
						y = y1;
						yShiftFactor = -1;
					}
				} else {
					if (bottomFace) {
						y = y2;
						yShiftFactor = 0;
					} else {
						y = y1;
						yShiftFactor = -1;
					}
				}
			}
			xShiftFactor = -0.5;
			rotation = null;
			x = (x1+x2)/2;
		}
		// store params to be returned                   
		objSettings.x = x;
		objSettings.y = y;
		objSettings.rotation = rotation;
		objSettings.xShiftFactor = xShiftFactor;
		objSettings.yShiftFactor = yShiftFactor;
		//
		return objSettings;
	}
	/**
	 * remapPoint method returns the new coordinate due change
	 * in system.
	 * @param		mcOld		old system
	 * @param		mcNew		new system
	 * @param		objPoint	the point
	 * @return					transformed point coordinates
	 */
	public static function remapPoint(mcOld:MovieClip, mcNew:MovieClip, objPoint:Object):Object {
		mcOld.localToGlobal(objPoint);
		mcNew.globalToLocal(objPoint);
		return objPoint;
	}
	/**
	 * initAxesPlus method is called initially to render
	 * axesPlus independently to display a state in its
	 * animation.
	 * @param		mcAxes					MC for axes
	 * @param		arrFaces				renderable faces
	 * @param		arrAxesPlusPlots		axesPlus model
	 * @param		objAxesPlusParams		axesPlus params
	 * @param		showAlternateHGridColor	if axesBox in bi-color
	 * @param		arrColors				set of colors
	 * @param		strDivLineEffect		divLine effect
	 * @param		ratio					animating factor
	 */
	public static function initAxesPlus(mcAxes:MovieClip, arrFaces:Array, arrAxesPlusPlots:Array, objAxesPlusParams:Object, showAlternateHGridColor:Boolean, arrColors:Array, strDivLineEffect:String, ratio:Number):Void {
		// primary color
		var arrColors1:Array = arrColors['color'];
		// second color
		var arrColors2:Array = arrColors['otherColor'];
		// color for HLines
		var arrColorHLines:Array = arrColors['HLines'];
		// color for TLines
		var arrColorTLines:Array = arrColors['TLines'];
		// MC name prefix
		var strNameMC:String = "mcAxes";
		// color mapping for axesBox face id to internal faces
		var arrInternalFaceMapForColor:Array = [2, 3, 0, 1, 5, 4];
		// -------------------------------------------// 
		// iterate for faces
		for (var i = 0; i<arrFaces.length; ++i) {
			var faceId:Number = arrFaces[i];
			// wall MC
			var mcWall:MovieClip = mcAxes[strNameMC+'_'+faceId];
			// -------------------------------------------//
			// face id for getting color
			var colorFaceId:Number = arrInternalFaceMapForColor[faceId];
			// bi-color
			var arrBiColor:Array = [arrColors1[colorFaceId], arrColors2[colorFaceId]];
			// HLine color
			var hLineColor:Number = arrColorHLines[colorFaceId];
			//--------------------------------------------//
			// TLine colors
			var arrTLineFaceColors:Array = [];
			for (var m = 0; m<arrAxesPlusPlots['TLines'].length; ++m) {
				arrTLineFaceColors.push(arrColorTLines[m][colorFaceId]);
			}
			// -------------//
			// render the axesPlus w.r.t. animating factor
			Render.drawAxesPlus(mcWall, faceId, arrBiColor, arrAxesPlusPlots, objAxesPlusParams, showAlternateHGridColor, hLineColor, arrTLineFaceColors, strDivLineEffect, ratio);
		}
	}
	/**
	 * initAxesLabels method is called to independently render
	 * axeslabels
	 * @param		mcAxes				axes MC
	 * @param		arrLabelsPlot		label positions
	 * @param		objLabels			label params
	 * @param		objtxtProps			text formats
	 * @param		arrAxesNamesPlot	axesNames positions
	 * @param		arrFaces			renderable axesBox faces
	 * @return							params for axesNameLabels rendering
	 */
	public static function initAxesLabels(mcAxes:MovieClip, arrLabelsPlot:Array, objLabels:Object, objtxtProps:Object, arrAxesNamesPlot:Object, arrFaces:Object):Object {
		// logic basically same as in renderAxes method
		var mcWall:MovieClip;
		var strNameMC:String = "mcAxes";
		//--------------------------//                                                                                                                                                                                                                                                                                                                                                                                                                                                
		var labelMode:String = "withFront";
		var yLabel:Boolean = false;
		var xLabel:Boolean = false;
		// for axes name placement
		var bottomFace:Boolean = true;
		var leftFace:Boolean = true;
		var backFace:Boolean = true;
		//
		for (var i = 0; i<arrFaces.length; ++i) {
			if (arrFaces[i] == 5) {
				labelMode = "withBack";
			}
			if (arrFaces[i] == 0 || arrFaces[i] == 2) {
				yLabel = true;
			}
			if (arrFaces[i] == 1 || arrFaces[i] == 3) {
				xLabel = true;
			}
			// for axes name placement                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
			if (arrFaces[i] == 2) {
				leftFace = false;
			}
			if (arrFaces[i] == 1) {
				bottomFace = false;
			}
		}
		//-----------------------// 
		if (labelMode == "withBack") {
			if (!yLabel) {
				arrFaces.push(0);
			}
			if (!xLabel) {
				arrFaces.push(3);
			}
			//backFace = true;                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		} else if (labelMode == "withFront") {
			if (!yLabel) {
				arrFaces.push(2);
			}
			if (!xLabel) {
				arrFaces.push(1);
			}
			backFace = false;
		}
		// --------- LABEL ROTATION ANGLE -------------//                                                                                          
		var delX:Number = arrAxesNamesPlot[0][0][0]-arrAxesNamesPlot[1][0][0];
		var delY:Number = arrAxesNamesPlot[0][0][1]-arrAxesNamesPlot[1][0][1];
		var rotationAngle:Number = (Math.atan2(delY, delX))*180/Math.PI;
		if (rotationAngle>90) {
			rotationAngle -= 180;
		} else if (rotationAngle<-90) {
			rotationAngle += 180;
		}
		var chartToppled:Boolean = false;
		// container to hold references of MCs for axesLabels
		var arrMc:Array = [];
		// -------------------------------------------//
		// iterate for each faces
		for (var i = 0; i<arrFaces.length; ++i) {
			var faceId:Number = arrFaces[i];
			// not for front or back face
			if (faceId<4) {
				// wall MC
				mcWall = mcAxes[strNameMC+'_'+faceId];
				// call to render labels
				var mcLabelRef:MovieClip = Render.drawLabels(mcWall, arrLabelsPlot, objLabels, objtxtProps, faceId, labelMode, yLabel, xLabel, rotationAngle, chartToppled);
				// label type
				var strLabelId:String = (faceId == 0 || faceId == 2) ? 'yLabel' : 'xLabel';
				// store returned MC for axesLabels
				arrMc[strLabelId] = mcLabelRef;
			}
		}
		// return params to be used for rendering axeNameLabels
		return {leftFace:leftFace, bottomFace:bottomFace, rotationAngle:rotationAngle, backFace:backFace, arrMcRef:arrMc};
	}
	/**
	 * initAxesNames method is called to render axesNameLabels
	 * independently.
	 * @param		mcAxes				axes MC
	 * @param		mcXLabel			MC to render xAxis name
	 * @param		mcYLabel			MC to render yAxis name
	 * @param		arrAxesNamesPlot	label positions
	 * @param		objAxesNames		axes names
	 * @param		objParams			label params
	 * @param		chartToppled		is chart toppled
	 * @param		objTxtProp			text format
	 */
	public static function initAxesNames(mcAxes:MovieClip, mcXLabel:MovieClip, mcYLabel:MovieClip, arrAxesNamesPlot:Array, objAxesNames:Object, objParams:Object, chartToppled:Boolean, objTxtProp:Object):Void {
		// getting passed params in local variables
		var leftFace:Boolean = objParams['leftFace'];
		var bottomFace:Boolean = objParams['bottomFace'];
		var backFace:Boolean = objParams['backFace'];
		var rotationAngle:Number = objParams['rotationAngle'];
		var arrMcRef:Array = objParams['arrMcRef'];
		// call to render axesNameLabels
		Render.renderAxesNames(mcAxes, mcXLabel, mcYLabel, arrAxesNamesPlot, objAxesNames, leftFace, bottomFace, rotationAngle, backFace, chartToppled, arrMcRef, objTxtProp);
	}
	/**
	 * drawAxesBox method renders axesBox seperately without
	 * any item associated to it.
	 * @param		mcBase				axes MC
	 * @param		arrFaces			renderable faces
	 * @param		arrWallsPlots		axes wall model
	 * @param		arrWallsFaces		renderable wall faces
	 * @param		arrColors			color set
	 * @param		axesBoxBorder		if border be shown
	 * @return							path of various MCs
	 */
	public static function drawAxesBox(mcBase:MovieClip, arrFaces:Array, arrWallsPlots:Array, arrWallsFaces:Array, arrColors:Array, axesBoxBorder:Boolean):Object {
		// map to get color of axes wall faces w.r.t axesBox face colors
		var arrColorMap:Array = [[4, 1, 5, 3, 2, 0], [4, 2, 5, 0, 3, 1], [4, 3, 5, 1, 0, 2], [4, 0, 5, 2, 1, 3], [3, 2, 1, 0, 5, 4], [3, 0, 1, 2, 4, 5]];
		// create the MC to draw in
		var _depth:Number = mcBase.getNextHighestDepth();
		var strNameMC:String = "mcAxes";
		var mcAxes:MovieClip = mcBase.createEmptyMovieClip(strNameMC, _depth);
		// create the containers for axesNameLabels, paths to be returned
		var mcXLabel:MovieClip = mcAxes.createEmptyMovieClip('mcAxesNameX', mcAxes.getNextHighestDepth());
		var mcYLabel:MovieClip = mcAxes.createEmptyMovieClip('mcAxesNameY', mcAxes.getNextHighestDepth());
		// iterate over renderable faces of axesBox
		for (var i = 0; i<arrFaces.length; ++i) {
			// face id
			var faceId:Number = arrFaces[i];
			// create MC for axes wall
			var mcWall:MovieClip = mcAxes.createEmptyMovieClip(strNameMC+'_'+faceId, 100+arrFaces.length-i);
			// iterate to draw wall faces
			for (var j = 0; j<arrWallsFaces[faceId].length; ++j) {
				// wall face id
				var faceWallId:Number = arrWallsFaces[faceId][j];
				// face map
				var arrFaceMap:Array = Primitive.getFaceMap(faceWallId, 4, false);
				// color
				var _color:Number = arrColors[arrColorMap[faceId][faceWallId]];
				// render the face
				var _mc:MovieClip = Render.drawFace(mcWall, j, arrWallsPlots[faceId], arrFaceMap, _color, axesBoxBorder);
			}
		}
		// return paths of axesNameLabels particularly along with mC for the box
		return {mcAxes:mcAxes, mcXAxisNameLabel:mcXLabel, mcYAxisNameLabel:mcYLabel};
	}
	/**
	 * drawZeroPlane method renders zero plane for a series.
	 * @param		mc				parent MC to draw in
	 * @param		level			MC depth 
	 * @param		arrVertices		plane model
	 * @param		arrGuide		face map
	 * @param		objZeroPlane	rendering params
	 * @return						MC path of zero plane
	 */
	private static function drawZeroPlane(mc:MovieClip, level:Number, arrVertices:Array, arrGuide:Array, objZeroPlane:Object):MovieClip {
		// rendering params
		var color:Number = objZeroPlane.color;
		var alpha:Number = objZeroPlane.alpha;
		var mesh:Boolean = objZeroPlane.mesh;
		var thickness:Number = objZeroPlane.thickness;
		// format the color
		var planeColor:Number = parseInt(String(color), 16);
		// specified thickness not applied, may produce ugly presentation
		var borderThickness:Number = 1;
		var planeAlpha:Number = alpha;
		// if level not defined, don't draw
		if (level == undefined) {
			//zero plane undefined
			return;
		}
		// create MC to draw in              
		var _mc:MovieClip = mc.createEmptyMovieClip('mcZeroPlane_'+level, level);
		// line style
		_mc.lineStyle(borderThickness, planeColor, planeAlpha);
		// get the plane rendering vertices together
		var arr4pts:Array = [];
		for (var i = 0; i<arrGuide.length; ++i) {
			var id:Number = arrGuide[i];
			var x = arrVertices[id][0];
			var y = arrVertices[id][1];
			arr4pts.push([x, y]);
		}
		// if zero plane be a mesh
		if (mesh) {
			// mesh gaps
			var xGaps:Number = 20;
			var zGaps:Number = 5;
			// 
			var x1:Number, x2:Number, y1:Number, y2:Number, w:Number, h:Number;
			var startX:Number, startY:Number, endX:Number, endY:Number;
			// along z-axis bars
			startX = arr4pts[0][0];
			startY = arr4pts[0][1];
			//
			endX = arr4pts[3][0];
			endY = arr4pts[3][1];
			// plane dimensions (projection)
			w = arr4pts[1][0]-startX;
			h = arr4pts[1][1]-startY;
			// draw one set of bars 
			for (var i = 0; i<=xGaps; ++i) {
				x1 = startX+i*w/xGaps;
				y1 = startY+i*h/xGaps;
				//
				x2 = endX+i*w/xGaps;
				y2 = endY+i*h/xGaps;
				//
				_mc.moveTo(x1, y1);
				_mc.lineTo(x2, y2);
			}
			//-----------------//
			// along x-axis bars
			startX = arr4pts[0][0];
			startY = arr4pts[0][1];
			//
			endX = arr4pts[1][0];
			endY = arr4pts[1][1];
			//
			w = arr4pts[3][0]-startX;
			h = arr4pts[3][1]-startY;
			// draw anoter set of perpendicular bars
			for (var i = 0; i<=zGaps; ++i) {
				x1 = startX+i*w/zGaps;
				y1 = startY+i*h/zGaps;
				//
				x2 = endX+i*w/zGaps;
				y2 = endY+i*h/zGaps;
				//
				_mc.moveTo(x1, y1);
				_mc.lineTo(x2, y2);
			}
		} else {
			// else, if plane be a plane
			// draw the plane
			_mc.beginFill(planeColor, planeAlpha);
			for (var i = 0; i<=arr4pts.length; ++i) {
				var id:Number = (i == arr4pts.length) ? 0 : i;
				var x:Number = arr4pts[id][0];
				var y:Number = arr4pts[id][1];
				if (i == 0) {
					_mc.moveTo(x, y);
				} else {
					_mc.lineTo(x, y);
				}
			}
		}
		// return MC path
		return _mc;
	}
	/**
	 * drawFace method renders a face.
	 * @param		mc				parent MC
	 * @param		level			depth
	 * @param		arrVertices		data item model
	 * @param		arrGuide		face map
	 * @param		color			color
	 * @param		dataPlotBorder	if border be shown
	 * @param		mcBlockId		data item/block id
	 * @param		seriesId		series id
	 * @return						MC path of the face
	 */
	private static function drawFace(mc:MovieClip, level:Number, arrVertices:Array, arrGuide:Array, color:Number, dataPlotBorder:Boolean, mcBlockId:Number, seriesId:Number):MovieClip {
		// "level" will be undefined "normally" for LineChart, for those view angles in which neither of top or bottom face
		// is to be rendered ... in which case, a special situation, line drawing be done. Situation handled by the caller
		// function with provision in "Plane" class. This gives the side view of the (thick) plane.
		// if side of LINE be drawn
		if (arrGuide.length == 2) {
			var line2D:Boolean = true;
		}
		var borderColor:Number, borderThickness:Number, borderAlpha:Number;
		// linestyle
		if (line2D) {
			// for drawing side of LINE
			borderColor = color;
			borderThickness = 2;
			borderAlpha = 100;
		} else {
			// for others
			borderColor = 0xDDDDDD;
			borderThickness = 0;
			borderAlpha = 50;
		}
		// MC for drawing face in created
		var _mc:MovieClip = mc.createEmptyMovieClip('mcFace_'+level, level);
		// set line style for LINE side view or for showing border for all
		if (dataPlotBorder || line2D) {
			_mc.lineStyle(borderThickness, borderColor, borderAlpha);
		} else {
			// else, border be invisible
			_mc.lineStyle();
		}
		// to draw borders only or with fill
		if (color != undefined) {
			_mc.beginFill(color, 100);
		}
		// to store face map for tooltip interactivity                                                                                                                                                                                                                                                                                                                                                                                                             
		_mc.arrMap = [];
		// store series and data item/block id for tooltip interactivity
		_mc.mcBlockId = mcBlockId;
		_mc.seriesId = seriesId;
		// darw the face and fill in ids in the face map
		for (var i = 0; i<=arrGuide.length; ++i) {
			var id:Number = (i == arrGuide.length) ? arrGuide[0] : arrGuide[i];
			var x = arrVertices[id][0];
			var y = arrVertices[id][1];
			if (i != arrGuide.length) {
				_mc.arrMap.push(id);
			}
			if (i == 0) {
				_mc.moveTo(x, y);
			} else {
				_mc.lineTo(x, y);
			}
		}
		// return face MC
		return _mc;
	}
	/**
	 * drawAxesPlus method renders axesPlus data for a face.
	 * @param		mc							parent MC
	 * @param		faceId						face id
	 * @param		arrBiColor					axes bi-color
	 * @param		arrAxesPlusPlots			axesPlus model
	 * @param		objAxesPlusParams			axesPlus params
	 * @param		showAlternateHGridColor		if bi-colored axes be 
	 *											drawn
	 * @param		hLineColor					divLine color
	 * @param		arrTLineFaceColors			trendLine colors
	 * @param		strDivLineEffect			divLine effect
	 * @param		ratio						animating factor (optional)
	 */
	private static function drawAxesPlus(mc:MovieClip, faceId:Number, arrBiColor:Array, arrAxesPlusPlots:Array, objAxesPlusParams:Object, showAlternateHGridColor:Boolean, hLineColor:Number, arrTLineFaceColors:Array, strDivLineEffect:String, ratio:Number):Void {
		// flag for animation over
		var animOver:Boolean = false;
		// for normal call (not animating)
		if (ratio == undefined) {
			ratio = 1;
			// update flag
			animOver = true;
		}
		// if animating           
		if (!animOver) {
			// remove previous MCs
			for (var mcOld in mc) {
				if (mcOld.indexOf('mcAxesPlus_') != -1) {
					mc[mcOld].removeMovieClip();
				}
			}
		}
		var lineEndId:Number, color:Number, thickness:Number, alpha:Number, level:Number;
		// iterate for each line type
		for (var axesPlusType in arrAxesPlusPlots) {
			// line type specific data
			var arrSubData:Array = arrAxesPlusPlots[axesPlusType];
			// number of lines
			var lengthArr:Number = arrSubData.length;
			// line-set for the line type
			for (var i = 0; i<lengthArr; ++i) {
				// checking for mismatch combinations
				if (((faceId == 0 || faceId == 2) && axesPlusType == 'VLines') || ((faceId == 1 || faceId == 3) && axesPlusType != 'VLines')) {
					// no action
					continue;
				}
				// level for it           
				level = objAxesPlusParams[axesPlusType][i]['depth'];
				 
				// create MC to draw line in
				var _mc:MovieClip = mc.createEmptyMovieClip('mcAxesPlus_'+level, level);
				// lineType control
				switch (axesPlusType) {
					// for HLine/divLine
				case 'HLines' :
					// for showing bi-colored axes
					if (showAlternateHGridColor) {
						if (i<arrSubData.length-1) {
							alpha = objAxesPlusParams[axesPlusType][i]['alpha'];
							// alpha set to have fade in effect during animation
							alpha *= (ratio>1)?1:ratio;
							// apply alternate color
							var color:Number = (i%2 == 0) ? arrBiColor[0] : arrBiColor[1];
							// draw the grid
							_mc.lineStyle();
							_mc.beginFill(color, alpha);
							//
							lineEndId = 0;
							var x1 = arrSubData[i][faceId][lineEndId][0];
							var y1 = arrSubData[i][faceId][lineEndId][1];
							_mc.moveTo(x1, y1);
							//
							lineEndId = 1;
							var x2 = arrSubData[i][faceId][lineEndId][0];
							var y2 = arrSubData[i][faceId][lineEndId][1];
							_mc.lineTo(x2, y2);
							//-------------//
							lineEndId = 1;
							var x1 = arrSubData[i+1][faceId][lineEndId][0];
							var y1 = arrSubData[i+1][faceId][lineEndId][1];
							_mc.lineTo(x1, y1);
							//
							lineEndId = 0;
							var x2 = arrSubData[i+1][faceId][lineEndId][0];
							var y2 = arrSubData[i+1][faceId][lineEndId][1];
							_mc.lineTo(x2, y2);
							_mc.endFill();
						}
					} else {
						// else, for line presentation of divLine/HLine
						// setting direction of growing line during animation 
						var arrLineIds:Array = (ratio<1 && faceId == 0) ? [1, 0] : [0, 1];
						//
						color = hLineColor;
						// effect specific thickness
						thickness = (strDivLineEffect == 'BEVEL') ? 0 : objAxesPlusParams[axesPlusType][i]['thickness'];
						alpha = objAxesPlusParams[axesPlusType][i]['alpha'];
						// draw the line
						_mc.lineStyle(thickness, color, alpha);
						//
						lineEndId = arrLineIds[0];
						var x1 = arrSubData[i][faceId][lineEndId][0];
						var y1 = arrSubData[i][faceId][lineEndId][1];
						_mc.moveTo(x1, y1);
						//
						lineEndId = arrLineIds[1];
						var x2 = arrSubData[i][faceId][lineEndId][0];
						var y2 = arrSubData[i][faceId][lineEndId][1];
						// for animation
						if (ratio<1) {
							// draw part of the line segment
							_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
						} else {
							// else, draw full line
							_mc.lineTo(x2, y2);
						}
						// effect application
						switch (strDivLineEffect) {
							// add more line adjacent to it to produce the desired effect
						case 'BEVEL' :
							_mc.lineStyle(0, 0xffffff, 15);
							lineEndId = arrLineIds[0];
							var x1 = arrSubData[i][faceId][lineEndId][0];
							var y1 = arrSubData[i][faceId][lineEndId][1]+2;
							_mc.moveTo(x1, y1);
							//
							lineEndId = arrLineIds[1];
							var x2 = arrSubData[i][faceId][lineEndId][0];
							var y2 = arrSubData[i][faceId][lineEndId][1]+2;
							// for animation
							if (ratio<1) {
								// draw part of the line segment
								_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
							} else {
								// else, draw full line
								_mc.lineTo(x2, y2);
							}
							// no 'break' statement, to add more for bevel effect over emboss
						case 'EMBOSS' :
							if (strDivLineEffect != 'BEVEL') {
								_mc.lineStyle(0, 0xffffff, 30);
							}
							lineEndId = arrLineIds[0];
							var x1 = arrSubData[i][faceId][lineEndId][0];
							var y1 = arrSubData[i][faceId][lineEndId][1]-2;
							_mc.moveTo(x1, y1);
							//
							lineEndId = arrLineIds[1];
							var x2 = arrSubData[i][faceId][lineEndId][0];
							var y2 = arrSubData[i][faceId][lineEndId][1]-2;
							// for animation
							if (ratio<1) {
								// draw part of the line segment
								_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
							} else {
								// else, draw full line
								_mc.lineTo(x2, y2);
							}
							break;
						}
						//----------------------------//    
					}
					break;
				case 'VLines' :
				case 'TLines' :
					// for TLines and VLines
					// setting direction of growing line during animation 
					var arrLineIds:Array = (ratio<1 && faceId == 0) ? [1, 0] : [0, 1];
					//
					color = arrTLineFaceColors[i];
					thickness = objAxesPlusParams[axesPlusType][i]['thickness'];
					alpha = objAxesPlusParams[axesPlusType][i]['alpha'];
					//
					_mc.lineStyle(thickness, color, alpha);
					//
					lineEndId = arrLineIds[0];
					var x1 = arrSubData[i][faceId][lineEndId][0];
					var y1 = arrSubData[i][faceId][lineEndId][1];
					_mc.moveTo(x1, y1);
					//
					lineEndId = arrLineIds[1];
					var x2 = arrSubData[i][faceId][lineEndId][0];
					var y2 = arrSubData[i][faceId][lineEndId][1];
					// for animation
					if (ratio<1) {
						// draw part of the line segment
						_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
					} else {
						// else, draw full line
						_mc.lineTo(x2, y2);
					}
					//
					switch (strDivLineEffect) {
					case 'BEVEL' :
						_mc.lineStyle(0, 0xffffff, 15);
						lineEndId = arrLineIds[0];
						var x1 = arrSubData[i][faceId][lineEndId][0];
						var y1 = arrSubData[i][faceId][lineEndId][1]+2;
						_mc.moveTo(x1, y1);
						//
						lineEndId = arrLineIds[1];
						var x2 = arrSubData[i][faceId][lineEndId][0];
						var y2 = arrSubData[i][faceId][lineEndId][1]+2;
						// for animation
						if (ratio<1) {
							// draw part of the line segment
							_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
						} else {
							// else, draw full line
							_mc.lineTo(x2, y2);
						}
						// no 'break' statement
					case 'EMBOSS' :
						if (strDivLineEffect != 'BEVEL') {
							_mc.lineStyle(0, 0xffffff, 30);
						}
						lineEndId = arrLineIds[0];
						var x1 = arrSubData[i][faceId][lineEndId][0];
						var y1 = arrSubData[i][faceId][lineEndId][1]-2;
						_mc.moveTo(x1, y1);
						//
						lineEndId = arrLineIds[1];
						var x2 = arrSubData[i][faceId][lineEndId][0];
						var y2 = arrSubData[i][faceId][lineEndId][1]-2;
						// for animation
						if (ratio<1) {
							// draw part of the line segment
							_mc.lineTo(x1+(x2-x1)*ratio, y1+(y2-y1)*ratio);
						} else {
							// else, draw full line
							_mc.lineTo(x2, y2);
						}
						break;
					}
					break;
				}
			}
		}
	}
	/**
	 * formatText method formats a given text field 
	 * by the given format.
	 * @param		txtLabel	textfield to format
	 * @param		objProp		format object
	 */
	private static function formatText(txtLabel:TextField, objProp:Object):Void {
		// apply formatting params to the formating agent
		var fmtTxt:TextFormat = new TextFormat();
		fmtTxt.font = objProp.font;
		fmtTxt.size = objProp.size;
		fmtTxt.italic = objProp.italic;
		fmtTxt.bold = objProp.bold;
		fmtTxt.underline = objProp.underline;
		fmtTxt.letterSpacing = objProp.letterSpacing;
		fmtTxt.color = objProp.color;
		// more properies to set 
		var isHTML:Boolean = objProp.isHTML;
		var bgColor:Number = parseInt(objProp.bgColor, 16);
		var borderColor:Number = parseInt(objProp.borderColor, 16);
		// text formatted
		txtLabel.setTextFormat(fmtTxt);
		// apply other properties
		if (!isNaN(bgColor)) {
			txtLabel.background = true;
			txtLabel.backgroundColor = bgColor;
		}
		if (!isNaN(borderColor)) {
			txtLabel.border = true;
			txtLabel.borderColor = borderColor;
		}
	}
	/**
	 * renderDataLabels method shows the data value labels
	 * for the pertinent series set.
	 * @param		mcBase					chart data MC
	 * @param		arrLabelPos				label positions
	 * @param		arrDataLabels			label values
	 * @param		objProp					text format
	 * @param		arrDepths				depth dataset for data model
	 * @param		arrActiveDataLabels		series for which labels be shown
	 * @param		arrColors				txtBox border colors
	 * @param		arrCategory				chart types
	 */
	public static function renderDataLabels(mcBase:MovieClip, arrLabelPos:Array, arrDataLabels:Array, objProp:Object, arrDepths:Array, arrActiveDataLabels:Array, arrColors:Array, arrCategory:Array):Void {
		var xFactor:Number, yFactor:Number, valueNum:Number;
		// MC name prefix
		var strLabelMC:String = 'mcDataLabels_';
		// iterate over active data labels
		for (var k = 0; k<arrActiveDataLabels.length; ++k) {
			var seriesId:Number = arrActiveDataLabels[k];
			var depth:Number = arrDepths[seriesId]['depth'];
			// get MC at depth
			var _mc:MovieClip = mcBase.getInstanceAtDepth(depth);
			// get and set the depth in a variable on the parent MC
			_mc.depthOfLabelMc = _mc.getNextHighestDepth();
			// create MC
			var mcLabels:MovieClip = _mc.createEmptyMovieClip(strLabelMC+seriesId, _mc.depthOfLabelMc);
			var chartType:String = arrCategory[seriesId];
			var seriesLength:Number = arrLabelPos[seriesId].length;
			// iterate over series data
			for (var j = 0; j<seriesLength; ++j) {
				valueNum = arrDataLabels[seriesId][j]['value'];
				// if label not tobe shown
				if (!arrDataLabels[seriesId][j]['showLabel']) {
					// no action
					continue;
				}
				// create text field       
				var txtLabel:TextField = mcLabels.createTextField('label_'+j, j, arrLabelPos[seriesId][j][0], arrLabelPos[seriesId][j][1], null, null);
				txtLabel.text = arrDataLabels[seriesId][j]['labelValue'];
				txtLabel.autoSize = true;
				txtLabel.selectable = false;
				//format the text
				Render.formatText(txtLabel, objProp);
				txtLabel.background = true;
				txtLabel.border = true;
				txtLabel.borderColor = arrColors[seriesId][0];
				//
				var sign:Number, nextValueNum:Number, prevValueNum:Number;
				// work for repositioning labels
				if (chartType == 'COLUMN') {
					sign = (valueNum<0) ? 0 : -1;
					// reposition label
					txtLabel._y += sign*txtLabel._height;
					txtLabel._x -= txtLabel._width/2;
				} else if (chartType == 'LINE') {
					xFactor = null;
					yFactor = null;
					nextValueNum = Number(arrDataLabels[seriesId][j+1]['value']);
					prevValueNum = Number(arrDataLabels[seriesId][j-1]['value']);
					//
					if (j == 0) {
						xFactor = -1/2;
						yFactor = (valueNum>nextValueNum) ? -1 : 0;
					} else if (j == seriesLength-1) {
						xFactor = -1/2;
						yFactor = (prevValueNum>valueNum) ? 0 : -1;
					} else {
						var del1:Number = prevValueNum-valueNum;
						var testExp1:Number = (del1 != 0) ? Math.abs(del1)/del1 : 0;
						//
						var del2:Number = valueNum-nextValueNum;
						var testExp2:Number = (del2 != 0) ? Math.abs(del2)/del2 : 0;
						//
						switch (testExp1) {
							// decreasing
						case 1 :
							//('decreasing');
							switch (testExp2) {
								// decreasing
							case 1 :
								//('decreasing');
								xFactor = -1;
								yFactor = 0;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = -1/2;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = 0;
								break;
							}
							break;
							// increasing
						case -1 :
							//('increasing');
							switch (testExp2) {
								// decreasing
							case 1 :
								//(' decreasing');
								xFactor = -1/2;
								yFactor = -1;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = 0;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = -1;
								break;
							}
							break;
							// horizontal
						case 0 :
							//('horizontal');
							switch (testExp2) {
								// decreasing
							case 1 :
								//('decreasing');
								xFactor = -1/2;
								yFactor = -1;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = -1/2;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = -1;
								break;
							}
							break;
						}
					}
					// reposition label
					txtLabel._x += xFactor*txtLabel._width;
					txtLabel._y += yFactor*txtLabel._height;
				} else if (chartType == 'AREA') {
					sign = (valueNum>=0) ? -1 : 0;
					// reposition label
					txtLabel._y += sign*txtLabel._height;
					txtLabel._x -= txtLabel._width/2;
				}
			}
		}
	}
	/**
	 * renderDataLabelsOf method shows the data value labels
	 * for a specified series.
	 * @param		mcBase				chart data MC
	 * @param		arrLabelPos			label positions
	 * @param		arrDataLabels		label values
	 * @param		objProp				text format
	 * @param		arrDepths			depth dataset for data model
	 * @param		seriesId			series for which labels be shown
	 * @param		showLabels			label be shown or hiden
	 * @param		borderColor			txtBox border color
	 * @param		chartType			chart type
	 */
	public static function renderDataLabelsOf(mcBase:MovieClip, arrLabelPos:Array, arrDataLabels:Array, objProp:Object, arrDepths:Array, seriesId:Number, showLabels:Boolean, borderColor:Number, chartType:String):Void {
		var xFactor:Number, yFactor:Number;
		// MC name prefix
		var strLabelMC:String = 'mcDataLabels_';
		var depth:Number = arrDepths[seriesId]['depth'];
		// get MC at depth
		var _mc:MovieClip = mcBase.getInstanceAtDepth(depth);
		// get and set the depth in a variable on the parent MC
		_mc.depthOfLabelMc = _mc.getNextHighestDepth();
		// if labels be shown
		if (showLabels) {
			// create MC
			var mcLabels:MovieClip = _mc.createEmptyMovieClip(strLabelMC+seriesId, _mc.depthOfLabelMc);
		} else {
			// else for hiding labels
			// get MC reference
			var mcLabels:MovieClip = _mc[strLabelMC+seriesId];
		}
		// series length
		var seriesLength:Number = arrLabelPos[seriesId].length;
		// iterate over series data
		for (var j = 0; j<seriesLength; ++j) {
			// for labels be shown
			if (showLabels) {
				valueNum = Number(arrDataLabels[seriesId][j]['value']);
				// if label not be shown
				if (!arrDataLabels[seriesId][j]['showLabel']) {
					// no action
					continue;
				}
				// create text field       
				var txtLabel:TextField = mcLabels.createTextField('label_'+j, j, arrLabelPos[seriesId][j][0], arrLabelPos[seriesId][j][1], null, null);
				txtLabel.text = arrDataLabels[seriesId][j]['labelValue'];
				txtLabel.autoSize = true;
				txtLabel.selectable = false;
				// format text
				Render.formatText(txtLabel, objProp);
				txtLabel.background = true;
				txtLabel.border = true;
				txtLabel.borderColor = borderColor;
				//
				var sign:Number, valueNum:Number, nextValueNum:Number, prevValueNum:Number;
				// now work for repositioning labels
				if (chartType == 'COLUMN') {
					sign = (valueNum<0) ? 0 : -1;
					// reposition label
					txtLabel._y += sign*txtLabel._height;
					txtLabel._x -= txtLabel._width/2;
				} else if (chartType == 'LINE') {
					xFactor = null;
					yFactor = null;
					nextValueNum = Number(arrDataLabels[seriesId][j+1]['value']);
					prevValueNum = Number(arrDataLabels[seriesId][j-1]['value']);
					//
					if (j == 0) {
						xFactor = -1/2;
						yFactor = (valueNum>nextValueNum) ? -1 : 0;
					} else if (j == seriesLength-1) {
						xFactor = -1/2;
						yFactor = (prevValueNum>valueNum) ? 0 : -1;
					} else {
						var del1:Number = prevValueNum-valueNum;
						var testExp1:Number = (del1 != 0) ? Math.abs(del1)/del1 : 0;
						//
						var del2:Number = valueNum-nextValueNum;
						var testExp2:Number = (del2 != 0) ? Math.abs(del2)/del2 : 0;
						//
						switch (testExp1) {
							// decreasing
						case 1 :
							//('decreasing');
							switch (testExp2) {
								// decreasing
							case 1 :
								//('decreasing');
								xFactor = -1;
								yFactor = 0;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = -1/2;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = 0;
								break;
							}
							break;
							// increasing
						case -1 :
							//('increasing');
							switch (testExp2) {
								// decreasing
							case 1 :
								//('decreasing');
								xFactor = -1/2;
								yFactor = -1;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = 0;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = -1;
								break;
							}
							break;
							// horizontal
						case 0 :
							//('horizontal');
							switch (testExp2) {
								// decreasing
							case 1 :
								//('decreasing');
								xFactor = -1/2;
								yFactor = -1;
								break;
								// increasing
							case -1 :
								//('increasing');
								xFactor = -1/2;
								yFactor = 0;
								break;
								// horizontal
							case 0 :
								//('horizontal');
								xFactor = -1/2;
								yFactor = -1;
								break;
							}
							break;
						}
					}
					// reposition label
					txtLabel._x += xFactor*txtLabel._width;
					txtLabel._y += yFactor*txtLabel._height;
				} else if (chartType == 'AREA') {
					sign = (valueNum>=0) ? -1 : 0;
					// reposition label
					txtLabel._y += sign*txtLabel._height;
					txtLabel._x -= txtLabel._width/2;
				}
			} else {
				// else if label be hidden
				// remove the text field
				mcLabels['label_'+j].removeTextField();
			}
		}
		//if labels be hidden
		if (!showLabels) {
			// remove the MC
			_mc[strLabelMC+seriesId].removeMovieClip();
		}
	}
}
