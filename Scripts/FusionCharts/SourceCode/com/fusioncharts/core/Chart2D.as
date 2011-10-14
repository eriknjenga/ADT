/**
* @class Chart2D
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2007-2008
*
* Chart2D chart extends the SingleYAxis2DVerticalChart class to help render a
* Multi-series Combination 3D Chart.
*/
//Import Chart class
import com.fusioncharts.core.Chart;
//Parent SingleYAxis2DVerticalChart Class
import com.fusioncharts.core.SingleYAxis2DVerticalChart;
//Error class
import com.fusioncharts.helper.FCError;
//Import Logger Class
import com.fusioncharts.helper.Logger;
//Style Object
import com.fusioncharts.core.StyleObject;
//Delegate
import mx.utils.Delegate;
//Legend Class
import com.fusioncharts.helper.InteractiveLegend;
//Extensions
import com.fusioncharts.extensions.StringExt;
import com.fusioncharts.extensions.MathExt;
// class definition
class com.fusioncharts.core.Chart2D extends SingleYAxis2DVerticalChart {
	//Version number (if different from super Chart class)
	//private var _version:String = "3.0.0";
	//Instance variables
	//List of chart objects
	private var _arrObjects:Array;
	private var xmlData:XML;
	//Array to store x-axis categories (labels)
	private var categories:Array;
	//Array to store datasets
	private var dataset:Array;
	//Total number of data sets
	private var numDS:Number;
	//Number of column, line and area datasets
	private var numColDS:Number;
	private var numLineDS:Number;
	private var numAreaDS:Number;
	// flag to indicate that atleast one x-label is on
	public var labelOn:Boolean;
	//Number of data items
	private var num:Number;
	// total number of valid set in xml
	private var numData:Number
	//Reference to legend component of chart
	private var lgnd:InteractiveLegend;
	//Reference to legend movie clip
	private var lgndMC:MovieClip;
	/**
	* Constructor function. We invoke the super class'
	* constructor and then set the objects for this chart.
	*/
	function Chart2D(targetMC:MovieClip, depth:Number, width:Number, height:Number, x:Number, y:Number, debugMode:Boolean, lang:String, _scaleMode:String, _registerWithJS:Boolean, _DOMId:String) {
		//Invoke the super class constructor
		super(targetMC, depth, width, height, x, y, debugMode, lang, _scaleMode, _registerWithJS, _DOMId);
		//Log additional information to debugger
		//We log version from this class, so that if this class version
		//is different, we can log it
		this.log("Version", _version, Logger.LEVEL.INFO);
		this.log("Chart Type", "True 3D Combination Chart (Single Y)", Logger.LEVEL.INFO);
		//List Chart Objects and set them
		_arrObjects = new Array("BACKGROUND", "CAPTION", "SUBCAPTION", "YAXISNAME", "XAXISNAME", "YAXISVALUES", "DATALABELS", "DATAVALUES", "TRENDVALUES", "TOOLTIP", "LEGEND");
		super.setChartObjects(_arrObjects);
		//Initialize the containers for chart
		this.categories = new Array();
		this.dataset = new Array();
		//Initialize the number of data elements present
		this.numDS = 0;
		this.numColDS = 0;
		this.numLineDS = 0;
		this.numAreaDS = 0;
		this.num = 0;
		this.numData = 0
		this.labelOn = false;
		
	}
	/**
	* returnDataAsObject method creates an object out of the parameters
	* passed to this method. The idea is that we store each data point
	* as an object with multiple (flexible) properties. So, we do not
	* use a predefined class structure. Instead we use a generic object.
	*	@param	value		Value for the data.
	* 	@param	displayValue	Value that will be displayed on the chart
	*	@param	toolText	Tool tip text (if specified).
	*	@param	link		Link (if any) for the data.
	*	@return			An object encapsulating all these properies.
	*/
	private function returnDataAsObject(value:Number, displayValue:String, toolText:String, link:String):Object {
		//Create a container
		var dataObj:Object = new Object();
		//Store the values
		dataObj.value = value;
		//Explicitly specified display value
		dataObj.exDispVal = displayValue;
		dataObj.toolText = toolText;
		dataObj.link = link;
		//If the given number is not a valid number or it's missing
		//set appropriate flags for this data point
		dataObj.isDefined = (isNaN(value)) ? false : true;
		dataObj.showLabel = (dataObj.isDefined) ? true : false;
		//Other parameters
		//X & Y Position of data point
		dataObj.x = 0;
		dataObj.y = 0;
		//X & Y Position of value tb
		dataObj.valTBX = 0;
		dataObj.valTBY = 0;
		//Return the container
		return dataObj;
	}
	/**
	* returnDataAsCat method returns data of a <category> element as
	* an object
	*	@param	label		Label of the category.
	*	@param	showLabel	Whether to show the label of this category.
	*	@param	toolText	Tool-text for the category
	*	@return			A container object with the given properties
	*/
	private function returnDataAsCat(label:String, showLabel:Number, toolText:String):Object {
		//Create container object
		var catObj:Object = new Object();
		catObj.label = label;
		catObj.showLabel = ((showLabel == 1) && (label != undefined) && (label != null) && (label != "")) ? true : false;
		catObj.toolText = toolText;
		//X and Y Position
		catObj.x = 0;
		catObj.y = 0;
		//Return container
		return catObj;
	}
	/**
	* parseXML method parses the XML data, sets defaults and validates
	* the attributes before storing them to data storage objects.
	*/
	private function parseXML():Void {
		//Get the element nodes
		var arrDocElement:Array = this.xmlData.childNodes;
		//Loop variable
		var i:Number;
		var j:Number;
		var k:Number;
		//Look for <graph> element
		for (i = 0; i < arrDocElement.length; i++) {
			//If it's a <graph> element, proceed.
			//Do case in-sensitive mathcing by changing to upper case
			if (arrDocElement[i].nodeName.toUpperCase() == "GRAPH" || arrDocElement[i].nodeName.toUpperCase() == "CHART") {
				//Extract attributes of <graph> element
				this.parseAttributes(arrDocElement[i]);
				//Extract common attributes/over-ride chart specific ones
				this.parseCommonAttributes (arrDocElement [i],true);
				//Now, get the child nodes - first level nodes
				//Level 1 nodes can be - CATEGORIES, DATASET, TRENDLINES, STYLES etc.
				var arrLevel1Nodes:Array = arrDocElement[i].childNodes;
				var setNode:XMLNode;
				//---------------------------------------------//
				for (j = 0; j < arrLevel1Nodes.length; j++) {
					if (arrLevel1Nodes[j].nodeName.toUpperCase() == "CATEGORIES") {
						//Categories Node.
						var categoriesNode:XMLNode = arrLevel1Nodes[j];
						//Convert attributes to array
						var categoriesAtt:Array = this.getAttributesArray(categoriesNode);
						//Extract attributes of this node.
						this.params.catFont = getFV(categoriesAtt["font"], this.params.outCnvBaseFont);
						this.params.catFontSize = getFN(categoriesAtt["fontsize"], this.params.outCnvBaseFontSize);
						this.params.catFontColor = formatColor(getFV(categoriesAtt["fontcolor"], this.params.outCnvBaseFontColor));
						//Get reference to child node.
						var arrLevel2Nodes:Array = arrLevel1Nodes[j].childNodes;
						//Iterate through all child-nodes of CATEGORIES element
						//and search for CATEGORY or VLINE node
						for (k = 0; k < arrLevel2Nodes.length; k++) {
							if (arrLevel2Nodes[k].nodeName.toUpperCase() == "CATEGORY") {
								//Category Node.
								//Update counter
								this.num++;
								//Extract attributes
								var categoryNode:XMLNode = arrLevel2Nodes[k];
								var categoryAtt:Array = this.getAttributesArray(categoryNode);
								//Category label.
								var catLabel:String = getFV(categoryAtt["label"], categoryAtt["name"], "");
								var catShowLabel:Number = getFN(categoryAtt["showlabel"], categoryAtt["showname"], this.params.showLabels);
								var catToolText:String = getFV(categoryAtt["tooltext"], categoryAtt["hovertext"], catLabel);
								//Store it in data container.
								this.categories[this.num] = this.returnDataAsCat(catLabel, catShowLabel, catToolText);
							} else if (arrLevel2Nodes[k].nodeName.toUpperCase() == "VLINE") {
								//Vertical axis division Node - extract child nodes
								var vLineNode:XMLNode = arrLevel2Nodes[k];
								//Parse and store
								this.parseVLineNode(vLineNode, this.num);
							}
						}
						break;
					}
				}
				//---------------------------------------------//
				
				//Iterate through all level 1 nodes.
				for (j = 0; j < arrLevel1Nodes.length; j++) {
					if (arrLevel1Nodes[j].nodeName.toUpperCase() == "DATASET") {
						//Get reference to child node.
						var arrLevel2Nodes:Array = arrLevel1Nodes[j].childNodes;
						//-----------------------------------------------//
						// now, validate the DATASET
						var validSetFound:Boolean = false
						var numSet:Number = 0
						// iterate over dataset entries to find for atleast one properly defined SET
						for (k = 0; k < arrLevel2Nodes.length; k++) {
							if(numSet==this.num){
								break
							}
							if (arrLevel2Nodes[k].nodeName.toUpperCase() == "SET") {
								numSet++
								//Get reference to node.
								setNode = arrLevel2Nodes[k];
								//Get attributes
								var atts:Array;
								atts = this.getAttributesArray(setNode);
								//Now, get value.
								var setValue:Number = this.getSetValue(atts["value"]);
								// checking for numeric SET value
								if(!isNaN(setValue)){
									// SET is valid
									validSetFound = true
									// no use iterating over the rest of the DATASET
									break
								}
							}
						}
						// if the DATASET is valid, proceed parsing it
						if(!validSetFound){
							continue
						}
						//-------------------------------------------------//
						//Increment
						this.numDS++;
						//Dataset node.
						var dataSetNode:XMLNode = arrLevel1Nodes[j];
						//Get attributes array
						var dsAtts:Array = this.getAttributesArray(dataSetNode);
						//Create storage object in dataset array
						this.dataset[this.numDS] = new Object();
						//Parent y-axis (backward compatibility)
						this.dataset[this.numDS].parentYAxis = getFV(dsAtts["parentyaxis"], "P");
						//Render As
						this.dataset[this.numDS].renderAs = getFV(dsAtts["renderas"], (this.dataset[this.numDS].parentYAxis.toUpperCase() == "P") ? "COLUMN" : "LINE");
						this.dataset[this.numDS].renderAs = this.dataset[this.numDS].renderAs.toUpperCase();
						//Render as can have just one of three values - COLUMN, LINE or AREA
						if (this.dataset[this.numDS].renderAs != "COLUMN" && this.dataset[this.numDS].renderAs != "LINE" && this.dataset[this.numDS].renderAs != "AREA") {
							//Default to column
							this.dataset[this.numDS].renderAs = "COLUMN";
						}
						//Update dataset counter based on what the dataset is to be rendered as.                                            
						switch (this.dataset[this.numDS].renderAs) {
						case "COLUMN" :
							this.numColDS++;
							break;
						case "LINE" :
							this.numLineDS++;
							break;
						case "AREA" :
							this.numAreaDS++;
							break;
						}
						//Store attributes - We store attributes related to all three types of chart
						//centrally without any if then.
						this.dataset[this.numDS].seriesName = getFV(dsAtts["seriesname"], "");
						this.dataset[this.numDS].color = formatColor(getFV(dsAtts["color"], this.defColors.getColor()));
						this.dataset[this.numDS].showValues = toBoolean(getFN(dsAtts["showvalues"], this.params.showValues));
						this.dataset[this.numDS].includeInLegend = toBoolean(getFN(dsAtts["includeinlegend"], 1));
						//Create data array under it.
						this.dataset[this.numDS].data = new Array();
						//Iterate through all child-nodes of DATASET element
						//and search for SET node
						//Counter
						var setCount:Number = 0;
						
						for (k = 0; k < arrLevel2Nodes.length; k++) {
							// parse the SET attributes
							if (arrLevel2Nodes[k].nodeName.toUpperCase() == "SET") {
								//Set Node. So extract the data.
								//Update counter
								setCount++;
								//Get reference to node.
								setNode = arrLevel2Nodes[k];
								//Get attributes
								var atts:Array;
								atts = this.getAttributesArray(setNode);
								//Now, get value.
								var setValue:Number = this.getSetValue(atts["value"]);
								//Get explicitly specified display value
								var setExDispVal : String = getFV( atts["displayvalue"], "");
								// update counter for valid SET value found
								if(!isNaN(setValue)){
									this.numData++								
									//We do NOT unescape the link, as this will be done
									//in invokeLink method for the links that user clicks.
									var setLink:String = getFV(StringExt.removeSpaces(atts["link"]), "");
									var setToolText:String = getFV(atts["tooltext"], atts["hovertext"]);
								} else{
									// don't parse and store attribute values for undefined SET
									var setLink:String = ''
									var setToolText:String = ''
								}
								//Store all these attributes as object.								
								this.dataset[this.numDS].data[setCount] = this.returnDataAsObject(setValue,  setExDispVal, setToolText, setLink);
							}
						}						
					} else if (arrLevel1Nodes[j].nodeName.toUpperCase() == "STYLES") {
						//Styles Node - extract child nodes
						var arrStyleNodes:Array = arrLevel1Nodes[j].childNodes;
						//Parse the style nodes to extract style information
						super.parseStyleXML(arrStyleNodes);
					} else if (arrLevel1Nodes[j].nodeName.toUpperCase() == "TRENDLINES") {
						//Trend lines node
						var arrTrendNodes:Array = arrLevel1Nodes[j].childNodes;
						//Parse the trend line nodes
						super.parseTrendLineXML(arrTrendNodes);
					}
				}
			}
		}
		//Delete all temporary objects used for parsing XML Data document
		delete setNode;
		delete arrDocElement;
		delete arrLevel1Nodes;
		delete arrLevel2Nodes;
	}
	/**
	* parseAttributes method parses the attributes and stores them in
	* chart storage objects.
	* Starting ActionScript 2, the parsing of XML attributes have also
	* become case-sensitive. However, prior versions of FusionCharts
	* supported case-insensitive attributes. So we need to parse all
	* attributes as case-insensitive to maintain backward compatibility.
	* To do so, we first extract all attributes from XML, convert it into
	* lower case and then store it in an array. Later, we extract value from
	* this array.
	* @param	graphElement	XML Node containing the <graph> element
	*							and it's attributes
	*/
	private function parseAttributes(graphElement:XMLNode):Void {
		//Array to store the attributes
		var atts:Array = this.getAttributesArray(graphElement);
		//NOW IT'S VERY NECCESARY THAT WHEN WE REFERENCE THIS ARRAY
		//TO GET AN ATTRIBUTE VALUE, WE SHOULD PROVIDE THE ATTRIBUTE
		//NAME IN LOWER CASE. ELSE, UNDEFINED VALUE WOULD SHOW UP.
		//Extract attributes pertinent to this chart
		//Which palette to use?
		this.params.palette = getFN(atts["palette"], 1);
		//Palette colors to use
		this.params.paletteColors = getFV(atts["palettecolors"],"");
		//Set palette colors before parsing the <set> nodes.
		this.setPaletteColors();
		// ---------- PADDING AND SPACING RELATED ATTRIBUTES ----------- //
		//captionPadding = Space between caption/subcaption and canvas start Y
		this.params.captionPadding = Math.abs(getFN(atts["captionpadding"], 10));
		//Canvas Padding is the space between the canvas left/right border
		//and first/last data point - applicable if 0 columns on chart
		this.params.canvasPadding = Math.abs(getFN(atts["canvaspadding"], 0));
		//Padding for x-axis name - to the right
		this.params.xAxisNamePadding = 0;
		//Padding for y-axis name - from top
		this.params.yAxisNamePadding = 0;
		//Y-Axis Values padding - Horizontal space between the axis edge and
		//y-axis values or trend line values (on left/right side).
		this.params.yAxisValuesPadding = Math.abs(getFN(atts["ylabelgap"], 5));
		//Label padding - Vertical space between the labels and canvas end position
		this.params.labelPadding = Math.abs(getFN(atts["xlabelgap"], 5));
		//Value padding - vertical space between the end of columns and start of value textboxes
		this.params.valuePadding = Math.abs(getFN(atts["valuepadding"], 5));
		//
		//Percentage space on the plot area
		this.params.plotSpacePercent = getFN(atts["plotspacepercent"], 20);
		///Cannot be less than 0 and more than 80
		if ((this.params.plotSpacePercent < 0) || (this.params.plotSpacePercent > 80)) {
			//Reset to 20
			this.params.plotSpacePercent = 20;
		}
		//Padding of legend from right/bottom side of canvas                                        
		this.params.legendPadding = Math.abs(getFN(atts["legendpadding"], 15));
		//Chart Margins - Empty space at the 4 sides
		this.params.chartLeftMargin = getFN(atts["chartleftmargin"], 15);
		this.params.chartRightMargin = getFN(atts["chartrightmargin"], 15);
		this.params.chartTopMargin = getFN(atts["charttopmargin"], 15);
		this.params.chartBottomMargin = getFN(atts["chartbottommargin"], 15);
		// -------------------------- HEADERS ------------------------- //
		//Chart Caption and sub Caption
		this.params.caption = getFV(atts["caption"], "");
		this.params.subCaption = getFV(atts["subcaption"], "");
		//X and Y Axis Name
		this.params.xAxisName = getFV(atts["xaxisname"], "");
		this.params.yAxisName = getFV(atts["yaxisname"], "");
		//Adaptive yMin - if set to true, the y min will be based on the values
		//provided. It won't be set to 0 in case of all positive values
		this.params.setAdaptiveYMin = toBoolean(getFN(atts["setadaptiveymin"], 0));
		// --------------------- CONFIGURATION ------------------------- //
		//The upper and lower limits of y and x axis
		this.params.yAxisMinValue = atts["yaxisminvalue"];
		this.params.yAxisMaxValue = atts["yaxismaxvalue"];
		//Whether to set animation for entire chart.
		this.params.animation = toBoolean(getFN(atts["animation"], 1));
		//Whether null data points are to be connected or left broken
		this.params.connectNullData = toBoolean(getFN(atts["connectnulldata"], 0));
		//Configuration to set whether to show the labels
		this.params.showLabels = toBoolean(getFN(atts["showlabels"], atts["shownames"], 1));
		//Step value for labels - i.e., show all labels or skip every x label
		this.params.labelStep = int(getFN(atts["labelstep"], 1));
		//Cannot be less than 1
		this.params.labelStep = (this.params.labelStep < 1) ? 1 : this.params.labelStep;
		//Configuration whether to show data values
		this.params.showValues = toBoolean(getFN(atts["showvalues"], 0));
		//Option to show/hide y-axis values
		this.params.showYAxisValues = getFN(atts["showyaxisvalues"], atts["showyaxisvalue"], 1);
		this.params.showLimits = toBoolean(getFN(atts["showlimits"], this.params.showYAxisValues));
		this.params.showDivLineValues = toBoolean(getFN(atts["showdivlinevalue"], atts["showdivlinevalues"], this.params.showYAxisValues));
		//Y-axis value step- i.e., show all y-axis or skip every x(th) value
		this.params.yAxisValuesStep = int(getFN(atts["yaxisvaluesstep"], atts["yaxisvaluestep"], 1));
		//Cannot be less than 1
		this.params.yAxisValuesStep = (this.params.yAxisValuesStep < 1) ? 1 : this.params.yAxisValuesStep;
		//Whether to automatically adjust div lines
		this.params.adjustDiv = toBoolean(getFN(atts["adjustdiv"], 1));
		//Max width to be alloted to y-axis name - No defaults, as it's calculated later.
		this.params.yAxisNameWidth = atts["yaxisnamewidth"];
		//Click URL
		this.params.clickURL = getFV(atts["clickurl"], "");
		// ------------------------- COSMETICS -----------------------------//
		//Background properties - Gradient
		this.params.bgColor = getFV(atts["bgcolor"], this.defColors.get2DBgColor(this.params.palette));
		this.params.bgAlpha = getFV(atts["bgalpha"], this.defColors.get2DBgAlpha(this.params.palette));
		this.params.bgRatio = getFV(atts["bgratio"], this.defColors.get2DBgRatio(this.params.palette));
		this.params.bgAngle = getFV(atts["bgangle"], this.defColors.get2DBgAngle(this.params.palette));
		//Border Properties of chart
		this.params.showBorder = toBoolean(getFN(atts["showborder"], 1));
		this.params.borderColor = formatColor(getFV(atts["bordercolor"], this.defColors.get2DBorderColor(this.params.palette)));
		this.params.borderThickness = getFN(atts["borderthickness"], 1);
		this.params.borderAlpha = getFN(atts["borderalpha"], this.defColors.get2DBorderAlpha(this.params.palette));
		//Canvas background properties - Gradient
		this.params.canvasBgColor = getFV(atts["canvasbgcolor"], this.defColors.get2DCanvasBgColor(this.params.palette));
		//Plot cosmetic properties
		this.params.showPlotBorder = toBoolean(getFN(atts["showplotborder"], 1));
		//Legend properties
		this.params.showLegend = toBoolean(getFN(atts["showlegend"], 1));
		//Alignment position
		this.params.legendPosition = getFV(atts["legendposition"], "BOTTOM");
		//Legend position can be either RIGHT or BOTTOM -Check for it
		this.params.legendPosition = (this.params.legendPosition.toUpperCase() == "RIGHT") ? "RIGHT" : "BOTTOM";
		this.params.interactiveLegend = toBoolean(getFN(atts["interactivelegend"], 1));
		this.params.legendCaption = getFV(atts["legendcaption"], "");
		this.params.legendMarkerCircle = toBoolean(getFN(atts["legendmarkercircle"], 0));
		this.params.legendBorderColor = formatColor(getFV(atts["legendbordercolor"], this.defColors.get2DLegendBorderColor(this.params.palette)));
		this.params.legendBorderThickness = getFN(atts["legendborderthickness"], 1);
		this.params.legendBorderAlpha = getFN(atts["legendborderalpha"], 100);
		this.params.legendBgColor = getFV(atts["legendbgcolor"], this.defColors.get2DLegendBgColor(this.params.palette));
		this.params.legendBgAlpha = getFN(atts["legendbgalpha"], 100);
		this.params.legendShadow = toBoolean(getFN(atts["legendshadow"], 1));
		this.params.legendAllowDrag = toBoolean(getFN(atts["legendallowdrag"], 0));
		this.params.legendScrollBgColor = formatColor(getFV(atts["legendscrollbgcolor"], "CCCCCC"));
		this.params.legendScrollBarColor = formatColor(getFV(atts["legendscrollbarcolor"], this.params.legendBorderColor));
		this.params.legendScrollBtnColor = formatColor(getFV(atts["legendscrollbtncolor"], this.params.legendBorderColor));
		//Horizontal grid division Lines - Number, color, thickness & alpha
		//Necessarily need a default value for numDivLines.
		this.params.numDivLines = getFN(atts["numdivlines"], 4);
		this.params.divLineColor = formatColor(getFV(atts["divlinecolor"], this.defColors.get2DDivLineColor(this.params.palette)));
		this.params.divLineThickness = getFN(atts["divlinethickness"], 1);
		this.params.divLineAlpha = getFN(atts["divlinealpha"], this.defColors.get2DDivLineAlpha(this.params.palette));
		//Zero Plane properties
		this.params.showZeroPlane = true;
		this.params.zeroPlaneColor = formatColor(getFV(atts["zeroplanecolor"], this.params.divLineColor));
		this.params.zeroPlaneThickness = getFN(atts["zeroplanethickness"], (this.params.divLineThickness == 1) ? 2 : this.params.divLineThickness);
		this.params.zeroPlaneAlpha = getFN(atts["zeroplanealpha"], 50);
		//Alternating grid colors
		this.params.showAlternateHGridColor = toBoolean(getFN(atts["showalternatehgridcolor"], 0));
		this.params.alternateHGridColor = formatColor(getFV(atts["alternatehgridcolor"], this.defColors.get2DAltHGridColor(this.params.palette)));
		// ------------------------- NUMBER FORMATTING ---------------------------- //
		//Option whether the format the number (using Commas)
		this.params.formatNumber = toBoolean(getFN(atts["formatnumber"], 1));
		//Option to format number scale
		this.params.formatNumberScale = toBoolean(getFN(atts["formatnumberscale"], 1));
		//Number Scales
		this.params.defaultNumberScale = getFV(atts["defaultnumberscale"], "");
		this.params.numberScaleUnit = getFV(atts["numberscaleunit"], "K,M");
		this.params.numberScaleValue = getFV(atts["numberscalevalue"], "1000,1000");
		//Number prefix and suffix
		this.params.numberPrefix = getFV(atts["numberprefix"], "");
		this.params.numberSuffix = getFV(atts["numbersuffix"], "");
		//Decimal Separator Character
		this.params.decimalSeparator = getFV(atts["decimalseparator"], ".");
		//Thousand Separator Character
		this.params.thousandSeparator = getFV(atts["thousandseparator"], ",");
		//Input decimal separator and thousand separator. In some european countries,
		//commas are used as decimal separators and dots as thousand separators. In XML,
		//if the user specifies such values, it will give a error while converting to
		//number. So, we accept the input decimal and thousand separator from user, so that
		//we can covert it accordingly into the required format.
		this.params.inDecimalSeparator = getFV(atts["indecimalseparator"], "");
		this.params.inThousandSeparator = getFV(atts["inthousandseparator"], "");
		//Decimal Precision (number of decimal places to be rounded to)
		this.params.decimals = getFV(atts["decimals"], atts["decimalprecision"]);
		//Force Decimal Padding
		this.params.forceDecimals = toBoolean(getFN(atts["forcedecimals"], 0));
		//y-Axis values decimals
		this.params.yAxisValueDecimals = getFV(atts["yaxisvaluedecimals"], atts["yaxisvaluesdecimals"], atts["divlinedecimalprecision"], atts["limitsdecimalprecision"]);
		//----------------- CHART3D ------------------------//
		// data items be animated initially or not
		this.params.animate3D = toBoolean(getFN(atts["animate3d"], ((this.params.animation) ? 1 : 0)));
		// execution time (in seconds) of interactive animations for rotating view angles; controls initial time parameter too
		this.params.exeTime = Math.abs(getFN(atts["exetime"], 0.5));
		// starting angles of initial animation
		this.params.startAngX = getFN(atts["startangx"], 30);
		this.params.startAngY = getFN(atts["startangy"], -45);
		// ending angles of initial animation
		this.params.endAngX = getFN(atts["endangx"], 30);
		this.params.endAngY = getFN(atts["endangy"], -45);
		// initial camera angles applicable for no initial animation
		this.params.cameraAngX = getFN(atts["cameraangx"], 30);
		this.params.cameraAngY = getFN(atts["cameraangy"], -45);
		// if chart be presented in 2D mode initially (front face visible only)
		this.params.is2D = toBoolean(getFN(atts["is2d"], 0));
		// for 2D mode initially, set relevant initial angles
		if (this.params.is2D) {
			// starting angles of initial animation set to zero
			this.params.startAngX = 0;
			this.params.startAngY = 0;
			// ending angles of initial animation set to zero, too
			this.params.endAngX = 0;
			this.params.endAngY = 0;
			// initial camera angles applicable, for no initial animation, set to zero
			this.params.cameraAngX = 0;
			this.params.cameraAngY = 0;
		}
		// lighting angles                                
		this.params.lightAngX = getFN(atts["lightangx"], 20);
		this.params.lightAngY = getFN(atts["lightangy"], 0);
		// lighting intensity effect (Range: 0 - 10)
		this.params.intensity = getFN(atts["intensity"], 2.5);
		// columns clustered or overlaid
		this.params.clustered = toBoolean(getFN(atts["clustered"], 0));
		// gap between axes edges and axes labels/axes names
		this.params.xGapLabel = Math.abs(getFN(atts["xlabelgap"], 5));
		this.params.yGapLabel = Math.abs(getFN(atts["ylabelgap"], 5));
		// axes wall thickness
		// x wall
		this.params.yzWallDepth = Math.abs(getFN(atts["yzwalldepth"], atts["xwalldepth"], 10));
		// y wall
		this.params.zxWallDepth = Math.abs(getFN(atts["zxwalldepth"], atts["ywalldepth"], 10));
		// z wall
		this.params.xyWallDepth = Math.abs(getFN(atts["xywalldepth"], atts["zwalldepth"], 10));
		// z gap between 2 series
		this.params.zGapPlot = Math.abs(Math.round(getFN(atts["zgapplot"], 10)));
		// data items z depth/thickness
		this.params.zDepth = Math.abs(Math.round(getFN(atts["zdepth"], 30)));
		// relative stacking preference of chart3D with other elements like caption, sub-caption and legend.
		this.params.chartOnTop = toBoolean(getFN(atts["chartontop"], 1));
		// should the chart be best fitted within the canvas space, both initially and due rotational interactions
		this.params.autoScaling = toBoolean(getFN(atts["autoscaling"], 1));
		// world lighting
		this.params.worldLighting = !(toBoolean(getFN(atts["dynamicshading"], 0)));
		// effect to beautify divLines
		this.params.divLineEffect = (getFV(atts["divlineeffect"], "none")).toUpperCase();
		// to contrain rotation about x-axis 
		this.params.constrainXRotation = toBoolean(getFN(atts["constrainverticalrotation"], 0));
		// constraining limits for rotation about x-axis
		this.params.minXRotAngle = getFN(atts["minverticalrotangle"], -90);
		this.params.maxXRotAngle = getFN(atts["maxverticalrotangle"], 90);
		// to contrain rotation about y-axis 
		this.params.constrainYRotation = toBoolean(getFN(atts["constrainhorizontalrotation"], 0));
		// constraining limits for rotation about y-axis
		this.params.minYRotAngle = getFN(atts["minhorizontalrotangle"], -90);
		this.params.maxYRotAngle = getFN(atts["maxhorizontalrotangle"], 90);
		// if chart be rotation enabled for its life time
		this.params.allowRotation = toBoolean(getFN(atts["allowrotation"], 1));
		// if chart be scaling enabled for its life time
		this.params.allowScaling = toBoolean(getFN(atts["allowscaling"], 1));
		// appearance of zeroplane be mesh or plane
		this.params.zeroPlaneMesh = toBoolean(getFN(atts["zeroplanemesh"], 1));
		// stack order of different chart types ... first is topmost (front view)
		this.params.arrChartOrder = this.validateChartOrder(((getFV(StringExt.removeSpaces(atts["chartorder"]), "line,column,area")).toUpperCase()).split(','));
		// if bright 2D view is required, will override lighting angles
		this.params.bright2D = toBoolean(getFN(atts["bright2d"], 0));
		// For bright 2D view in default angles, adjacent walls may be indistinguishable due equi-incident angles
		// of light illuminating them. So, set the issue. Angles be changed slightly.
		if (this.params.bright2D && !this.params.worldLighting) {
			// 
			if (this.params.startAngX == 30) {
				this.params.startAngX -= 10;
			}
			if (this.params.startAngY == -45) {
				this.params.startAngY += 10;
			}
			//                              
			if (this.params.endAngX == 30) {
				this.params.endAngX -= 10;
			}
			if (this.params.endAngY == -45) {
				this.params.endAngY += 10;
			}
			//                             
			if (this.params.cameraAngX == 30) {
				this.params.cameraAngX -= 10;
			}
			if (this.params.cameraAngY == -45) {
				this.params.cameraAngY += 10;
			}
		}
		//-----------------------------------------------//                              
	}
	/**
	 * validateClustered checks to reset "clustered" param.
	 */
	private function validateClustered():Void{
		// checking over if total number of COLUMN series is more than one
		this.config.clustered = (this.numColDS>1)?this.params.clustered :false
	}
	/**
	 * validateDataset method checks for if number of data
	 * provided per series from XML is greater than the 
	 * number of categories.
	 */
	private function validateDataset():Void {
		// iterate over the dataset
		for (var i = 1; i < this.dataset.length; ++i) {
			// check over if number of data in the series is greater than the number of categories
			if (this.dataset[i]['data'].length - 1 > this.num) {
				// strip off extra data
				this.dataset[i]['data'].splice(this.num + 1);
				// strip off data at zero index if any (actually comes in due Array.splice() above)
				delete this.dataset[i]['data'][0];
			}
		}
	}
	/**
	 * validateChartOrder method validates the stack order
	 * of the chart types provided through XML.
	 * @param	arrOrder	chart order from XML parsing
	 * @return				validated chart order
	 */
	private function validateChartOrder(arrOrder:Array):Array {
		var strType:String;
		// different chart types to work with (in default order)
		var arrTypes:Array = ['LINE', 'COLUMN', 'AREA'];
		// container to hold validated chart order
		var arrFinalOrder:Array = new Array();
		// iterate over the passed chart order
		for (var i = 0; i < arrOrder.length; ++i) {
			// the chart type
			strType = arrOrder[i];
			// iterate over all applicable types
			for (var j = 0; j < arrTypes.length; ++j) {
				// check if the type matches with the XML provided one
				if (arrTypes[j] == strType) {
					// taken in final order
					arrFinalOrder.push(strType);
					// the particular type is removed from available applicable types, for further processing
					arrTypes.splice(j, 1);
					// done for this chart type, go for next
					break;
				}
			}
			// if all types are already obtained in the final order listing
			if (arrFinalOrder.length == arrTypes.length) {
				// stop processing of final order listing
				break;
			}
		}
		// but, if not all types are in final order list
		if (arrFinalOrder.length < 3) {
			// fill in rest in order from remains of default chart order
			for (var j = 0; j < arrTypes.length; ++j) {
				arrFinalOrder.push(arrTypes[j]);
			}
		}
		// return final order      
		return arrFinalOrder;
	}
	/**
	* getMaxDataValue method gets the maximum y-axis data value present
	* in the data.
	* @return		The maximum value present in the data provided.
	*/
	private function getMaxDataValue():Number {
		var maxValue:Number;
		var firstNumberFound:Boolean = false;
		var i:Number, j:Number;
		for (i = 1; i <= this.numDS; i++) {
			for (j = 1; j <= this.num; j++) {
				//By default assume the first non-null number to be maximum
				if (firstNumberFound == false) {
					if (this.dataset[i].data[j].isDefined == true) {
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be maximum.
						maxValue = this.dataset[i].data[j].value;
					}
				} else {
					//If the first number has been found and the current data is defined, compare
					if (this.dataset[i].data[j].isDefined) {
						//Store the greater number
						maxValue = (this.dataset[i].data[j].value > maxValue) ? this.dataset[i].data[j].value : maxValue;
					}
				}
			}
		}
		return maxValue;
	}
	/**
	* getMinDataValue method gets the minimum y-axis data value present
	* in the data
	* @reurns		The minimum value present in data
	*/
	private function getMinDataValue():Number {
		var minValue:Number;
		var firstNumberFound:Boolean = false;
		var i:Number, j:Number;
		for (i = 1; i <= this.numDS; i++) {
			for (j = 1; j <= this.num; j++) {
				//By default assume the first non-null number to be minimum
				if (firstNumberFound == false) {
					if (this.dataset[i].data[j].isDefined == true) {
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be minimum.
						minValue = this.dataset[i].data[j].value;
					}
				} else {
					//If the first number has been found and the current data is defined, compare
					if (this.dataset[i].data[j].isDefined) {
						//Store the lesser number
						minValue = (this.dataset[i].data[j].value < minValue) ? this.dataset[i].data[j].value : minValue;
					}
				}
			}
		}
		return minValue;
	}
	/**
	* calculateAxisLimits method sets the axis limits for the chart.
	* It gets the minimum and maximum value specified in data and
	* based on that it calls super.getAxisLimits();
	*/
	private function calculateAxisLimits():Void {
		this.getAxisLimits(this.getMaxDataValue(), this.getMinDataValue(), true, !this.params.setAdaptiveYMin);
	}
	/**
	* setStyleDefaults method sets the default values for styles or
	* extracts information from the attributes and stores them into
	* style objects.
	*/
	private function setStyleDefaults():Void {
		//Default font object for Caption
		//-----------------------------------------------------------------//
		var captionFont = new StyleObject();
		captionFont.name = "_SdCaptionFont";
		captionFont.align = "center";
		captionFont.valign = "top";
		captionFont.bold = "1";
		captionFont.font = this.params.outCnvBaseFont;
		captionFont.size = this.params.outCnvBaseFontSize;
		captionFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.CAPTION, captionFont, this.styleM.TYPE.FONT, null);
		delete captionFont;
		//-----------------------------------------------------------------//
		//Default font object for SubCaption
		//-----------------------------------------------------------------//
		var subCaptionFont = new StyleObject();
		subCaptionFont.name = "_SdSubCaptionFont";
		subCaptionFont.align = "center";
		subCaptionFont.valign = "top";
		subCaptionFont.bold = "1";
		subCaptionFont.font = this.params.outCnvBaseFont;
		subCaptionFont.size = this.params.outCnvBaseFontSize;
		subCaptionFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.SUBCAPTION, subCaptionFont, this.styleM.TYPE.FONT, null);
		delete subCaptionFont;
		//-----------------------------------------------------------------//
		//Default font object for YAxisName
		//-----------------------------------------------------------------//
		var yAxisNameFont = new StyleObject();
		yAxisNameFont.name = "_SdYAxisNameFont";
		yAxisNameFont.align = "center";
		yAxisNameFont.valign = "middle";
		yAxisNameFont.bold = "1";
		yAxisNameFont.font = this.params.outCnvBaseFont;
		yAxisNameFont.size = this.params.outCnvBaseFontSize;
		yAxisNameFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.YAXISNAME, yAxisNameFont, this.styleM.TYPE.FONT, null);
		delete yAxisNameFont;
		//-----------------------------------------------------------------//
		//Default font object for XAxisName
		//-----------------------------------------------------------------//
		var xAxisNameFont = new StyleObject();
		xAxisNameFont.name = "_SdXAxisNameFont";
		xAxisNameFont.align = "center";
		xAxisNameFont.valign = "middle";
		xAxisNameFont.bold = "1";
		xAxisNameFont.font = this.params.outCnvBaseFont;
		xAxisNameFont.size = this.params.outCnvBaseFontSize;
		xAxisNameFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.XAXISNAME, xAxisNameFont, this.styleM.TYPE.FONT, null);
		delete xAxisNameFont;
		//-----------------------------------------------------------------//
		//Default font object for trend lines
		//-----------------------------------------------------------------//
		var trendFont = new StyleObject();
		trendFont.name = "_SdTrendFontFont";
		trendFont.font = this.params.outCnvBaseFont;
		trendFont.size = this.params.outCnvBaseFontSize;
		trendFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.TRENDVALUES, trendFont, this.styleM.TYPE.FONT, null);
		delete trendFont;
		//-----------------------------------------------------------------//
		//Default font object for yAxisValues
		//-----------------------------------------------------------------//
		var yAxisValuesFont = new StyleObject();
		yAxisValuesFont.name = "_SdYAxisValuesFont";
		yAxisValuesFont.align = "right";
		yAxisValuesFont.valign = "middle";
		yAxisValuesFont.font = this.params.outCnvBaseFont;
		yAxisValuesFont.size = this.params.outCnvBaseFontSize;
		yAxisValuesFont.color = this.params.outCnvBaseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.YAXISVALUES, yAxisValuesFont, this.styleM.TYPE.FONT, null);
		delete yAxisValuesFont;
		//-----------------------------------------------------------------//
		//Default font object for DataLabels
		//-----------------------------------------------------------------//
		var dataLabelsFont = new StyleObject();
		dataLabelsFont.name = "_SdDataLabelsFont";
		dataLabelsFont.align = "center";
		dataLabelsFont.valign = "bottom";
		dataLabelsFont.font = this.params.catFont;
		dataLabelsFont.size = this.params.catFontSize;
		dataLabelsFont.color = this.params.catFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.DATALABELS, dataLabelsFont, this.styleM.TYPE.FONT, null);
		delete dataLabelsFont;
		//-----------------------------------------------------------------//
		//Default font object for Legend
		//-----------------------------------------------------------------//
		var legendFont = new StyleObject();
		legendFont.name = "_SdLegendFont";
		legendFont.font = this.params.outCnvBaseFont;
		legendFont.size = this.params.outCnvBaseFontSize;
		legendFont.color = this.params.outCnvBaseFontColor;
		legendFont.ishtml = 1;
		legendFont.leftmargin = 3;
		//Over-ride
		this.styleM.overrideStyle(this.objects.LEGEND, legendFont, this.styleM.TYPE.FONT, null);
		delete legendFont;
		//-----------------------------------------------------------------//
		//Default font object for DataValues
		//-----------------------------------------------------------------//
		var dataValuesFont = new StyleObject();
		dataValuesFont.name = "_SdDataValuesFont";
		dataValuesFont.align = "center";
		dataValuesFont.valign = "middle";
		dataValuesFont.font = this.params.baseFont;
		dataValuesFont.size = this.params.baseFontSize;
		dataValuesFont.color = this.params.baseFontColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.DATAVALUES, dataValuesFont, this.styleM.TYPE.FONT, null);
		delete dataValuesFont;
		//-----------------------------------------------------------------//
		//Default font object for ToolTip
		//-----------------------------------------------------------------//
		var toolTipFont = new StyleObject();
		toolTipFont.name = "_SdToolTipFont";
		toolTipFont.font = this.params.baseFont;
		toolTipFont.size = this.params.baseFontSize;
		toolTipFont.color = this.params.baseFontColor;
		toolTipFont.bgcolor = this.params.toolTipBgColor;
		toolTipFont.bordercolor = this.params.toolTipBorderColor;
		//Over-ride
		this.styleM.overrideStyle(this.objects.TOOLTIP, toolTipFont, this.styleM.TYPE.FONT, null);
		delete toolTipFont;
		//-----------------------------------------------------------------//
		//Default Effect (Shadow) object for Legend
		//-----------------------------------------------------------------//
		if (this.params.legendShadow) {
			var legendShadow = new StyleObject();
			legendShadow.name = "_SdLegendShadow";
			legendShadow.distance = 2;
			legendShadow.alpha = 90;
			legendShadow.angle = 45;
			//Over-ride
			this.styleM.overrideStyle(this.objects.LEGEND, legendShadow, this.styleM.TYPE.SHADOW, null);
			delete legendShadow;
		}
		//-----------------------------------------------------------------//                                            
	}
	/**
	* calcVLinesPos method calculates the x position for the various
	* vLines defined. Also, it validates them.
	*/
	private function calcVLinesPos():Void {
		var i:Number;
		//Iterate through all the vLines
		for (i = 1; i <= numVLines; i++) {
			//If the vLine is after 1st data and before last data
			if (this.vLines[i].index > 0 && this.vLines[i].index < this.num) {
				//Set it's x position
				this.vLines[i].x = this.categories[this.vLines[i].index].x + (this.categories[this.vLines[i].index + 1].x - this.categories[this.vLines[i].index].x) / 2;
			} else {
				//Invalidate it
				this.vLines[i].isValid = false;
			}
		}
	}
	/**
	* calculatePoints method calculates the various points on the chart.
	*/
	private function calculatePoints():Void {
		//Loop variable
		var i:Number, j:Number;
		//Feed empty data - By default there should be equal number of <categories>
		//and <set> element within each dataset. If in case, <set> elements fall short,
		//we need to append empty data at the end.
		for (i = 1; i <= this.numDS; i++) {
			for (j = 1; j <= this.num; j++) {
				if (this.dataset[i].data[j] == undefined) {
					this.dataset[i].data[j] = this.returnDataAsObject(NaN);
				}
			}
		}
		//Format all the numbers on the chart and store their display values
		//We format and store here itself, so that later, whenever needed,
		//we just access displayValue instead of formatting once again.
		//Also set tool tip text values
		var toolText:String;
		for (i = 1; i <= this.numDS; i++) {
			for (j = 1; j <= this.num; j++) {
				//Format and store
				this.dataset[i].data[j].displayValue = formatNumber(this.dataset[i].data[j].value, this.params.formatNumber, this.params.decimals, this.params.forceDecimals, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
				//Store another copy of formatted value
				this.dataset[i].data[j].formattedValue = this.dataset[i].data[j].displayValue;
				//Tool tip text.
				//Preferential Order - Set Tool Text (No concatenation) > SeriesName + Cat Name + Value
				if (this.dataset[i].data[j].toolText == undefined || this.dataset[i].data[j].toolText == "") {
					//If the tool tip text is not already defined
					//If labels have been defined
					toolText = (this.params.seriesNameInToolTip && this.dataset[i].seriesName != "") ? (this.dataset[i].seriesName + this.params.toolTipSepChar) : "";
					toolText = toolText + ((this.categories[j].toolText != "") ? (this.categories[j].toolText + this.params.toolTipSepChar) : "");
					toolText = toolText + this.dataset[i].data[j].displayValue;
					this.dataset[i].data[j].toolText = toolText;
				}
				if (this.dataset[i].data[j].exDispVal != "") {
					this.dataset[i].data[j].displayValue = this.dataset[i].data[j].exDispVal;
				}
			}
		}
		//Based on label step, set showLabel of each data point as required.
		//Visible label count
		var visibleCount:Number = 0;
		var finalVisibleCount:Number = 0;
		for (i = 1; i <= this.num; i++) {
			//Now, the label can be preset to be hidden (set via XML)
			if (this.categories[i].showLabel) {
				visibleCount++;
				//If label step is defined, we need to set showLabel of those
				//labels which fall on step as false.
				if ((i - 1) % this.params.labelStep == 0) {
					this.categories[i].showLabel = true;
				} else {
					this.categories[i].showLabel = false;
				}
			}
			//Update counter                                        
			finalVisibleCount = (this.categories[i].showLabel) ? (finalVisibleCount + 1) : (finalVisibleCount);
		}
		//------------------------------  CANVAS  ------------------------------------------//
		//We now need to calculate the available Width on the canvas.
		//Available width = total Chart width minus the list below
		// - Left and Right Margin
		// - yAxisName (if to be shown)
		// - yAxisValues
		// - Trend line display values (both left side and right side).
		// - Legend (If to be shown at right)
		var canvasWidth:Number = this.width - (this.params.chartLeftMargin + this.params.chartRightMargin);
		//Set canvas startX
		var canvasStartX:Number = this.params.chartLeftMargin;
		//Now, if y-axis name is to be shown, simulate it and get the width
		if (this.params.yAxisName != "") {
			//Get style object
			var yAxisNameStyle : Object = this.styleM.getTextStyle (this.objects.YAXISNAME);
			//Create text field to get width
			var yAxisNameObj:Object = createText(true, this.params.yAxisName, this.tfTestMC, 1, testTFX, testTFY, 90, yAxisNameStyle, false, 0, 0);
			//Accomodate width and padding
			canvasStartX = canvasStartX + yAxisNameObj.width + this.params.yAxisNamePadding;
			canvasWidth = canvasWidth - yAxisNameObj.width - this.params.yAxisNamePadding;
			//Create element for yAxisName - to store width/height
			this.elements.yAxisName = returnDataAsElement(0, 0, yAxisNameObj.width, yAxisNameObj.height);
			delete yAxisNameStyle;
			delete yAxisNameObj;
		}
		//Accomodate width and padding   
		canvasStartX = canvasStartX + this.params.zxWallDepth;
		canvasWidth = canvasWidth - this.params.zxWallDepth;
		//Accomodate width for y-axis values. Now, y-axis values conists of two parts                                    
		//(for backward compatibility) - limits (upper and lower) and div line values.
		//So, we'll have to individually run through both of them.
		var yAxisValMaxWidth:Number = 0;
		var divLineObj:Object;
		var divStyle:Object = this.styleM.getTextStyle(this.objects.YAXISVALUES);
		//Iterate through all the div line values
		for (i = 0; i < this.divLines.length; i++) {
			//If div line value is to be shown
			if (this.divLines[i].showValue) {
				//If it's the first or last div Line (limits), and it's to be shown
				if ((i == 0) || (i == this.divLines.length - 1)) {
					if (this.params.showLimits) {
						//Get the width of the text
						divLineObj = createText(true, this.divLines[i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, divStyle, false, 0, 0);
						//Accomodate
						yAxisValMaxWidth = (divLineObj.width > yAxisValMaxWidth) ? (divLineObj.width) : (yAxisValMaxWidth);
					} else {
						this.divLines[i].showValue = false;
					}
				} else {
					//It's a div interval - div line
					//So, check if we've to show div line values
					if (this.params.showDivLineValues) {
						//Get the width of the text
						divLineObj = createText(true, this.divLines[i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, divStyle, false, 0, 0);
						//Accomodate
						yAxisValMaxWidth = (divLineObj.width > yAxisValMaxWidth) ? (divLineObj.width) : (yAxisValMaxWidth);
					} else {
						this.divLines[i].showValue = false;
					}
				}
			}
		}
		delete divLineObj;
		//Also iterate through all trend lines whose values are to be shown on
		//left side of the canvas.
		//Get style object
		var trendStyle:Object = this.styleM.getTextStyle(this.objects.TRENDVALUES);
		var trendObj:Object;
		for (i = 1; i <= this.numTrendLines; i++) {
			if (this.trendLines[i].isValid == true && this.trendLines[i].valueOnRight == false) {
				//If it's a valid trend line and value is to be shown on left
				//Get the width of the text
				trendObj = createText(true, this.trendLines[i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, trendStyle, false, 0, 0);
				//Accomodate
				yAxisValMaxWidth = (trendObj.width > yAxisValMaxWidth) ? (trendObj.width) : (yAxisValMaxWidth);
			}
		}
		//Accomodate for y-axis/left-trend line values text width
		if (yAxisValMaxWidth > 0) {
			canvasStartX = canvasStartX + yAxisValMaxWidth + this.params.yAxisValuesPadding;
			canvasWidth = canvasWidth - yAxisValMaxWidth - this.params.yAxisValuesPadding;
		}
		var trendRightWidth:Number = 0;
		//Now, also check for trend line values that fall on right
		for (i = 1; i <= this.numTrendLines; i++) {
			if (this.trendLines[i].isValid == true && this.trendLines[i].valueOnRight == true) {
				//If it's a valid trend line and value is to be shown on right
				//Get the width of the text
				trendObj = createText(true, this.trendLines[i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, trendStyle, false, 0, 0);
				//Accomodate
				trendRightWidth = (trendObj.width > trendRightWidth) ? (trendObj.width) : (trendRightWidth);
			}
		}
		delete trendObj;
		//Accomodate trend right text width
		if (trendRightWidth > 0) {
			canvasWidth = canvasWidth - trendRightWidth - this.params.yAxisValuesPadding;
		}
		//Round them off finally to avoid distorted pixels                                        
		canvasStartX = int(canvasStartX);
		canvasWidth = int(canvasWidth);
		//We finally have canvas Width and canvas Start X
		//-----------------------------------------------------------------------------------//
		//Now, we need to calculate the available Height on the canvas.
		//Available height = total Chart height minus the list below
		// - Chart Top and Bottom Margins
		// - Space for Caption, Sub Caption and caption padding
		// - Height of data labels
		// - xAxisName
		// - Legend (If to be shown at bottom position)
		//Initialize canvasHeight to total height minus margins
		var canvasHeight:Number = this.height - (this.params.chartTopMargin + this.params.chartBottomMargin + this.params.yzWallDepth);
		//Set canvasStartY
		var canvasStartY:Number = this.params.chartTopMargin;
		//Now, if we've to show caption
		if (this.params.caption != "") {
			//Create text field to get height
			var captionObj:Object = createText(true, this.params.caption, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle(this.objects.CAPTION), true, canvasWidth, canvasHeight/4);
			//Store the height
			canvasStartY = canvasStartY + captionObj.height;
			canvasHeight = canvasHeight - captionObj.height;
			//Create element for caption - to store width & height
			this.elements.caption = returnDataAsElement(0, 0, captionObj.width, captionObj.height);
			delete captionObj;
		}
		//Now, if we've to show sub-caption                                        
		if (this.params.subCaption != "") {
			//Create text field to get height
			var subCaptionObj:Object = createText(true, this.params.subCaption, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle(this.objects.SUBCAPTION), true, canvasWidth, canvasHeight/4);
			//Store the height
			canvasStartY = canvasStartY + subCaptionObj.height;
			canvasHeight = canvasHeight - subCaptionObj.height;
			//Create element for sub caption - to store height
			this.elements.subCaption = returnDataAsElement(0, 0, subCaptionObj.width, subCaptionObj.height);
			delete subCaptionObj;
		}
		//Now, if either caption or sub-caption was shown, we also need to adjust caption padding                                        
		if (this.params.caption != "" || this.params.subCaption != "") {
			//Account for padding
			canvasStartY = canvasStartY + this.params.captionPadding;
			canvasHeight = canvasHeight - this.params.captionPadding;
		}
		//Now, if data labels are to be shown, we need to account for their heights                                        
		//Data labels can be rendered in 3 ways:
		//1. Normal - no staggering - no wrapping - no rotation
		//2. Wrapped - no staggering - no rotation
		//3. Staggered - no wrapping - no rotation
		//4. Rotated - no staggering - no wrapping
		//Placeholder to store max height
		this.config.maxLabelHeight = 0;
		this.config.labelAreaHeight = 0;
		var labelObj:Object;
		var labelStyleObj:Object = this.styleM.getTextStyle(this.objects.DATALABELS);
		//We iterate through all the labels, and if any of them has &lt or < (HTML marker)
		//embedded in them, we add them to the array, as for them, we'll need to individually
		//create and see the text height. Also, the first element in the array - we set as
		//ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_=....
		//Create array to store labels.
		var strLabels:Array = new Array();
		strLabels.push("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_=/*-+~`");
		//Now, iterate through all the labels and for those visible labels, whcih have < sign,
		//add it to array.
		for (i = 1; i <= this.num; i++) {
			//If the label is to be shown
			if (this.categories[i].showLabel) {
				this.labelOn = true;
				if ((this.categories[i].label.indexOf("&lt;") > -1) || (this.categories[i].label.indexOf("<") > -1)) {
					strLabels.push(this.categories[i].label);
				}
			}
		}
		//Now, we've the array for which we've to check height (for each element).
		for (i = 0; i < strLabels.length; i++) {
			//Create text box and get height
			labelObj = createText(true, this.categories[i].label, this.tfTestMC, 1, testTFX, testTFY, 0, labelStyleObj, false, 0, 0);
			//Store the larger
			this.config.maxLabelHeight = (labelObj.height > this.config.maxLabelHeight) ? (labelObj.height) : (this.config.maxLabelHeight);
		}
		//We now have the max label height. 
		this.config.labelAreaHeight = this.config.maxLabelHeight;
		if (this.config.labelAreaHeight > 0 && this.labelOn) {
			//Deduct the calculated label height from canvas height
			canvasHeight = canvasHeight - this.config.labelAreaHeight - this.params.labelPadding;
		}
		//Delete objects                                        
		delete labelObj;
		delete labelStyleObj;
		//Accomodate space for xAxisName (if to be shown);
		if (this.params.xAxisName != "") {
			//Create text field to get height
			var xAxisNameObj:Object = createText(true, this.params.xAxisName, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle(this.objects.XAXISNAME), false, 0, 0);
			//Store the height
			canvasHeight = canvasHeight - xAxisNameObj.height - this.params.xAxisNamePadding;
			//Object to store width and height of xAxisName
			this.elements.xAxisName = returnDataAsElement(0, 0, xAxisNameObj.width, xAxisNameObj.height);
			delete xAxisNameObj;
		}
		this.config.labelAreaHeight - this.params.labelPadding;
		this.elements.xAxisName.height - this.params.xAxisNamePadding;
		//We have canvas start Y and canvas height     
		//We now check whether the legend is to be drawn
		if (this.params.showLegend) {
			//Object to store dimensions
			var lgndDim:Object;
			//Create container movie clip for legend
			this.lgndMC = this.cMC.createEmptyMovieClip("Legend", this.dm.getDepth("LEGEND"));
			//Create instance of legend
			if (this.params.legendPosition == "BOTTOM") {
				//Maximum Height - 50% of stage
				lgnd = new InteractiveLegend(lgndMC, this.styleM.getTextStyle(this.objects.LEGEND), this.params.interactiveLegend, this.params.legendPosition, canvasStartX + canvasWidth / 2, this.height / 2, canvasWidth, (this.height - (this.params.chartTopMargin + this.params.chartBottomMargin)) * 0.5, this.params.legendAllowDrag, this.width, this.height, this.params.legendBgColor, this.params.legendBgAlpha, this.params.legendBorderColor, this.params.legendBorderThickness, this.params.legendBorderAlpha, this.params.legendScrollBgColor, this.params.legendScrollBarColor, this.params.legendScrollBtnColor, this.config.clustered);
			} else {
				//Maximum Width - 40% of stage
				lgnd = new InteractiveLegend(lgndMC, this.styleM.getTextStyle(this.objects.LEGEND), this.params.interactiveLegend, this.params.legendPosition, this.width / 2, canvasStartY + canvasHeight / 2, (this.width - (this.params.chartLeftMargin + this.params.chartRightMargin)) * 0.4, canvasHeight, this.params.legendAllowDrag, this.width, this.height, this.params.legendBgColor, this.params.legendBgAlpha, this.params.legendBorderColor, this.params.legendBorderThickness, this.params.legendBorderAlpha, this.params.legendScrollBgColor, this.params.legendScrollBarColor, this.params.legendScrollBtnColor, this.config.clustered);
			}
			// get sorted data for legend rendering
			var arrdataLgnd:Array = this.sortForLgnd();
			//Feed data set series Name for legend
			for (var i = 0; i < arrdataLgnd.length; i++) {
				if (arrdataLgnd[i]['includeInLegend'] && arrdataLgnd[i]['seriesName'] != "") {
					this.lgnd.addItem(arrdataLgnd[i]['seriesName'], (arrdataLgnd[i]['color']).toString(16), i, arrdataLgnd[i]['showValues'], arrdataLgnd[i]['type']);
				}
			}
			//If user has defined a caption for the legend, set it
			if (this.params.legendCaption != "") {
				lgnd.setCaption(this.params.legendCaption);
			}
			//Whether to use circular marker                                        
			lgnd.useCircleMarker(this.params.legendMarkerCircle);
			if (this.params.legendPosition == "BOTTOM") {
				lgndDim = lgnd.getDimensions();
				//Now deduct the height from the calculated canvas height
				canvasHeight = canvasHeight - lgndDim.height - this.params.legendPadding;
				//Re-set the legend position
				this.lgnd.resetXY(canvasStartX + canvasWidth / 2, this.height - this.params.chartBottomMargin - lgndDim.height / 2);
			} else {
				//Get dimensions
				lgndDim = lgnd.getDimensions();
				//Now deduct the width from the calculated canvas width
				canvasWidth = canvasWidth - lgndDim.width - this.params.legendPadding;
				//Right position
				this.lgnd.resetXY(this.width - this.params.chartRightMargin - lgndDim.width / 2, canvasStartY + canvasHeight / 2);
			}
		}
		//Create an element to represent the canvas now.                                        
		this.elements.canvas = returnDataAsElement(canvasStartX, canvasStartY, canvasWidth, canvasHeight);
		//Base Plane position - Base plane is the y-plane from which columns start.
		//If there's a 0 value in between yMin,yMax, base plane represents 0 value.
		//Else, it's yMin
		if (this.config.yMax >= 0 && this.config.yMin < 0) {
			//Negative number present - so set basePlanePos as 0 value
			this.config.basePlanePos = this.getAxisPosition(0, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
		} else {
			//No negative numbers - so set basePlanePos as yMin value
			this.config.basePlanePos = this.getAxisPosition(this.config.yMin, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
		}
		//----------------------------------- PLOT -------------------------------------------------//
		//Now, if we've any columns on the chart, then the x-position of category names,
		//lines and areas would be dependent on x of column. Else, they would be equally
		//distributed over x of canvas (considering canvasPadding)
		if (this.numColDS > 0) {
			//Now, calculate the spacing on canvas and individual column width
			var plotSpace:Number = (this.params.plotSpacePercent / 100) * this.elements.canvas.w;
			//Block Width
			var blockWidth:Number = (this.elements.canvas.w - plotSpace) / this.num;
			//Individual column space.
			var columnWidth:Number = (this.config.clustered) ? blockWidth / this.numColDS : blockWidth;
			//We finally have total plot space and column width
			//Store it in config
			this.config.plotSpace = plotSpace;
			this.config.blockWidth = blockWidth;
			this.config.columnWidth = columnWidth;
			//Get space between two blocks
			var interBlockSpace:Number = plotSpace / (this.num + 1);
			//Store in config.
			this.config.interBlockSpace = interBlockSpace;
			var dataEndY:Number;
			//Now, store the positions of the columns
			for (i = 1; i <= this.num; i++) {
				//Store position of categories
				this.categories[i].x = this.elements.canvas.x + (interBlockSpace * i) + (blockWidth * (i - 0.5));
				var colCounter:Number = 0;
				for (j = 1; j <= this.numDS; j++) {
					//If it's column dataset
					if (this.dataset[j].renderAs == "COLUMN") {
						if (this.config.clustered) {
							//Increment column counter
							colCounter++;
							//X-Position
							this.dataset[j].data[i].x = this.elements.canvas.x + (interBlockSpace * i) + columnWidth * (colCounter - 0.5) + (columnWidth * this.numColDS * (i - 1));
						} else {
							//X-Position
							this.dataset[j].data[i].x = this.elements.canvas.x + (interBlockSpace * i) + columnWidth * (i - 0.5);
							//this.dataset [j].data [i].x = this.categories [i].x;
						}
						//Set the y position
						this.dataset[j].data[i].y = this.config.basePlanePos;
						//Height for each column
						dataEndY = this.getAxisPosition(this.dataset[j].data[i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
						//Negate to cancel Flash's reverse Y Co-ordinate system
						this.dataset[j].data[i].h = -(dataEndY - this.config.basePlanePos);
						//Width - Deduct 1 from width to allot some space between two columns
						this.dataset[j].data[i].w = columnWidth;
						//Store value textbox y position
						this.dataset[j].data[i].valTBY = dataEndY;
					}
				}
			}
			//Now, based on column x position, calculate line and area positions
			//Store y-max and y-min positions for data
			this.config.yMaxPos = 0;
			this.config.yMinPos = 0;
			//Now, store the positions of the lines/areas
			for (i = 1; i <= this.numDS; i++) {
				if (this.dataset[i].renderAs != "COLUMN") {
					for (j = 1; j <= this.num; j++) {
						//X-Position
						this.dataset[i].data[j].x = this.categories[j].x;
						//Set the y position
						this.dataset[i].data[j].y = this.getAxisPosition(this.dataset[i].data[j].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
						//Store max and min positions for use in animation position - if area dataset
						if (this.dataset[i].renderAs == "AREA") {
							this.config.yMaxPos = (this.dataset[i].data[j].y > this.config.yMaxPos) ? this.dataset[i].data[j].y : this.config.yMaxPos;
							this.config.yMinPos = (this.dataset[i].data[j].y < this.config.yMinPos) ? this.dataset[i].data[j].y : this.config.yMinPos;
						}
						//Store value textbox y position                                        
						this.dataset[i].data[j].valTBY = this.dataset[i].data[j].y;
					}
				}
			}
		} else {
			//Completely different set of calculation - just for area and line
			//We now need to calculate the position of area points on the chart.
			//Now, calculate the width between two points on chart
			var interPointWidth:Number = (this.elements.canvas.w - (2 * this.params.canvasPadding)) / (this.num - 1);
			//Store y-max and y-min positions for data
			this.config.yMaxPos = 0;
			this.config.yMinPos = 0;
			//Now, store the positions of the columns
			for (i = 1; i <= this.numDS; i++) {
				for (j = 1; j <= this.num; j++) {
					//X-Position
					//Now, if there is only 1 point on the chart, we center it. Else, we get even X.
					this.dataset[i].data[j].x = (this.num == 1) ? (this.elements.canvas.x + this.elements.canvas.w / 2) : (this.elements.canvas.x + this.params.canvasPadding + (interPointWidth * (j - 1)));
					if (i == 1) {
						this.categories[j].x = this.dataset[i].data[j].x;
					}
					//Set the y position                                        
					this.dataset[i].data[j].y = this.getAxisPosition(this.dataset[i].data[j].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Store max and min positions for use in animation position - if area dataset
					if (this.dataset[i].renderAs == "AREA") {
						this.config.yMaxPos = (this.dataset[i].data[j].y > this.config.yMaxPos) ? this.dataset[i].data[j].y : this.config.yMaxPos;
						this.config.yMinPos = (this.dataset[i].data[j].y < this.config.yMinPos) ? this.dataset[i].data[j].y : this.config.yMinPos;
					}
					//Store value textbox y position                                        
					this.dataset[i].data[j].valTBY = this.dataset[i].data[j].y;
				}
			}
		}
		this.config.lineSegmentWidth = this.setLineSegmentWidth()
	}
	/**
	 * setLineSegmentWidth method is called to evaluate the
	 * normal spacing between two plot points (LINE or AREA)
	 * along x-axis.
	 * @return		the width
	 */
	private function setLineSegmentWidth():Number{
		var xPlot:Number, xNext:Number
		// iterate over each dataset till 2 consecutive valid numeric SET value is found
		for (var i = 1; i <= this.numDS; i++) {
			// checking is primarily for AREA or LINE, for which tooltip mapping is vital
			if (this.dataset[i].renderAs == "AREA" || this.dataset[i].renderAs == "LINE" ) {
				// iterate over each data plot point
				for (var j = 1; j <= this.num; j++) {
					// abscissae of two consecutive points
					xPlot = this.dataset[i].data[j].x
					xNext = this.dataset[i].data[j+1].x
					// if both valid
					if(!(isNaN(xPlot) || isNaN(xNext))){
						// required situation obtained, return width
						return (xNext-xPlot)
					}
				}
			}
		}
		// else return column width (provision for future work)
		return this.config.columnWidth
	}
	/**
	 * sortForLgnd method is to get sorted data for legend 
	 * rendering.
	 * @return		formatted and sorted data for use in legend
	 */
	private function sortForLgnd():Array {
		var arrSeriesData:Array;
		// container for sorted data
		var arrData:Array = new Array();
		// iterate over dataset to sort
		for (var i = 1; i < this.dataset.length; ++i) {
			// container for series specific data
			arrSeriesData = new Array();
			// chart type
			arrSeriesData['type'] = this.dataset[i]["renderAs"];
			// if series be included in legend
			arrSeriesData['includeInLegend'] = this.dataset[i].includeInLegend;
			// series name
			arrSeriesData['seriesName'] = this.dataset[i].seriesName;
			// series color
			arrSeriesData['color'] = parseInt(this.dataset[i]["color"], 16);
			// if data values for the series be shown initially or not
			arrSeriesData['showValues'] = this.dataset[i].showValues;
			// series specific conglomerate stored in with those of others
			arrData.push(arrSeriesData);
		}
		// map container of chart types to its numeric ids to enable sorting
		var objId:Object = new Object();
		// iterate over all type of charts in stack order
		for (var i = 0; i < this.params.arrChartOrder.length; ++i) {
			// mapped
			objId[this.params.arrChartOrder[i]] = this.params.arrChartOrder.length - i;
		}
		// sorting ids inserted
		for (var i = 0; i < arrData.length; ++i) {
			// id for its chart type
			arrData[i]['id'] = objId[arrData[i]['type']];
		}
		// sort about the ids
		this.bubbleSort(arrData, 'id')
		// sorted data returned
		return arrData;
	}
	/**
	 * bubbleSort method sorts the array passed w.r.t "field"
	 * in ascending order.
	 * @param		arrData		array to be sorted
	 * @param		field		field of array to be sorted for
	 */
	private function bubbleSort(arrData:Array, field:String):Void{
		// number of bubble passes left in the soting, also equals the number of array elemnets to be
		// worked on in the bubble phase from array beginning
		var passLeft:Number = arrData.length-1
		// if more bubbling required
		while(passLeft>0){
			// iterate over the array elements
			for(var i=0; i<passLeft; ++i){
				// if current element is greater than the next element
				if(arrData[i][field]>arrData[i+1][field]){
					// swap position to achive ascending order
					arrData.splice(i,0,arrData.splice(i+1,1)[0])
				}
			}
			// update number of bubble phase left
			passLeft--
		}
	}
	//--------------- VISUAL RENDERING METHODS -------------------------//
	/**
	* drawHeaders method renders the following on the chart:
	* CAPTION, SUBCAPTION, XAXISNAME, YAXISNAME
	*/
	private function drawHeaders():Void {
		//Render caption
		if (this.params.caption != "") {
			var captionStyleObj:Object = this.styleM.getTextStyle(this.objects.CAPTION);
			captionStyleObj.align = "center";
			captionStyleObj.vAlign = "bottom";
			var captionObj:Object = createText(false, this.params.caption, this.cMC, this.dm.getDepth("CAPTION"), this.elements.canvas.x + (this.elements.canvas.w / 2), this.params.chartTopMargin, 0, captionStyleObj, true, this.elements.caption.w, this.elements.caption.h);
			//Apply animation
			if (this.params.animation) {
				this.styleM.applyAnimation(captionObj.tf, this.objects.CAPTION, this.macro, this.elements.canvas.x + (this.elements.canvas.w / 2) - (this.elements.caption.w / 2), 0, this.params.chartTopMargin, 0, 100, null, null, null);
			}
			//Apply filters                                        
			this.styleM.applyFilters(captionObj.tf, this.objects.CAPTION);
			//Delete
			delete captionObj;
			delete captionStyleObj;
		}
		//Render sub caption                                        
		if (this.params.subCaption != "") {
			var subCaptionStyleObj:Object = this.styleM.getTextStyle(this.objects.SUBCAPTION);
			subCaptionStyleObj.align = "center";
			subCaptionStyleObj.vAlign = "top";
			var subCaptionObj:Object = createText(false, this.params.subCaption, this.cMC, this.dm.getDepth("SUBCAPTION"), this.elements.canvas.x + (this.elements.canvas.w / 2), this.elements.canvas.y - this.params.captionPadding, 0, subCaptionStyleObj, true, this.elements.subCaption.w, this.elements.subCaption.h);
			//Apply animation
			if (this.params.animation) {
				this.styleM.applyAnimation(subCaptionObj.tf, this.objects.SUBCAPTION, this.macro, this.elements.canvas.x + (this.elements.canvas.w / 2) - (this.elements.subCaption.w / 2), 0, this.elements.canvas.y - this.params.captionPadding - this.elements.subCaption.h, 0, 100, null, null, null);
			}
			//Apply filters                                        
			this.styleM.applyFilters(subCaptionObj.tf, this.objects.SUBCAPTION);
			//Delete
			delete subCaptionObj;
			delete subCaptionStyleObj;
		}
		//Clear Interval                                        
		clearInterval(this.config.intervals.headers);
	}
	/**
	* drawLegend method renders the legend
	*/
	private function drawLegend():Void {
		if (this.params.showLegend) {
			this.lgnd.render();
			//Apply filter
			this.styleM.applyFilters(lgndMC, this.objects.LEGEND);
			//Apply animation
			if (this.params.animation) {
				this.styleM.applyAnimation(lgndMC, this.objects.LEGEND, this.macro, null, 0, null, 0, 100, null, null, null);
			}
			//If it's interactive legend, listen to events                                        
			if (this.params.interactiveLegend) {
				this.lgnd.addEventListener("legendClick", this);
			}
		}
		//Clear interval                                        
		clearInterval(this.config.intervals.legend);
	}
	/**
	* reInit method re-initializes the chart. This method is basically called
	* when the user changes chart data through JavaScript. In that case, we need
	* to re-initialize the chart, set new XML data and again render.
	*/
	public function reInit():Void {
		//Invoke super class's reInit
		super.reInit();
		//Now initialize things that are pertinent to this class
		//but not defined in super class.
		this.categories = new Array();
		this.dataset = new Array();
		//Initialize the number of data elements present
		this.numDS = 0;
		this.numColDS = 0;
		this.numLineDS = 0;
		this.numAreaDS = 0;
		this.num = 0;
		this.numData = 0
		this.lgnd.reset();
	}
	/**
	* remove method removes the chart by clearing the chart movie clip
	* and removing any listeners.
	*/
	public function remove():Void {
		super.remove();
		//Remove class pertinent objects
		if (this.params.interactiveLegend) {
			//Remove listener for legend object.
			this.lgnd.removeEventListener("legendClick", this);
		}
		//Remove class pertinent objects                                        
		this.lgnd.destroy();
		lgndMC.removeMovieClip();
	}
}
