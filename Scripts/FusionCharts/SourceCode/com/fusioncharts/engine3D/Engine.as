/**
* @class Engine
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Engine class is the primary class and the only one to be 
* instantiated to render the chart and control its 
* interactivity through its public API.
*/
// import the all classes of engine3D package 
import com.fusioncharts.engine3D.*;
// import the Math extension class
import com.fusioncharts.extensions.MathExt;
// import EventDispatcher class
import mx.events.EventDispatcher;
// import Delegate class
import mx.utils.Delegate;
//
// class definition
class com.fusioncharts.engine3D.Engine {
	//----- MovieClip -----//
	// basic container to work in; topmost in hierarchy for the Engine
	private var mcBase:MovieClip;
	// basic container for all renderables
	private var mcHolder:MovieClip;
	// reference of an empty MC for onEnterFrame handler, controlling animations
	private var mcControl:MovieClip;
	// mother container for all data presentation (excluding axes) 
	private var mcData:MovieClip;
	//
	//----- Object -----//
	// chart "Stage" metrics and axes metrics 
	private var objStage:Object;
	// camera orientation (angles)
	private var objCamera:Object;
	// light orientation (angles)
	private var objLight:Object;
	// various types data groups together
	private var objMultiData:Object;
	// animation params
	private var objAnim:Object;
	// params for tLines, hLines and so
	private var objAxesPlus:Object;
	// params for labels of axes labels, tLines and so
	private var objLabels:Object;
	// holds evaluated gap values (like label gaps)
	private var objGaps:Object;
	// text formatting params
	private var objtxtProps:Object;
	// includes axes names
	private var objAxesNames:Object;
	// params for zero plane rendering
	private var objZeroPlane:Object;
	//
	//----- Boolean -----//
	// face be culled or not
	private var faceCulling:Boolean;
	// should multi column series be presented in clustered mode or in overlaid mode
	private var clustered:Boolean;
	// light be fixed to the world or not
	private var worldLighting:Boolean;
	// should axes hGrid be drawn bi-color
	private var showAlternateHGridColor:Boolean;
	// zero plane presence
	private var zeroPlane:Boolean;
	// flag to care if scaling animation is on
	private var scaleAnimOn:Boolean;
	// if data item be bordered
	private var dataPlotBorder:Boolean;
	// flag to note that initial animation is on
	private var iniAnimating:Boolean = false
	//
	//----- Number -----//
	// width of x-axis
	private var xAxisWidth:Number;
	// height of y-axis
	private var yAxisHeight:Number;
	// light intensity control value
	private var lightControl:Number;
	// selective scaling value of chart sub-elements to get 100% size w.r.t. stage
	private var scale100:Number;
	// time taken to render a frame (initially calculated)
	private var renderTime:Number;
	// overall z-stack order shift for chart data items (series depth shift)
	private var depthShift:Number;
	// base color of axes
	private var axesColor:Number;
	// the other color, in case of bi-colored axes
	private var alternateHGridColor:Number;
	//
	//----- String ----//
	// hLine rendering effect
	private var strDivLineEffect:String;
	//
	//----- Array -----//
	// data items in model space (defined)
	private var arrDataModel:Array;
	// data items in world space 
	private var arrDataWorld:Array;
	// data items in view space 
	private var arrDataView:Array;
	//
	// coordinates of the model center
	private var arrModelCenter:Array;
	// series chart types in stack order
	private var arrCategory:Array;
	// series chart (left) origins
	private var arrZOrigins:Array;
	//
	// axesBox vertices (cuboid)
	private var arrAxesWorld:Array;
	// axes walls vertices in world space 
	private var arrAxesWalls:Array;
	//
	// face colors of data items
	private var arrFaceColors:Array;
	// face colors of axesBox (cuboid)
	private var arrAxesPrimeColors:Array;
	// other face colors of axesBox(cuboid), for bi-colored axes
	private var arrAxesAlternateColors:Array;
	// hLine/divLine colors for axesBox
	private var arrAxesHLinesColors:Array;
	// tLine colors for axesBox
	private var arrAxesTLinesColors:Array;
	//
	// axesPlus (tLine, hLine and so) coordinates for axesBox in world space 
	private var arrAxesPlus:Array;
	// axes label (xLabel, yLabel, tLabel) coordinates in world space 
	private var arrAxesLabels:Array;
	// 
	// -- All possible axes face combinations used to store data for quick reference for the following -- //
	// axesplus (tLine, hLine and so) 
	private var arrAxesPlusComb:Array;
	// axes label (xLabel, yLabel, tLabel)
	private var arrAxesLabelsComb:Array;
	// axes walls
	private var arrAxesWallsComb:Array;
	// ---^--- //
	//
	// placement positions of data labels in world space
	private var arrDataLabelsWorld:Array;
	// placement positions of data labels in screen plane
	private var arrDataLabelsScreen:Array;
	// placement positions of axes name labels in world space
	private var arrAxesNamesWorld:Array;
	//
	// valid zero plane vertices in model space (defined)
	private var arrZeroPlanes:Array;
	// zero plane vertices in world space
	private var arrZeroPlanesWorld:Array;
	//
	// surface normal unit vectors of all faces of data items
	private var arrNormals:Array;
	// axes walls thicknesses
	private var arrWallDepths:Array;
	// references of data item MC blocks stored 
	private var arrMcBlocks:Array;
	// z-depths of data items (intra and inter series as well as inter face)
	private var arrDepths:Array;
	// series active for showing data labels
	private var arrActiveDataLabels:Array;
	// all data values in original
	private var arrDataValues:Array;
	// all data labels
	private var arrDataLabels:Array;
	//
	// EventDispatcher members
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	/**
	 *  Engine constructor.
	 * @param		mc						base chart container
	 * @param		objCam					camera angles
	 * @param		objLight				light params
	 * @param		objMultiData			conglomerate of various data
	 * @param		objStage				stage and axes metrics
	 * @param		objAnimation			animation params
	 * @param		objAxesCosmetics		axes cosmetics
	 * @param		objAxesPlus				axesPlus params
	 * @param		objLabels				label params
	 * @param		objtxtProps				text formats
	 * @param		arrDataLabels			data label params
	 * @param		arrDataValues			data values
	 * @param		arrWallDepths			axes wall depths/thicknesses
	 * @param		arrLabelDistances		label gaps from axes edges
	 * @param		objAxesNames			axes names
	 * @param		arrZeroPlanes			zero plane model
	 * @param		objZeroPlane			zero plane params
	 * @param		arrActiveDataLabels		series ids to show labels
	 * @param		objMisc					various params
	 */
	public function Engine(mc:MovieClip, objCam:Object, objLight:Object, objMultiData:Object, objStage:Object, objAnimation:Object, objAxesCosmetics:Object, objAxesPlus:Object, objLabels:Object, objtxtProps:Object, arrDataLabels:Array, arrDataValues:Array, arrWallDepths:Array, arrLabelDistances:Array, objAxesNames:Object, arrZeroPlanes:Array, objZeroPlane:Object, arrActiveDataLabels:Array, objMisc:Object) {
		// EventDispatcher initialised
		EventDispatcher.initialize(this);
		// arguments stored in instance properties
		// reference of base MC to contain everything within it
		this.mcBase = mc;
		// light angles and intensity
		this.objLight = objLight;
		// conglomerate of varied data types
		this.objMultiData = objMultiData;
		// x-axis width
		this.xAxisWidth = objStage.axesWidth;
		// y-axis height
		this.yAxisHeight = objStage.axesHeight;
		// overall chart 'stage' metrics
		this.objStage = objStage;
		// animation params
		this.objAnim = objAnimation;
		// axesplus (tLine, hLine and so) params
		this.objAxesPlus = objAxesPlus;
		// label (xLabel, ylabel, tlabel) params
		this.objLabels = objLabels;
		// label text formatting params
		this.objtxtProps = objtxtProps;
		// zero plane in model space
		this.arrZeroPlanes = arrZeroPlanes;
		// if column data be clustered
		this.clustered = objMisc.clustered;
		// if data item border be shown
		this.dataPlotBorder = objMisc.dataPlotBorder;
		// axes cosmetics and settings stored
		this.axesColor = objAxesCosmetics.axesColor;
		this.alternateHGridColor = objAxesCosmetics.alternateHGridColor;
		this.showAlternateHGridColor = objAxesCosmetics.showAlternateHGridColor;
		this.strDivLineEffect = objAxesCosmetics.divLineEffect;
		// original data values
		this.arrDataValues = arrDataValues;
		// data labels
		this.arrDataLabels = arrDataLabels;
		// series to display data labels
		this.arrActiveDataLabels = arrActiveDataLabels;
		// axes names
		this.objAxesNames = objAxesNames;
		// axes wall depths
		this.arrWallDepths = arrWallDepths;
		// zero plane cosmetics
		this.objZeroPlane = objZeroPlane;
		// lighting mode
		this.worldLighting = this.objLight.worldLighting;
		// data items defined in model space
		this.arrDataModel = this.objMultiData.arrPlot;
		// series chart types in oder of z-stack
		this.arrCategory = this.objMultiData.arrCategory;
		//
		// labels (x/y/tlabels) gaps stored together
		this.objGaps = {};
		// with wall
		this.objGaps.xGap = this.arrWallDepths[0]+arrLabelDistances['ylabelGap'];
		this.objGaps.yGap = this.arrWallDepths[1]+arrLabelDistances['xlabelGap'];
		// without wall
		this.objGaps.xGapNoWall = arrLabelDistances['xlabelGap'];
		this.objGaps.yGapNoWall = arrLabelDistances['ylabelGap'];
		this.objGaps.xAxisNameGap = arrLabelDistances['xAxisNameGap'];
		this.objGaps.yAxisNameGap = arrLabelDistances['yAxisNameGap'];
		//--------------------------//
		// initialise containers
		this.init();
		// initial camera update 
		this.updateCamera(objCam.angX, objCam.angY);
		// checking if zero plane be there
		this.zeroPlane = this.checkZeroPlane(this.arrDataValues);
		// validating the light intensity
		this.lightControl = Light.getLightIntensity(this.objLight.intensity);
		// call to set chart stage for central scaling
		this.setStageForScaling();
		// MC created (will be empty) to control animation
		this.mcControl = this.mcBase.createEmptyMovieClip('controlClip', this.mcBase.getNextHighestDepth());
		//   
		// data container be processed to keep everything ready and generic for chart recreation in different views hereafter
		this.initTransformations();
		// if bright 2D view is opted for
		if (this.objLight.bright2D) {
			// set light to achieve so
			this.setLightForBrighter2D();
		}
	}
	/**
	 * destroy method is called to destroys the engine.
	 */
	public function destroy():Void {
		// clean up data item container
		Render.clearUp(mcHolder, this.arrMcBlocks);
		// clean up base MC for the chart
		for (var i in this.mcBase) {
			// ckecking for MC
			if (this.mcBase[i] instanceof MovieClip) {
				// remove onEnterFrame assigned,if any
				delete this.mcBase[i].onEnterFrame;
				// remove MC
				this.mcBase[i].removeMovieClip();
			}
		}
		// clean up the base MC of the chart itself
		this.mcBase.removeMovieClip();
	}
	/**
	 * init method initialises containers.
	 */
	private function init():Void {
		// flag denoting animation status of chart scaling is set to false initially
		this.scaleAnimOn = false;
		// blank object assigned to store camera angles
		this.objCamera = {};
		// selective scaling value of chart sub-elements initialised to 100
		this.scale100 = 100;
		// overall z-stack order shift for chart data items (series depth shift)
		this.depthShift = 1;
		// face culling is set to true (always)
		this.faceCulling = true;
	}
	/**
	 * initTransformations method sets the engine ready for
	 * chart creation and interactions thereof.
	 */
	private function initTransformations():Void {
		//-------- MODEL ----------//
		// getting model boundary coordinates in 3D model space
		var arrModelBounds:Array = Manager.getModelBounds(this.arrDataModel, this.objAxesPlus, xAxisWidth);
		// coordinates of model center in model space
		this.arrModelCenter = Manager.getModelCenter(arrModelBounds);
		//--------- AXES NAMES ---------//
		// 2D positions of axes names stored in a local variable 
		var arrAxesNamesPlot2DModel:Array = this.objMultiData.arrAxesNamesPlot;
		// respective 3D positions in model space
		var arrAxesNamesPlotModel:Array = Axes.getAxesNamePlots(arrAxesNamesPlot2DModel, arrModelBounds);
		// positions transformed to world space
		this.arrAxesNamesWorld = Transform3D.worldTrans(arrAxesNamesPlotModel, this.arrModelCenter);
		//--------- AXES PLANES ---------//
		// framing 3D axes box in model space
		var arrAxesModel:Array = Axes.getAxes(arrModelBounds);
		// world transformation
		this.arrAxesWorld = Transform3D.worldTrans(arrAxesModel, this.arrModelCenter);
		//-------- AXES BOX WALLS ---------//
		// framing 3D axesBox with thick walls in model space
		var arrAxesWallModel:Array = Axes.getWalls(arrAxesModel, this.arrWallDepths);
		// world transformation
		this.arrAxesWalls = Transform3D.worldTrans(arrAxesWallModel, this.arrModelCenter);
		// mapping axesbox walls w.r.t axes (3) face combinations (total 8)
		this.arrAxesWallsComb = Axes.setAxesWallsData(this.arrAxesWalls);
		//-------- AXESPLUS (HLINE, TLINE, VLINE)---------//
		// framing axesPlus in model space
		var arrAxesPlusModel:Array = Axes.getAxesPlus(this.objAxesPlus, arrModelBounds);
		// blank array assigned to store data after world transformation
		this.arrAxesPlus = [];
		// iterating over different line types
		for (var axesPlusType in arrAxesPlusModel) {
			// world transformation
			this.arrAxesPlus[axesPlusType] = Transform3D.worldTrans(arrAxesPlusModel[axesPlusType], this.arrModelCenter);
		}
		// mapping axesPlus w.r.t axes (3) face combinations (total 8)
		this.arrAxesPlusComb = Axes.setAxesPlusData(this.arrAxesPlus);
		//----------- AXES-LABELS -----------//
		// framing axesLabels positions in model space
		var arrAxesLabelsModel:Array = Axes.getLabels(this.objLabels, arrModelBounds, this.objGaps);
		// blank array assigned to store data after world transformation
		this.arrAxesLabels = [];
		// iterating over different label types
		for (var labelType in arrAxesLabelsModel) {
			// world transformation
			this.arrAxesLabels[labelType] = Transform3D.worldTrans(arrAxesLabelsModel[labelType], this.arrModelCenter);
		}
		// mapping axesLabels w.r.t axes (3) face combinations (total 8)
		this.arrAxesLabelsComb = Axes.setAxesLabelsData(this.arrAxesLabels);
		//---------- ZERO PLANE -------------//
		// zero plane vertices after world transformation
		this.arrZeroPlanesWorld = Transform3D.worldTrans(this.arrZeroPlanes, this.arrModelCenter);
		//----------- DATA-LABELS -----------//
		// data label positions stored in local variable
		var arrDataLabelsModel:Array = this.objMultiData.arrDataLabelsPlot;
		// world transformation
		this.arrDataLabelsWorld = Transform3D.worldTrans(arrDataLabelsModel, this.arrModelCenter);
		//-------------- CHART DATA ----------------//
		// world travsformation of chart data item specific vertices
		this.arrDataWorld = Transform3D.worldTrans(this.arrDataModel, this.arrModelCenter);
		// getting values to help z-sort chart data items
		this.arrZOrigins = Manager.getZOrigins(this.arrDataModel);
		//--------------- LIGHT (WORLD-LIGHTING)---------------//                                                                                                               
		// if light is opted to be fixed to the chart world
		if (this.worldLighting) {
			// tranformation matrix w.r.t. light
			var transMatrixLight = Transform3D.getViewTransMatrix(this.objLight.lightAngX, this.objLight.lightAngY);
			//------- COLORS - DATA OBJECTS' FACES ---------//
			// transformation of data item vertices to light world
			var arrLightView:Array = Transform3D.lightTrans(this.arrDataWorld, transMatrixLight);
			// face colors of objects w.r.t. light intensity and angles
			this.arrFaceColors = Light.getFaceColors(this.objMultiData.arrColors, arrLightView, this.arrCategory, this.lightControl);
			//------- COLORS - AXESBOX FACES & GRIDS ---------//
			// light control for axes elements
			var lightControl:Number = this.lightControl/2;
			// transformation of axes vertices to light world
			var arrAxesLight:Array = Transform3D.lightTrans(this.arrAxesWorld, transMatrixLight);
			// getting the axes face specific color values
			this.arrAxesPrimeColors = Axes.getColors(this.axesColor, arrAxesLight, lightControl);
			// if axes be bi-color
			if (this.showAlternateHGridColor) {
				// getting the axes face specific color values, w.r.t. the other base color
				this.arrAxesAlternateColors = Axes.getColors(this.alternateHGridColor, arrAxesLight, lightControl);
			}
			// getting the axes face specific color values for HLines                                                                                      
			this.arrAxesHLinesColors = Axes.getColors(this.objAxesPlus['HLines'][0]['color'], arrAxesLight, lightControl);
			// getting the axes face specific color values for TLines
			this.arrAxesTLinesColors = Axes.getSeriesColors(this.objAxesPlus['TLines'], arrAxesLight, lightControl);
		} else {
			// else if light is outside the chart world
			// get surface normal unit vectors for all chart data item faces
			this.arrNormals = Light.getNormals(this.arrDataWorld, this.arrCategory);
		}
		// manage depths of axesPlus items like HLines, TLines and VLines
		DepthManager.setAxesPlusdepths(this.objAxesPlus);
	}
	/**
	 * recreate method is the most primary one which
	 * recreates chart.
	 */
	public function recreate():Void {
		// if time requirement for a single frame rendering is not yet available
		if (this.renderTime == undefined) {
			// current time of movie life span in ms
			var now:Number = getTimer();
		}
		// storing data in local variable                                                                                     
		// chart container
		var mcHolder:MovieClip = this.mcHolder;
		// values for screen transformation calculated and stored
		var xAdjust:Number = this.xAxisWidth/2;
		var yAdjust:Number = this.yAxisHeight/2;
		// camera
		var cam:Object = this.objCamera;
		// camera x-angle
		var camAngX:Number = cam.angX;
		// camera y-angle
		var camAngY:Number = cam.angY;
		//
		// storing data in local variable 
		var arrAxesWorld:Array = this.arrAxesWorld;
		var arrDataWorld:Array = this.arrDataWorld;
		var arrCategory:Array = this.arrCategory;
		var arrColors:Array = this.objMultiData.arrColors;
		var objAxesPlus:Object = this.objAxesPlus;
		var faceCulling:Boolean = this.faceCulling;
		var objtxtProps:Object = this.objtxtProps;
		var clustered:Boolean = this.clustered;
		//
		// check to know if the chart is toppled due rotation about x-axis
		var chartToppled:Boolean = this.isChartToppled(camAngX);
		//------------------------------------------//
		// clean up container for next fresh rendering
		Render.clearUp(mcHolder, this.arrMcBlocks);
		// transformation matrix w.r.t. camera
		var transMatrix = Transform3D.getViewTransMatrix(camAngX, camAngY);
		//-----------  AXES NAMES  ----------//
		// world to screen transformation
		var arrAxesNamesScreen:Array = Transform3D.worldToScreenTrans(this.arrAxesNamesWorld, transMatrix, xAdjust, yAdjust);
		//-----------  DATA-LABELS  ----------//
		// Not stored in local variable for it will be used between recreations too, due scaling interactivity.
		// world to screen transformation
		this.arrDataLabelsScreen = Transform3D.worldToScreenTrans(this.arrDataLabelsWorld, transMatrix, xAdjust, yAdjust);
		//------------  AXES PLANES  ------------//
		// view transformation
		var arrAxesView:Array = Transform3D.viewTrans(arrAxesWorld, transMatrix);
		// faces visible in axesBox
		var arrAxesFaces:Array = Axes.getRenderPlanes(arrAxesView);
		// validate axesBox's visible faces  
		this.validateAxesBox(arrAxesFaces, chartToppled);
		// face combination id
		var combId:Number = this.getAxesFaceCombId(arrAxesFaces);
		//------------  AXES WALLS  -------------//
		// container for view transformed
		var arrAxesWalls3D:Array = [];
		// container for screen transformed
		var arrAxesWallsPlots:Array = [];
		// selective vertices w.r.t. visible faces only
		var arrAxesWallsComb:Array = this.arrAxesWallsComb[combId];
		// transforms to both view and screen together (for available array entry only)
		Transform3D.worldToViewAndScreenTrans_entryWise(arrAxesWallsComb, transMatrix, xAdjust, yAdjust, arrAxesWalls3D, arrAxesWallsPlots);
		// getting visible axes wall faces
		var arrAxesWallsFaces:Array = Axes.getRenderAxesWallsFaces(arrAxesWalls3D, arrAxesFaces);
		//-----------  AXES-LABELS  ----------//
		// selective vertices w.r.t. visible faces only
		var arrAxesLabels = this.arrAxesLabelsComb[combId];
		// container for screen transformed
		var arrAxesLabelsScreen:Array = [];
		// iterating over different label types
		for (var labelsType in arrAxesLabels) {
			// world to screen transformation
			arrAxesLabelsScreen[labelsType] = Transform3D.worldToScreenTrans(arrAxesLabels[labelsType], transMatrix, xAdjust, yAdjust);
		}
		//----------  AXESPLUS  -----------//
		// selective vertices w.r.t. visible faces only
		var arrAxesPlus:Array = this.arrAxesPlusComb[combId];
		// container for screen transformed
		var arrAxesPlusScreen:Array = [];
		// iterating over different line types
		for (var axesPlusType in arrAxesPlus) {
			// world to screen transformation (for available array entry only)
			arrAxesPlusScreen[axesPlusType] = Transform3D.worldToScreenTrans_entryWise(arrAxesPlus[axesPlusType], transMatrix, xAdjust, yAdjust);
		}
		//---------- ZERO PLANE -------------//
		// world to screen transformation
		var arrZeroPlanePlots:Array = Transform3D.worldToScreenTrans(this.arrZeroPlanesWorld, transMatrix, xAdjust, yAdjust);
		//----------- CHART DATA ------------//
		// container created for chart data item vertices in view space 
		var arrDataView:Array = this.arrDataView=[];
		// container created for chart data item vertices in screen plane 
		var arr3DPlots:Array = [];
		// transforms to both view and screen together
		Transform3D.worldToViewAndScreenTrans(arrDataWorld, transMatrix, xAdjust, yAdjust, arrDataView, arr3DPlots);
		//---------------- CHART DATA PLUS ------------------//
		// getting the renderable faces of chart data items
		var arrFaces:Array = Manager.getRenderFaces(arrDataView, arrCategory, faceCulling);
		// view transformation of a set of z-origins, each for a chart series, to help inter series depth management 
		var arrZs:Array = Transform3D.viewTrans(this.arrZOrigins, transMatrix);
		// Depth Manager returns the complete z-stack order (series, block, face)
		var arrDepths:Array = this.arrDepths=DepthManager.getDepths(arrDataView, arrFaces, arrZs, arrCategory, clustered, this.depthShift);
		// if zero plane be present
		if (this.zeroPlane) {
			// ask depth manager to rearrange depths to accomodate the zero plane
			DepthManager.setZeroPlane(arrDepths, this.arrDataValues, camAngX, arrCategory, clustered);
		}
		//--------------- LIGHT ---------------//                                                                         
		// container for colors of axes walls, tLines, HLines and so on
		var arrAxesColors:Array = [];
		// container for data item face colors
		var arrFaceColors:Array;
		//------- NON-WORLD LIGHTING -------//
		// light intensity halved for axesBox
		var lightControl:Number = this.lightControl/2;
		var objLight:Object = this.objLight;
		// if world lighting is not opted, then get colors calculated for all renderable faces
		if (!this.worldLighting) {
			// transformation matrix w.r.t light world
			var transMatrixLight = Transform3D.getViewTransMatrix(objLight.lightAngX, objLight.lightAngY);
			//------- COLORS - DATA ITEM FACES ---------//
			// getting data item face colors using surface normals
			arrFaceColors = Light.getFaceColorsUsingNormals(this.arrNormals, arrColors, lightControl*2, arrFaces, transMatrixLight);
			//------- COLORS - AXESBOX FACES & GRIDS ---------//
			// axes world vertices transformed in light world space
			var arrAxesLight:Array = Transform3D.lightTrans(arrAxesWorld, transMatrixLight);
			// axes face colors
			arrAxesColors['color'] = Axes.getColors(this.axesColor, arrAxesLight, lightControl);
			// for bi-colored HGrid
			if (this.showAlternateHGridColor) {
				// the other color for axes faces
				arrAxesColors['otherColor'] = Axes.getColors(this.alternateHGridColor, arrAxesLight, lightControl);
			}
			// HLines colors for axes faces; will have a uniform color for all, so [0] used                                                                                                                                              
			arrAxesColors['HLines'] = Axes.getColors(objAxesPlus['HLines'][0]['color'], arrAxesLight, lightControl);
			// TLine colors for axes faces
			arrAxesColors['TLines'] = Axes.getSeriesColors(objAxesPlus['TLines'], arrAxesLight, lightControl);
			//
		} else {
			//------- WORLD LIGHTING -------//
			// No need to recalculate face colors, since light is fixed to the chart world.
			//------- COLORS - DATA ITEM FACES ---------//
			// reference of colors calculated once initially
			arrFaceColors = this.arrFaceColors;
			//------- COLORS - AXESBOX FACES & GRIDS ---------//
			// reference of axes face colors
			arrAxesColors['color'] = this.arrAxesPrimeColors;
			// for bi-colored HGrid
			if (this.showAlternateHGridColor) {
				// reference of the other color for axes faces
				arrAxesColors['otherColor'] = this.arrAxesAlternateColors;
			}
			// reference of HLines colors for axes faces                                                                         
			arrAxesColors['HLines'] = this.arrAxesHLinesColors;
			// reference of TLine colors for axes faces
			arrAxesColors['TLines'] = this.arrAxesTLinesColors;
		}
		//---------------- RENDERING --------------------//
		// create container for drawing axesBox
		var mcAxes:MovieClip = Render.createMcAxes(mcHolder);
		// create container for drawing chart data items
		var mcData:MovieClip = this.mcData=Render.createMcData(mcHolder);
		// render axesBox with category labels, hLines, tLines, VLines, alternate color grid etc.
		Render.renderAxes(mcAxes, arrAxesFaces, arrAxesWallsPlots, arrAxesWallsFaces, arrAxesColors, arrAxesPlusScreen, objAxesPlus, arrAxesLabelsScreen, arrAxesNamesScreen, this.objLabels, objtxtProps, chartToppled, showAlternateHGridColor, this.strDivLineEffect, this.objAxesNames, cam);
		// render data objects while returning references of MCs denoting data items
		this.arrMcBlocks = Render.renderObj(mcData, arr3DPlots, arrDepths, arrFaceColors, arrFaces, arrCategory, arrZeroPlanePlots, this.objZeroPlane, this.dataPlotBorder);
		// rendering data labels, all those need be visible
		Render.renderDataLabels(mcData, this.arrDataLabelsScreen, this.arrDataLabels, objtxtProps['DATAVALUES'], arrDepths, this.arrActiveDataLabels, arrColors, arrCategory);
		//-------------- POST-RENDER ADJUSTMENTS ---------------//
		// scale up/down all labels to always be in 100% size, irrespective of chart as a whole scaled up/down.
		Render.resetLabels(this.mcBase, this.scale100);
		// if time requirement for a single frame rendering is not yet available
		if (this.renderTime == undefined) {
			// calculate and store
			this.renderTime = getTimer()-now;
		}
	}
	/**
	 * iniAnimate method is called to execute initial 
	 * animation.
	 */
	public function iniAnimate():Void {
		// values for screen transformation calculated and stored
		var xAdjust:Number = this.xAxisWidth/2;
		var yAdjust:Number = this.yAxisHeight/2;
		// light intensity halved for axesBox
		var lightControl:Number = this.lightControl/2;
		// includes animation params
		var objAnim:Object = this.objAnim;
		// initial animation start angles are set to camera angles initially
		var camAngX:Number = objAnim.startAngX;
		var camAngY:Number = objAnim.startAngY;
		// storing data in local variables 
		var objLight:Object = this.objLight;
		var arrAxesWorld:Array = this.arrAxesWorld;
		var objAxesPlus:Object = this.objAxesPlus;
		var objtxtProps:Object = this.objtxtProps;
		// camera angles updated to animation starting angles
		this.updateCamera(camAngX, camAngY);
		// check to see if chart is toppled
		var chartToppled:Boolean = this.isChartToppled(camAngX);
		// axesBox is applied an extra border for the special case of rotation about y-axis is zero
		var axesBoxBorder:Boolean = (camAngY == 0) ? true : false;
		// transformation matrix w.r.t. camera
		var transMatrix = Transform3D.getViewTransMatrix(camAngX, camAngY);
		//-----------  AXES NAMES  ----------//
		// world to screen transformation
		var arrAxesNamesScreen:Array = Transform3D.worldToScreenTrans(this.arrAxesNamesWorld, transMatrix, xAdjust, yAdjust);
		//------------  AXES PLANES  ------------//
		// view transformation of axes box defining vertices 
		var arrAxesView:Array = Transform3D.viewTrans(arrAxesWorld, transMatrix);
		// getting visible faces of a virtual axesBox; thick walls for this faces will be shown
		var arrAxesFaces:Array = Axes.getRenderPlanes(arrAxesView);
		// validate axesBox's visible faces 
		this.validateAxesBox(arrAxesFaces, chartToppled);
		//------------  AXES WALLS  -------------//
		// face combination id
		var combId:Number = this.getAxesFaceCombId(arrAxesFaces);
		// container for vertices of axes walls in view space
		var arrAxesWalls3D:Array = [];
		// container for vertices of axes walls in screen plane
		var arrAxesWallsPlots:Array = [];
		// selective vertices w.r.t. visible faces only
		var arrAxesWallsComb:Array = this.arrAxesWallsComb[combId];
		// transforms to both view and screen together (for available array entry only)
		Transform3D.worldToViewAndScreenTrans_entryWise(arrAxesWallsComb, transMatrix, xAdjust, yAdjust, arrAxesWalls3D, arrAxesWallsPlots);
		// getting visible axes wall faces
		var arrAxesWallsFaces:Array = Axes.getRenderAxesWallsFaces(arrAxesWalls3D, arrAxesFaces);
		//-----------  AXES-LABELS  ----------//
		// selective vertices w.r.t. visible faces only
		var arrAxesLabels = this.arrAxesLabelsComb[combId];
		// container for screen transformed
		var arrAxesLabelsScreen:Array = [];
		// iterating over different label types
		for (var labelsType in arrAxesLabels) {
			// world to screen transformation
			arrAxesLabelsScreen[labelsType] = Transform3D.worldToScreenTrans(arrAxesLabels[labelsType], transMatrix, xAdjust, yAdjust);
		}
		//----------  AXESPLUS  -----------//
		// selective vertices w.r.t. visible faces only
		var arrAxesPlus:Array = this.arrAxesPlusComb[combId];
		// container for screen transformed
		var arrAxesPlusScreen:Array = [];
		// iterating over different line types
		for (var axesPlusType in arrAxesPlus) {
			// world to screen transformation (for available array entry only)
			arrAxesPlusScreen[axesPlusType] = Transform3D.worldToScreenTrans_entryWise(arrAxesPlus[axesPlusType], transMatrix, xAdjust, yAdjust);
		}
		//--------------- LIGHT ---------------//
		// container for colors of axes walls, tLines, HLines and so on
		var arrAxesColors:Array = [];
		//------- NON-WORLD LIGHTING -------//
		// if world lighting is not opted, then get colors calculated for all renderable faces
		if (!this.worldLighting) {
			// transformation matrix w.r.t. light world
			var transMatrixLight = Transform3D.getViewTransMatrix(objLight.lightAngX, objLight.lightAngY);
			//------- COLORS - AXESBOX FACES & GRIDS ---------//
			// axes world vertices transformed in light world space
			var arrAxesLight:Array = Transform3D.lightTrans(arrAxesWorld, transMatrixLight);
			// axes face colors
			arrAxesColors['color'] = Axes.getColors(this.axesColor, arrAxesLight, lightControl);
			// for bi-colored HGrid
			if (this.showAlternateHGridColor) {
				// the other color for axes faces
				arrAxesColors['otherColor'] = Axes.getColors(this.alternateHGridColor, arrAxesLight, lightControl);
			}
			// HLines colors for axes faces; will have a uniform color for all, so [0] used                                                                       
			arrAxesColors['HLines'] = Axes.getColors(objAxesPlus['HLines'][0]['color'], arrAxesLight, lightControl);
			// TLine colors for axes faces
			arrAxesColors['TLines'] = Axes.getSeriesColors(objAxesPlus['TLines'], arrAxesLight, lightControl);
		} else {
			//------- WORLD LIGHTING -------//
			// No need to recalculate face colors, since light is fixed to the chart world.
			//------- COLORS - AXESBOX FACES & GRIDS ---------//
			// reference of axes face colors
			arrAxesColors['color'] = this.arrAxesPrimeColors;
			// for bi-colored HGrid
			if (this.showAlternateHGridColor) {
				// reference of the other color for axes faces
				arrAxesColors['otherColor'] = this.arrAxesAlternateColors;
			}
			// reference of HLines colors for axes faces                                                                         
			arrAxesColors['HLines'] = this.arrAxesHLinesColors;
			// reference of TLine colors for axes faces
			arrAxesColors['TLines'] = this.arrAxesTLinesColors;
		}
		//---------------------//
		// render the blank axes box first .. without axesPlus (x/y/t-lines) and labels; returning MC paths for further work
		var objMcRefs:Object = Render.drawAxesBox(this.mcHolder, arrAxesFaces, arrAxesWallsPlots, arrAxesWallsFaces, arrAxesColors['color'], axesBoxBorder);
		//
		// path of axesBox MC
		var mcAxesBox:MovieClip = objMcRefs['mcAxes'];
		// path of x-axis name MC
		var mcXAxisName:MovieClip = objMcRefs['mcXAxisNameLabel'];
		// path of y-axis name MC
		var mcYAxisName:MovieClip = objMcRefs['mcYAxisNameLabel'];
		//
		// set opacity of the whole chart to zero, only to fade-in to 100% opacity
		this.mcBase._alpha = 0;
		// numeric animation status; help in creating intermediate animation steps
		var animRatio:Number = 0;
		// flag to be updated to go for data items animation
		var startDataAnim:Boolean = false;
		// animate to best fit in chart stage
		this.scaleToFit();
		// reference of Engine instance
		var thisRef:Engine = this;
		// empty MC created to control and execute animation
		var mcCtrlTemp:MovieClip = this.mcControl._parent.createEmptyMovieClip('mcCtrlTemp', this.mcControl._parent.getNextHighestDepth());
		// animation programmed
		mcCtrlTemp.onEnterFrame = function() {
			if (thisRef.mcBase._alpha<100) {
				// opacity increased in steps
				thisRef.mcBase._alpha += 10;
			} else {
				// if axesPlus (x/y/t-line) animation is incomplete
				if (animRatio<1) {
					// next stage in the animation be on
					animRatio += 0.1;
					// call to render axesPlus in the next unfolding status
					Render.initAxesPlus(mcAxesBox, arrAxesFaces, arrAxesPlusScreen, objAxesPlus, thisRef.showAlternateHGridColor, arrAxesColors, thisRef.strDivLineEffect, animRatio);
				} else {
					// if axesPlus animation is complete:
					// if axes labels and axes names are yet not rendered
					if (!startDataAnim) {
						// the very next phase is to go for data item animation
						startDataAnim = true;
						// show axes labels; scope of action for the next call to show axes names is returned
						var objAxesNamesParams:Object = Render.initAxesLabels(mcAxesBox, arrAxesLabelsScreen, thisRef.objLabels, objtxtProps, arrAxesNamesScreen, arrAxesFaces);
						// show axes names
						Render.initAxesNames(mcAxesBox, mcXAxisName, mcYAxisName, arrAxesNamesScreen, thisRef.objAxesNames, objAxesNamesParams, chartToppled, objtxtProps);
						// labels reset for chart (rather, axesBox) is in best fit status
						Render.resetLabels(thisRef.mcBase, thisRef.scale100);
					} else {
						// proceed for data item animation
						thisRef.initChartAnim();
						// clear the animation program
						delete this.onEnterFrame;
						// delete the temporary MC - control job done
						this.removeMovieClip();
					}
				}
			}
		};
	}
	/**
	 * initChartAnim method is called from iniAnimate
	 * method to progress for data item animation.
	 */
	private function initChartAnim():Void {
		// referenced in local variables
		var arrDataModel:Array = this.arrDataModel;
		var objLight:Object = this.objLight;
		var arrCategory:Array = this.arrCategory;
		var mcControl:MovieClip = this.mcControl;
		var arrModelCenter:Array = this.arrModelCenter;
		var objAnim:Object = this.objAnim;
		var mcHolder:MovieClip = this.mcHolder;
		var faceCulling:Boolean = this.faceCulling;
		var clustered:Boolean = this.clustered;
		var dataPlotBorder:Boolean = this.dataPlotBorder;
		// values for screen transformation calculated and stored
		var xAdjust:Number = this.xAxisWidth/2;
		var yAdjust:Number = this.yAxisHeight/2;
		// camera angles
		var camAngX:Number = this.objCamera.angX;
		var camAngY:Number = this.objCamera.angY;
		// getting the extreme y values 
		var objYMinMax:Object = Manager.getDataModelYMinMax(arrDataModel);
		// 
		var absDelY:Number, animSteps:Number, timeLeft:Number, averageTime:Number;
		// exeTime in milliseconds
		var exeTime:Number = Math.round(objAnim.exeTime*1000);
		//------------------------------------------//
		// starting time
		var t1:Number = getTimer();
		// growth in Y achieved
		var doneY:Number = 0;
		// full growth in Y to be achieved
		var fullY:Number = Math.max(Math.abs(objYMinMax.minY), Math.abs(objYMinMax.maxY));
		// local function to set params for next step in animation
		var setForNextStep:Function = function () {
			// time elasped
			var t:Number = getTimer()-t1;
			// staring rendering time to be considered
			t *= (doneY == 0) ? 0.25 : 1;
			// time left over
			timeLeft = exeTime-t;
			// average time taken per step/frame upto now 
			averageTime = t/animStepsOver;
			// total number of steps that should be required to execute the animation in this current rate
			var stepsLeft = Math.floor(timeLeft/Math.abs(averageTime));
			animSteps = animStepsOver+stepsLeft;
			// increment per step for the remaining steps
			absDelY = (fullY-doneY)/stepsLeft;
		};
		//------------------------------------------//
		// tranformation matrix w.r.t. camera
		var transMatrix = Transform3D.getViewTransMatrix(camAngX, camAngY);
		//----------- CHART DATA ------------//
		// Get the final data model, to evaluate face colors, manage depths and so on.
		// There are 4 entries per vertex viz. (x, y, z, yOriginal) to be used in executing animation.
		// This is actually the clone of basic data model with the fourth entry added per vertex.
		// Henceforth, all changes in "y" per vertex to be done in this array itself using the fourth entry.
		var arrDataModel:Array = Model.getDataModel(arrDataModel);
		// transformation to view space (four entry won't be transformed and returned, since transformation methods 
		// use indexed array data while the fourth one is kept associated)
		var arrDataView:Array = Transform3D.modelToViewTrans(arrDataModel, arrModelCenter, transMatrix);
		//------- NON-WORLD LIGHTING -------//
		// if non-world lighting is opted for
		if (!this.worldLighting) {
			// transformation matrix w.r.t. light world
			var transMatrixLight = Transform3D.getViewTransMatrix(objLight.lightAngX, objLight.lightAngY);
			// transformation to light space
			var arrLightView:Array = Transform3D.lightTrans(this.arrDataWorld, transMatrixLight);
			// face colors evaluated
			var arrFaceColors:Array = Light.getFaceColors(this.objMultiData.arrColors, arrLightView, arrCategory, this.lightControl);
			//------- WORLD LIGHTING -------//
		} else {
			// for world lighting .. refer to face colors evaluated once initially 
			var arrFaceColors:Array = this.arrFaceColors;
		}
		//---------- ZERO PLANE -------------//
		// world to screen transformation
		var arrZeroPlanePlots:Array = Transform3D.worldToScreenTrans(this.arrZeroPlanesWorld, transMatrix, xAdjust, yAdjust);
		//---------------- CHART DATA PLUS ------------------//
		// getting the renderable faces of chart data items
		var arrFaces:Array = Manager.getRenderFaces(arrDataView, arrCategory, faceCulling);
		// view transformation of a set of z-origins, each for a chart series, to help inter series depth management 
		var arrZs:Array = Transform3D.viewTrans(this.arrZOrigins, transMatrix);
		// Depth Manager returns the complete z-stack order (series, block, face)
		var arrDepths:Array = DepthManager.getDepths(arrDataView, arrFaces, arrZs, arrCategory, clustered, this.depthShift);
		// if zero plane be present
		if (this.zeroPlane) {
			// ask depth manager to rearrange depths to accomodate the zero plane
			DepthManager.setZeroPlane(arrDepths, this.arrDataValues, camAngX, arrCategory, clustered);
		}
		// ------------- DATA LABELS ------------ //                                                         
		// world to screen transformation 
		var arrDataLabelsScreen:Array = Transform3D.worldToScreenTrans(this.arrDataLabelsWorld, transMatrix, xAdjust, yAdjust);
		//-----------------------------------------------------------//                                                                                                                                                                  
		var arrDataPlots:Array;
		// create container for drawing chart data items
		var mcData:MovieClip = this.mcData=Render.createMcData(mcHolder);
		// local reference of "this"
		var thisRef:Engine = this;
		// counter to track the number of steps over for initial data item animation; initialised to -1 to execute 2 more steps before data animaation proceeds
		var animStepsOver:Number = -1;
		// creation flag initialised  to false
		var created:Boolean = false;
		// empty Mc created to control the animation
		var mcCtrlTemp:MovieClip = mcControl._parent.createEmptyMovieClip('mcCtrlDataTemp', mcControl._parent.getNextHighestDepth());
		// initial animation phase tracker
		var phaseTracker:Number = 0;
		// animation programmed
		mcCtrlTemp.onEnterFrame = function() {
			// if animation process is yet to start
			if (animStepsOver == -1) {
				if (phaseTracker == 1) {
					// call the local function to set params for next step
					setForNextStep();
				}  
				phaseTracker++;
				// collapsed data items created and fade-in effect applied
				if (!created) {
					// set 'y' of data model vertices for initial collapsed state
					Model.setIniDataModel(arrDataModel);
					// transformed to screen plane
					arrDataPlots = Transform3D.modelToScreenTrans(arrDataModel, arrModelCenter, transMatrix, xAdjust, yAdjust);
					arrDataView = Transform3D.modelToViewTrans(arrDataModel, arrModelCenter, transMatrix);
					// getting the renderable faces of chart data items
					arrFaces = Manager.getRenderFaces(arrDataView, arrCategory, faceCulling);
					// Depth Manager returns the complete z-stack order (series, block, face)
					arrDepths = DepthManager.getDepths(arrDataView, arrFaces, arrZs, arrCategory, clustered, thisRef.depthShift);
					// if zero plane be present
					if (thisRef.zeroPlane) {
						// ask depth manager to rearrange depths to accomodate the zero plane
						DepthManager.setZeroPlane(arrDepths, thisRef.arrDataValues, camAngX, arrCategory, clustered);
					}
					// collapsed data items created    
					Render.renderObj(mcData, arrDataPlots, arrDepths, arrFaceColors, arrFaces, arrCategory, arrZeroPlanePlots, thisRef.objZeroPlane, dataPlotBorder);
					// opacity set to zero - invisible after creation
					mcData._alpha = 0;
					// creation flag updated
					created = true;
				} else {
					// opacity incremented                                                      
					mcData._alpha += 10;
					// if fade-in over
					if (mcData._alpha>=100) {
						// update counter to indicate the fade-in step completion
						animStepsOver++;
					}
					//                                                                                                                                                                                                                                                                                                                     
				}
			} else {
				if (animStepsOver == 0) {
					t1 = getTimer();
				}
				animStepsOver++;
				// if more steps left to finish the animation
				if (animStepsOver<=animSteps) {
					// starting time (of this frame/step) recorded
					// removing all MC before next rendering proceeds
					for (var i in mcData) {
						if (mcData[i] instanceof MovieClip) {
							mcData[i].removeMovieClip();
						}
					}
					// set 'y' of data model vertices for next growth state of data items
					Model.setNextDataModel(arrDataModel, absDelY);
					doneY += absDelY;
					// create container for drawing chart data items
					mcData = thisRef.mcData=Render.createMcData(mcHolder);
					// transformed to screen plane
					arrDataPlots = Transform3D.modelToScreenTrans(arrDataModel, arrModelCenter, transMatrix, xAdjust, yAdjust);
					arrDataView = Transform3D.modelToViewTrans(arrDataModel, arrModelCenter, transMatrix);
					// getting the renderable faces of chart data items
					arrFaces = Manager.getRenderFaces(arrDataView, arrCategory, faceCulling);
					// Depth Manager returns the complete z-stack order (series, block, face)
					arrDepths = DepthManager.getDepths(arrDataView, arrFaces, arrZs, arrCategory, clustered, thisRef.depthShift);
					// if zero plane be present
					if (thisRef.zeroPlane) {
						// ask depth manager to rearrange depths to accomodate the zero plane
						DepthManager.setZeroPlane(arrDepths, thisRef.arrDataValues, camAngX, arrCategory, clustered);
					}
					// data items created to reflect next growth state in animation    
					Render.renderObj(mcData, arrDataPlots, arrDepths, arrFaceColors, arrFaces, arrCategory, arrZeroPlanePlots, thisRef.objZeroPlane, dataPlotBorder);
					// time taken in ms to render this frame/step
					// call the local function to set the incrementing value for 'y' to get the next growth state
					setForNextStep();
					// check growth state to show data labels
					if (animStepsOver == animSteps) {
						// show data labels
						Render.renderDataLabels(mcData, arrDataLabelsScreen, thisRef.arrDataLabels, thisRef.objtxtProps['DATAVALUES'], arrDepths, thisRef.arrActiveDataLabels, thisRef.objMultiData.arrColors, arrCategory);
						// reset scaling of labels
						Render.resetLabels(thisRef.mcBase, thisRef.scale100);
					}
				} else {
					// container to encapsulate rotational animation params 
					var objAnimation:Object = {};
					// execution time
					objAnimation.exeTime = objAnim.exeTime;
					// starting angles not to be provided; means will take up current camera angles
					objAnimation.startAngX = null;
					objAnimation.startAngY = null;
					// rotational ending angles
					objAnimation.endAngX = objAnim.endAngX;
					objAnimation.endAngY = objAnim.endAngY;
					// if starting and ending angles are not equal
					if (this.objCamera.xAng != objAnim.endAngX || this.objCamera.yAng != objAnim.endAngY) {
						// call to animate the chart to the required ending angles
						thisRef.iniAnimating = true
						thisRef.animate(objAnimation);
					} else {
						// else, don't animate
						// dispatch event for initial animation end
						this.dispatchEvent({target:this, type:'iniAnimated'});
					}
					// animation program ends and hence deleted
					delete this.onEnterFrame;
					// controlling MC no more required and removed
					this.removeMovieClip();
				}
			}
		};
	}
	/**
	 * animate method is called to animate from current angles
	 * to specified ones.
	 * @param		objAnim		animation params
	 * @return					last camera angles prior to animation.
	 */
	public function animate(objAnim:Object):Object {
		
		// local references
		var UM:Function = MathExt.minimiseAngle;
		var UR:Function = MathExt.roundUp;
		var objCam:Object = this.objCamera;
		// starting angles recorded to be returned at function end
		var objStartAngs:Object = {xAng:objCam.angX, yAng:objCam.angY};
		// start angles
		objAnim.startAngX = (objAnim.startAngX == null) ? objCam.angX : objAnim.startAngX;
		objAnim.startAngY = (objAnim.startAngY == null) ? objCam.angY : objAnim.startAngY;
		// camara update w.r.t. start angles
		this.updateCamera(objAnim.startAngX, objAnim.startAngY);
		// if time to render a single frame is yet to be known
		if (this.renderTime == undefined) {
			// start knowing it
			var startTime:Number = getTimer();
			// for chart with initial animation enabled; may delay animation for huge dataset
			this.recreate();
			// time taken to render a frame
			var timetaken:Number = getTimer()-startTime;
		} else {
			// time taken to render a frame (if known)
			var timetaken:Number = this.renderTime;
		}
		// get the number of steps in which to distribute the animation steps so as to maintain the execution time specified (approximately)
		var steps:Number = this.getAnimSteps(timetaken, objAnim.exeTime);
		// animation state counter
		var counter:Number = 0;
		// total (minimum) change in angles per step
		var dAngX:Number = UR(UM(objAnim.endAngX-objAnim.startAngX)/steps);
		var dAngY:Number = UR(UM(objAnim.endAngY-objAnim.startAngY)/steps);
		// 
		var diffAngX:Number, diffAngY:Number;
		// local reference of 'this'
		var thisRef:Engine = this;
		// removing any pre-existing animation program
		delete this.mcControl.onEnterFrame;
		// animation programmed
		this.mcControl.onEnterFrame = function() {
			
			// animation step updated
			counter++;
			// difference in current camera angles from the final ones
			diffAngX = UR(UM(objAnim.endAngX-objCam.angX));
			diffAngY = UR(UM(objAnim.endAngY-objCam.angY));
			// if difference in angles calculated above is more than incrementing values
			if ((Math.abs(diffAngX)>Math.abs(dAngX) || Math.abs(diffAngY)>Math.abs(dAngY)) && steps>counter) {
				// update camera angles by incrementing values
				thisRef.updateCameraBy(dAngX, dAngY);
				// for non-world lighting
				if (!thisRef.worldLighting) {
					// update light angles too
					thisRef.updateLightBy(dAngX, dAngY);
				}
				// fresh recreation of chart to present the next animation state w.r.t. view angles                                                      
				thisRef.recreate();
			} else {
				// else, if difference in current camera angles from final ones is less than or 
				// equal to incrementing values:
				// simply set camera angles to final ones
				thisRef.updateCamera(objAnim.endAngX, objAnim.endAngY);
				// for non-world lighting
				if (!thisRef.worldLighting) {
					// update light angles too
					thisRef.updateLightBy(diffAngX, diffAngY);
				}
				// fresh recreation of chart to present the final view                                                     
				thisRef.recreate();
				// job of animation programm over
				delete this.onEnterFrame;
				// set the Event name
				if(thisRef.iniAnimating){
					var strEventName:String = 'iniAnimated'
					thisRef.iniAnimating = false
				} else {
					var strEventName:String = 'animated'
				}
				// dispatch to notify the event of animation end
				thisRef.dispatchEvent({target:thisRef, type:strEventName});
			}
		};
		// return animation starting angles
		return objStartAngs;
	}
	/**
	 * getAbsDelY method is called to return increment in 'y' 
	 * value during animation.
	 * @param		objYMinMax		extremes of Y in the data model
	 * @param		steps			total number of steps
	 * @return						increment for Y
	 */
	private function getAbsDelY(objYMinMax:Object, steps:Number):Number {
		// local reference
		var ABS:Function = Math.abs;
		// greater of the 2 absolute extreme values for data 'y'
		var yAbsMax:Number = Math.max(ABS(objYMinMax.minY), ABS(objYMinMax.maxY));
		// absolute and rounded resultant
		var absDelY:Number = Math.ceil(ABS(yAbsMax/steps));
		// return
		return absDelY;
	}
	/**
	 * checkZeroPlane method returns to whether zero plane be 
	 * there in the chart.
	 * @param		arrDataValues		data item values
	 * @return							whether to render zero plane
	 */
	private function checkZeroPlane(arrDataValues:Array):Boolean {
		// flags initialised
		var positive:Boolean = false;
		var negative:Boolean = false;
		// 
		var num:Number, num1:Number, arrX_i:Array;
		// array length
		num = arrDataValues.length;
		// iterating over datasets
		for (var i = 0; i<num; ++i) {
			// sub-array reference
			arrX_i = arrDataValues[i];
			// sub-array length
			num1 = arrX_i.length;
			// iterating within a dataset
			for (var j = 0; j<num1; ++j) {
				if (arrX_i[j]<0) {
					// if negative, update flag
					negative = true;
				} else if (arrX_i[j]>0) {
					// if positive, update flag
					positive = true;
				}
				// if negative and positive are both found                                                     
				if (positive && negative) {
					// zero plane be there
					return true;
				}
			}
		}
		// function body ends .. yet positive and negative not both found ... so no zero plane
		return false;
	}
	/**
	 * isChartToppled method returns as to whether the chart 
	 * is currently in toppled status.
	 * @param		ang		camera x angle
	 * @return				is chart toppled
	 */
	private function isChartToppled(ang:Number):Boolean {
		// bounding the angle within 0 to 360 degree
		var angBound:Number = MathExt.boundAngle(ang);
		// chart toppled if the angle > 90 and < 270
		return (angBound<=90 || angBound>=270) ? false : true;
	}
	/**
	 * handleLabelsOf method is called to handle legend
	 * clicking interactivity.
	 * @param		id		series id to toggle its label display
	 */
	public function handleLabelsOf(id:Number):Void {
		// flag to show labels for the specific series is initialised to true
		var showLabels:Boolean = true;
		// local reference
		var arrX:Array = this.arrActiveDataLabels;
		// array length
		var num:Number = arrX.length;
		// iterating over only those series which are already displaying labels
		for (var i = 0; i<num; ++i) {
			// if id of series passed as param is already showing labels
			if (arrX[i] == id) {
				// hide labels for the series, flag updated to false
				showLabels = false;
				// remove the series id entry from record
				arrX.splice(i, 1);
				// iteration requirement over
				break;
			}
		}
		// if labels be shown
		if (showLabels) {
			// add the series id entry in the record
			arrX.push(id);
		}
		// local reference                                                                                                                                                                   
		var objX:Object = this.objMultiData;
		// border color of label box
		var borderColor:Number = objX.arrColors[id][0];
		// chart type
		var chartType:String = objX.arrCategory[id];
		//
		// call to show/hide the labels for the required series
		Render.renderDataLabelsOf(this.mcData, this.arrDataLabelsScreen, this.arrDataLabels, this.objtxtProps['DATAVALUES'], this.arrDepths, id, showLabels, borderColor, chartType);
		// reset scaling of labels
		Render.resetLabels(this.mcBase, this.scale100);
	}
	/**
	 * setLightForBrighter2D method is called to reset light 
	 * angles so as to have bright 2D view.
	 */
	public function setLightForBrighter2D():Void {
		// ----- light to be alligned to the view port ----- //
		// for non-world lighting
		if (!this.worldLighting) {
			// difference between camera and light angles
			var delAngX:Number = MathExt.minimiseAngle(this.objCamera.angX-this.objLight.lightAngX);
			var delAngY:Number = MathExt.minimiseAngle(this.objCamera.angY-this.objLight.lightAngY);
			// light angles updated 
			this.updateLightBy(delAngX, delAngY);
		}
	}
	/**
	 * getMcBlocks method returns set of movieclips
	 * responsible for chart interactivity.
	 * @return			set of MCs
	 */
	public function getMcBlocks():Array {
		// movieClip reference of data item blocks ... for tooltip functionality
		return this.arrMcBlocks;
	}
	/**
	 * getCameraAngs method returns current camera angles.
	 * @return			camera angles
	 */
	public function getCameraAngs():Object {
		// camera angles
		return {xAng:this.objCamera.angX, yAng:this.objCamera.angY};
	}
	/**
	 * updateCamera method is called to update chart camera
	 * angles to the specified angles.
	 * @param		angX	new x angle
	 * @param		angY	new y angle
	 */
	public function updateCamera(angX:Number, angY:Number):Void {
		// local references
		var UR:Function = MathExt.roundUp;
		var MR:Function = Math.round;
		var ABS:Function = Math.abs;
		var objCam:Object = this.objCamera;
		// setting camera angles
		objCam.angX = (angX != undefined) ? angX : objCam.angX;
		objCam.angY = (angY != undefined) ? angY : objCam.angY;
		// rounding angles to 2 decimals places (default)
		objCam.angX = UR(objCam.angX);
		objCam.angY = UR(objCam.angY);
		// -- special care for camera angles near 90 and -90 degrees -- //
		// if x-angle close to 90 degree
		if (ABS(MR(objCam.angX)) == 90) {
			// round up to 90 or -90 as the case may be
			objCam.angX = MR(objCam.angX);
		}
		// if y-angle close to 90 degree                                                    
		if (ABS(MR(objCam.angY)) == 90) {
			// round up to 90 or -90 as the case may be
			objCam.angY = MR(objCam.angY);
		}
		//                                                                                                                                                                                                                                                                                                                                                         
	}
	/**
	 * updateCameraBy method is called to update chart camera
	 * angles by the specified amounts.
	 * @param		delAngX		change in x angle
	 * @param		delAngY		change in y angle
	 */
	public function updateCameraBy(delAngX:Number, delAngY:Number):Void {
		// local references
		var UR:Function = MathExt.roundUp;
		var MR:Function = Math.round;
		var ABS:Function = Math.abs;
		var objCam:Object = this.objCamera;
		// incrementing camera angles
		objCam.angX += delAngX;
		objCam.angY += delAngY;
		// rounding angles to 2 decimals places (default)
		objCam.angX = UR(objCam.angX);
		objCam.angY = UR(objCam.angY);
		// -- special care for camera angles near 90 and -90 degrees -- //
		// if x-angle close to 90 degree
		if (ABS(MR(objCam.angX)) == 90) {
			// round up to 90 or -90 as the case may be
			objCam.angX = MR(objCam.angX);
		}
		// if y-angle close to 90 degree                                                   
		if (ABS(MR(objCam.angY)) == 90) {
			// round up to 90 or -90 as the case may be
			objCam.angY = MR(objCam.angY);
		}
	}
	/**
	 * updateLightBy method is called to update light angles
	 * by the specified amounts.
	 * @param		delAngX		change in x angle
	 * @param		delAngY		change in y angle
	 */
	public function updateLightBy(delAngX:Number, delAngY:Number):Void {
		// local reference of light object
		var objLight:Object = this.objLight;
		// incrementing light angles
		objLight.lightAngX += delAngX;
		objLight.lightAngY += delAngY;
	}
	/**
	 * scale method is called to scale the chart by an amount.
	 * @param		percentValue	change in scale value
	 * @param		scrolling		if scaling is due mouse scrolling
	 */
	public function scale(percentValue:Number, scrolling:Boolean):Void {
		// to avoid scaling interaction due scrolling during animated scaling
		if (this.scaleAnimOn && scrolling) {
			return;
		}
		// local reference                                                  
		var mcBase:MovieClip = this.mcBase;
		// scale MC by increments
		mcBase._xscale += percentValue;
		mcBase._yscale += percentValue;
		// lower end of scaling
		var minScale:Number = DefaultValues.MIN_SCALE;
		// limit lower end of scaling
		if (mcBase._xscale<=minScale) {
			mcBase._xscale = minScale;
			mcBase._yscale = minScale;
		}
		// what percent is "100%" w.r.t. current scaling?                                              
		// Say: current scaling is 200% ... so "100%" is 50% of 200% scaling.
		// This value is required to scale up/down chart sub-elements (like text, text-bitmaps) to shown
		// in 100% view w.r.t. stage. A case of scaling selectively.
		this.scale100 = Math.round((100/this.getScale())*100);
		// reset label scaling
		Render.resetLabels(mcBase, this.scale100);
	}
	/**
	 * getScale method returns the current scale value.
	 * @return			current scale value
	 */
	public function getScale():Number {
		// scale value of the chart
		return this.mcBase._xscale;
	}
	/**
	 * scaleTo100 method is called to invoke animation 
	 * to 100% scaling.
	 */
	public function scaleTo100():Void {
		// updating the flag to indicate that the chart is undergoing an animation sequence to scale up/down.
		this.scaleAnimOn = true;
		// number of steps through which to execute the required scaling animation
		var steps:Number = 10;
		// difference of current scaling from 100%
		var scaleGap:Number = 100-this.getScale();
		// scaling per animating step/frame
		var scaleStep:Number = scaleGap/steps;
		// remove any pre-existing animating program
		delete this.mcControl.onEnterFrame;
		// local reference of 'this'
		var thisRef = this;
		// animation programmed
		this.mcControl.onEnterFrame = function() {
			// if difference of current scale from 100% is greater than per frame scaling value
			if (Math.abs(100-thisRef.getScale())>Math.abs(scaleStep)) {
				// scale by the per frame scaling value
				thisRef.scale(scaleStep);
			} else {
				// else, simply reach the final scale
				// difference of current scale from 100%
				scaleGap = 100-thisRef.getScale();
				// final scaling by the required difference
				thisRef.scale(scaleGap);
				// updating scaling animation end status
				thisRef.scaleAnimOn = false;
				// target achieved
				delete this.onEnterFrame;
			}
		};
	}
	/**
	 * scaleToFit method is called to animate the chart
	 * to best fit in the chart stage (recursive call).
	 * @param		scaleStepPrev 		scaling change value (recursive)
	 * @param		recursionTimes		number of recursive calls
	 */
	public function scaleToFit(scaleStepPrev:Number, recursionTimes:Number):Void {
		// checking number of recursive call limit set
		if (recursionTimes<2) {
			// updating the number of recursive calls
			recursionTimes++;
		} else if (recursionTimes == undefined) {
			// if the number of recursive calls is yet to be defined ... means not a recursive call
			recursionTimes = 0;
		} else {
			// stop the recursion
			this.dispatchEvent({target:this, type:'scaleAnimated'});
			return;
		}
		// chart stage width and height
		var sw:Number = objStage.stageWidth;
		var sh:Number = objStage.stageHeight;
		// origin of chart stage
		var sx:Number = objStage.xStage;
		var sy:Number = objStage.yStage;
		// center of chart stage
		var ex:Number = sx+sw/2;
		var ey:Number = sy+sh/2;
		// difference in positions of chart container origin and chart container center
		var delX:Number = this.mcBase._x-ex;
		var delY:Number = this.mcBase._y-ey;
		//--------------//
		// number of steps through which to animate the chart, for the first non-recursive call
		var iniSteps:Number = 10;
		// updating the flag to indicate that the chart is undergoing an animation sequence to scale up/down.
		this.scaleAnimOn = true;
		// current scale value
		var currentScale:Number = this.getScale();
		// metrics of the chart container extremes
		var objBounds:Object = this.mcBase.getBounds();
		// values obtained are all original values in the reference frame of the movie scaled.
		// So, they need to be obtained w.r.t. the stage/root/root_of_chart.
		for (var i in objBounds) {
			objBounds[i] *= currentScale/100;
		}
		// local variables
		var leftGap:Number, rightGap:Number, topGap:Number, bottomGap:Number;
		// getting the overflowings in left and right 
		leftGap = (sw/2+delX)+objBounds.xMin;
		rightGap = (sw/2-delX)-objBounds.xMax;
		// getting the overflowings in top and bottom  
		topGap = (sh/2+delY)+objBounds.yMin;
		bottomGap = (sh/2-delY)-objBounds.yMax;
		// variables to store pertinent overflowing/underlaying gaps 
		// underlay: positive
		// perfect: zero
		// overflow: negative
		var xGap:Number = Math.min(leftGap, rightGap);
		var yGap:Number = Math.min(topGap, bottomGap);
		// change in scaling should be calculated w.r.t. original pixel dimensions of the MC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
		var finalXScale:Number = currentScale/(1-(2*xGap/this.xAxisWidth));
		var finalYScale:Number = currentScale/(1-(2*yGap/this.yAxisHeight));
		// have to use the minimum of the two
		var finalScaleValue:Number = Math.round(Math.min(finalXScale, finalYScale));
		// Restricting scaling to the minimum value as specified in DefaultValues class.
		if (finalScaleValue<DefaultValues.MIN_SCALE) {
			finalScaleValue = DefaultValues.MIN_SCALE;
		}
		// difference of current scale from the evaluated final scale value                                          
		var scaleGap:Number = Math.round(finalScaleValue-currentScale);
		// if scale change is required at all
		if (scaleGap != 0) {
			// scale change value per frame/step; for recursive calls, 
			// use the value obtained from argument, to make animation rythm smooth
			var scaleStep:Number = (scaleStepPrev != undefined) ? scaleStepPrev : scaleGap/iniSteps;
			// a measure to check erroneous recursive call ... aproximation issue
			if (scaleGap*scaleStep<0) {
				// updating scaling animation end status
				this.scaleAnimOn = false;
				this.dispatchEvent({target:this, type:'scaleAnimated'});
				return;
			}
			// local reference of 'this'                                          
			var thisRef = this;
			// removing any pre-existing animation program
			delete this.mcControl.onEnterFrame;
			// animation programmed
			this.mcControl.onEnterFrame = function() {
				// if absolute difference of current scale from final one is greater than per frame absolute scaling value
				if (Math.abs(finalScaleValue-thisRef.getScale())>Math.abs(scaleStep)) {
					// execute scaling change by the per frame change value
					thisRef.scale(scaleStep);
				} else {
					// else, simply reach the final scale
					// difference of current scale from the final value
					scaleGap = finalScaleValue-thisRef.getScale();
					// final scaling by the required difference
					thisRef.scale(scaleGap);
					// updating scaling animation end status
					thisRef.scaleAnimOn = false;
					// job done for this call
					delete this.onEnterFrame;
					// should check for better fitting by recursive call ... required for text scaling up/down need to accounted for
					thisRef.scaleToFit(scaleStep, recursionTimes);
				}
			};
		} else {
			// updating scaling animation end status
			this.scaleAnimOn = false;
			this.dispatchEvent({target:this, type:'scaleAnimated'});
		}
	}
	/**
	 * scaleToFitInit method is called to scale the chart
	 * to best fit the canvas initially, when initial 
	 * animation is not opted for.
	 */
	public function scaleToFitInit():Void {
		// chart stage width and height
		var sw:Number = objStage.stageWidth;
		var sh:Number = objStage.stageHeight;
		// origin of chart stage
		var sx:Number = objStage.xStage;
		var sy:Number = objStage.yStage;
		// center of chart stage
		var ex:Number = sx+sw/2;
		var ey:Number = sy+sh/2;
		// difference in positions of chart container origin and chart container center
		var delX:Number = this.mcBase._x-ex;
		var delY:Number = this.mcBase._y-ey;
		//--------------//
		// current scale value
		var currentScale:Number = this.getScale();
		// metrics of the chart container extremes
		var objBounds:Object = this.mcBase.getBounds();
		// values obtained are all original values in the reference frame of the movie scaled.
		// So, they need to be obtained w.r.t. the stage/root/root_of_chart.
		for (var i in objBounds) {
			objBounds[i] *= currentScale/100;
		}
		// local variables
		var leftGap:Number, rightGap:Number, topGap:Number, bottomGap:Number;
		// getting the overflowings in left and right 
		leftGap = (sw/2+delX)+objBounds.xMin;
		rightGap = (sw/2-delX)-objBounds.xMax;
		// getting the overflowings in top and bottom  
		topGap = (sh/2+delY)+objBounds.yMin;
		bottomGap = (sh/2-delY)-objBounds.yMax;
		// variables to store pertinent overflowing/underlaying gaps 
		// underlay: positive
		// perfect: zero
		// overflow: negative
		var xGap:Number = Math.min(leftGap, rightGap);
		var yGap:Number = Math.min(topGap, bottomGap);
		// change in scaling should be calculated w.r.t. original pixel dimensions of the MC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
		var finalXScale:Number = currentScale/(1-(2*xGap/this.xAxisWidth));
		var finalYScale:Number = currentScale/(1-(2*yGap/this.yAxisHeight));
		// have to use the minimum of the two
		var finalScaleValue:Number = Math.round(Math.min(finalXScale, finalYScale));
		// Restricting scaling to the minimum value as specified in DefaultValues class.
		if (finalScaleValue<DefaultValues.MIN_SCALE) {
			finalScaleValue = DefaultValues.MIN_SCALE;
		}
		// difference of current scale from the evaluated final scale value                                          
		var scaleGap:Number = Math.round(finalScaleValue-currentScale);
		// if scale change is required at all
		if (scaleGap != 0) {
			// final scaling by the required difference
			this.scale(scaleGap);
		}
	}
	/**
	 * getAnimSteps method returns the number of steps in
	 * which should the animation proceeed to meet the 
	 * exeTime.
	 * @param		exeTime		time in seconds
	 * @param		animTime	time recorded per frame rendering
	 * @return					number of steps
	 */
	private function getAnimSteps(exeTime:Number, animTime:Number):Number {
		// conversion to milliseconds
		animTime *= 1000;
		var steps:Number = Math.round(animTime/(exeTime*1.4));
		// at least one step
		if (steps<1) {
			steps = 1;
		}
		return steps;
	}
	/**
	 * setStageForScaling method is called to set stage for 
	 * scaling about chart center be possible.
	 */
	private function setStageForScaling():Void {
		// half the axes lengths
		var w:Number = this.xAxisWidth/2;
		var h:Number = this.yAxisHeight/2;
		// local reference
		var mcBase:MovieClip = this.mcBase;
		// ultimate container of chart created
		var mcHolder:MovieClip = this.mcHolder=mcBase.createEmptyMovieClip('mcHolder', mcBase.getNextHighestDepth());
		// containers repositioned to allow central scaling
		mcBase._x += w;
		mcBase._y += h;
		//
		mcHolder._x -= w;
		mcHolder._y -= h;
	}
	/**
	 * handleToolTip method returns the 3D point corresponding
	 * to the 2D point under the mouse pointer.
	 * @param		mcBlock		the MC under mouse pointer
	 * @return					3D point in model space
	 */
	public function handleToolTip(mcBlock:MovieClip):Array {
		// mouse pointer position (2D) w.r.t. chart container
		var arrPt2D:Array = [this.mcHolder._xmouse, this.mcHolder._ymouse];
		// iterating over MCs in the passed data item block MC
		for (var i in mcBlock) {
			// sub-item
			var mcBlock_i = mcBlock[i];
			// if the sub-item is a MC ... actually a face MC
			if (mcBlock_i instanceof MovieClip) {
				// if mouse is over this face MC
				if (mcBlock_i.hitTest(_root._xmouse, _root._ymouse, true)) {
					// local reference of the vertex mapping of this face
					var arrMap:Array = mcBlock_i.arrMap;
					// local reference of series id
					var seriesId:Number = mcBlock_i.seriesId;
					// local reference of block id (within its series)
					var mcBlockId:Number = mcBlock_i.mcBlockId;
				}
			}
		}
		// terminates search of 3D point if series id and/or block id is undefined
		if (seriesId == undefined || mcBlockId == undefined) {
			return;
		}
		// for the special case of "COLUMN" under mouse pointer ... return the "id"s instead of a 3d point                                        
		if (this.arrCategory[seriesId] == 'COLUMN') {
			// array indexed elements
			var arrReturn:Array = [seriesId, mcBlockId];
			// array associated element, indicating that this is a "COLUMN"
			arrReturn['isColumn'] = true;
			// return
			return arrReturn;
		}
		// if not a "COLUMN ... proceed finding the 3D point                                        
		// axes width and height
		var objAxes:Object = {w:this.xAxisWidth, h:this.yAxisHeight};
		// camera angles
		var objCamAngs:Object = this.getCameraAngs();
		// if chart not in 2D view
		if (objCamAngs.xAng != 0 && objCamAngs.yAng != 0) {
			// get the respective 3D point
			var arrPt3DModel:Array = Transform3D.ptScreenToModel(arrPt2D, objAxes, objCamAngs, this.arrDataView, arrMap, mcBlockId, seriesId, this.arrModelCenter);
		} else {
			// else, chart in 2D view
			// get the respective 3D point
			var arrPt3DModel:Array = Transform3D.ptScreenToModel2DMode(arrPt2D, objAxes, this.arrDataView, seriesId, this.arrModelCenter);
		}
		// associated entry to indicate that its not a "COLUMN"
		arrPt3DModel['isColumn'] = false;
		// return the 3D point corresponding to the mouse pointer
		return arrPt3DModel;
	}
	/**
	 * getAxesFaceCombId method is called to return the id
	 * corresponding to the face combination passed.
	 * @param		arrFaces		set of 3 face ids
	 * @return						combination id
	 */
	private function getAxesFaceCombId(arrFaces:Array):Number {
		var left:Boolean = true;
		var back:Boolean = true;
		var top:Boolean = true;
		// 
		// iterating over face ids (numbers)
		// face ids --> 0: left, 1: top, 2: right, 3: botom, 4: front, 5: back
		for (var i = 0; i<arrFaces.length; ++i) {
			// matching the face id under loop
			switch (arrFaces[i]) {
			case 0 :
				left = true;
				break;
			case 1 :
				top = true;
				break;
			case 2 :
				left = false;
				break;
			case 3 :
				top = false;
				break;
			case 4 :
				back = false;
				break;
			case 5 :
				back = true;
				break;
			}
		}
		// binary number assigned for positions in order to form a 3 bit number (range: 0-7)
		// left
		var p1:Number = (back) ? 0 : 1;
		// middle 
		var p2:Number = (left) ? 0 : 1;
		// right
		var p3:Number = (top) ? 0 : 1;
		// 3 bit binary number converted to decimal equivalent returned
		return p1 << 2 | p2 << 1 | p3;
	}
	/**
	 * validateAxesBox method validates set of faces found 
	 * renderable for the axes box.
	 * @param		arrFaces		set of faces
	 * @param		chartToppled	if chart currently toppled
	 */
	public function validateAxesBox(arrFaces:Array, chartToppled:Boolean):Void {
		// matching the array length
		switch (arrFaces.length) {
		case 3 :
			// length of 3 is the maximum possible .. nothing to add
			break;
		case 2 :
			// have to add one more face to make it 3
			if (!chartToppled) {
				// if chart not toppled
				// face map to match existing faces and add the respective third one
				var arr2Faces:Array = [[[0, 1], 5], [[0, 3], 5], [[0, 4], 3], [[0, 5], 3], [[1, 2], 5], [[1, 4], 0], [[1, 5], 0], [[2, 3], 5], [[2, 4], 3], [[2, 5], 3], [[3, 4], 0], [[3, 5], 0]];
			} else {
				// if chart toppled
				// face map to match existing faces and add the respective third one
				var arr2Faces:Array = [[[0, 1], 5], [[0, 3], 5], [[0, 4], 1], [[0, 5], 1], [[1, 2], 5], [[1, 4], 0], [[1, 5], 0], [[2, 3], 5], [[2, 4], 1], [[2, 5], 1], [[3, 4], 0], [[3, 5], 0]];
			}
			// need to sort face ids first, since following checking to match existing faces requires them 
			// to be in ascending order
			arrFaces.sort(16);
			// first face id
			var a:Number = arrFaces[0];
			// second face id
			var b:Number = arrFaces[1];
			// array length; its the number of all possible combinations of 2 faces 
			// (actually 12 .. 6C2-3=15-3=12 ... 3 pairs of opposite faces not possible)
			var num:Number = arr2Faces.length;
			// iterating over all possible 2 faces combination to match the passed combination
			for (var i = 0; i<num; ++i) {
				// face matching
				if (a == arr2Faces[i][0][0] && b == arr2Faces[i][0][1]) {
					// if match found, add the respective third one
					arrFaces.push(arr2Faces[i][1]);
					break;
				}
			}
			break;
		case 1 :
			// have to add two more faces to make it 3
			if (!chartToppled) {
				// if chart not toppled
				// face map to match existing face and add the respective other two
				var arrOneFace:Array = [[3, 4], [0, 5], [3, 5], [0, 5], [2, 3], [0, 3]];
			} else {
				// if chart toppled
				// face map to match existing face and add the respective other two
				var arrOneFace:Array = [[3, 4], [0, 5], [3, 5], [0, 5], [0, 1], [1, 2]];
			}
			// existing face id
			var onlyFaceId:Number = arrFaces[0];
			// face id to provide the other 2 required; added
			arrFaces.push(arrOneFace[onlyFaceId][0], arrOneFace[onlyFaceId][1]);
			break;
		}
		// face ids sorted for further use
		arrFaces.sort(16);
	}
}
