/**
* @class DepthManager
* @author InfoSoft Global (P) Ltd.
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* DepthManager class helps providing methods to manage
* depths.
*/
// imports the MathExt class
import com.fusioncharts.extensions.MathExt;
// imports the Primitive class
import com.fusioncharts.engine3D.Primitive;
// class definition
class com.fusioncharts.engine3D.DepthManager {
	/**
	 * DepthManager constructor.
	 */
	private function DepthManager() {
	}
	/**
	 * setAxesPlusdepths method manage depths of axesPlus 
	 * items like HLines, TLines and VLines, and adds
	 * the depth for each line with its other params 
	 * in the passed param container.
	 * @param	objData		params for tLines, hLines and so
	 */
	public static function setAxesPlusdepths(objData:Object):Void {
		//
		// the number of axes walls, a MC for each, be provided lowest depths. So start
		// leaving this number of depths below.
		var numAxesWalls:Number = 3;
		// number of HLines in the chart
		var numHLines:Number = objData['HLines'].length;
		// level to start for alloting depths to TLines and VLines; HLines must be below other type of lines
		var depthCounter:Number = numHLines + numAxesWalls;
		// container to hold line type data
		var lineData:Array;
		// number of lines for a type
		var num:Number;
		// iterate over the line types
		for (var lineType in objData) {
			// data for a line type
			lineData = objData[lineType];
			// number of lines of the type
			num = lineData.length;
			// iterate for each line of the type
			for (var i = 0; i < num; ++i) {
				// 
				switch (lineType) {
				case 'HLines' :
					// allot depth for HLines
					lineData[i]['depth'] = i + numAxesWalls;
					break;
				case 'TLines' :
				case 'VLines' :
					// allot depth for TLines and VLines
					lineData[i]['depth'] = depthCounter++;
					break;
				}
			}
		}
	}
	/**
	 * getDepths method returns depths of all level of data
	 * for data items after due depth management.
	 * @param	arrData			view transformed data item vertices
	 * @param	arrFaces		set of renderable faces
	 * @param	arrZs			view transformed z values for all series
	 * @param	arrChartType	chart types of series set in order
	 * @param	clustered		if columns be clustered
	 * @param	depthShift		overall depth shift for series
	 * @returns					managed depths
	 */
	public static function getDepths(arrData:Array, arrFaces:Array, arrZs:Array, arrChartType:Array, clustered:Boolean, depthShift:Number):Array {
		// to hold reference of the current chart type
		var strChartType:String;
		// flag to indicate that clustered data is already found
		var clusterFound:Boolean = false;
		// array to be populated and returned                                    
		var arrAllDepths:Array = new Array();
		// container to hold and sort series depths
		var arrSeriesZValues:Array = new Array();
		// number of series
		var numSeries:Number = arrData.length;
		//-------------------------------------//
		// -- inter series depth management -- //
		for (var u = 0; u < numSeries; ++u) {
			// chart type
			strChartType = arrChartType[u];
			//
			// if columns are not required to be clustered
			if (!clustered) {
				// store series characterising z value along with its location id in repository
				arrSeriesZValues.push({id:u, z:arrZs[u][2]});
			} else {
				// else if columns be clustered
				// LINE and AREA will have distinct level entry for each; no clustering effect on them
				if (strChartType == 'LINE' || strChartType == "AREA") {
					// store series characterising z value along with its location id in repository
					arrSeriesZValues.push({id:u, z:arrZs[u][2]});
				} else {
					// else if COLUMN, clustering requires to keep all column series in a single depth
					// if column clustering for any series is yet to begin
					if (!clusterFound) {
						// clustering begins; flag updated
						clusterFound = true;
						// store series characterising z value along with its location id in repository
						arrSeriesZValues.push({id:u, z:arrZs[u][2]});
					} else {
						// none to do
					}
				}
			}
		}
		// sort all series to set their depths w.r.t. each other
		arrSeriesZValues.sortOn('z', 16);
		//-------------------------------------//
		// -- intra series depth management -- //
		// reset flag to false
		clusterFound = false;
		// alias of sub-array
		var arrAllDepths_u:Array;
		// iterating over the series
		for (var u = 0; u < numSeries; ++u) {
			// sub-array created to hold depths for the series
			arrAllDepths_u = arrAllDepths[u] = new Array();
			// if clustering of columns is yet to begin
			if (!clusterFound) {
				// depth of the series, shifted by the specified amount
				arrAllDepths_u['depth'] = DepthManager.getdepthFor(arrSeriesZValues, u) + depthShift;
			} else {
				// if clustering under process
				// series depth is that of the previous one
				arrAllDepths_u['depth'] = arrAllDepths[u - 1]['depth'];
			}
			// container for data item depths
			arrAllDepths_u['children'] = new Array();
			// chart type
			strChartType = arrChartType[u];
			// data items of the series
			var arrSeries:Array = arrData[u];
			// number of data items
			var seriesLength:Number = arrSeries.length;
			// if clustering not required
			if (!clustered) {
				// container for depth sorting of data items
				var arrBlockZValues:Array = new Array();
				// iterate over the data items
				for (var a = 0; a < seriesLength; ++a) {
					// populate container for depth sorting
					arrBlockZValues.push({id:a, z:DepthManager.getFirstZValue(arrSeries[a], strChartType)});
				}
				// sort depths of data items of the series
				arrBlockZValues.sortOn('z', 16);
				// iterate over data items to set their depths
				for (var a = 0; a < seriesLength; ++a) {
					// sub-container for data item depths
					arrAllDepths_u['children'][a] = new Array();
					// get and set the depth
					arrAllDepths_u['children'][a]['depth'] = DepthManager.getdepthFor(arrBlockZValues, a);
					// reference of a whole unit (block/object like cuboid)
					// Sorting of FACES
					arrAllDepths_u['children'][a]['children'] = DepthManager.sortFaces(arrSeries[a], arrFaces[u][a], strChartType);
				}
			} else {
				// else, if clustering need be done
				// for LINE and AREA
				if (strChartType == 'LINE' || strChartType == "AREA") {
					// container for depth sorting of data items
					var arrBlockZValues:Array = new Array();
					// iterate over the data items
					for (var a = 0; a < seriesLength; ++a) {
						// populate container for depth sorting
						arrBlockZValues.push({id:a, z:DepthManager.getFirstZValue(arrSeries[a], strChartType)});
					}
					// sort depths of data items of the series
					arrBlockZValues.sortOn('z', 16);
					// iterate over data items to set their depths
					for (var a = 0; a < seriesLength; ++a) {
						// sub-container for data item depths
						arrAllDepths_u['children'][a] = new Array();
						// get and set the depth
						arrAllDepths_u['children'][a]['depth'] = DepthManager.getdepthFor(arrBlockZValues, a);
						// reference of a whole unit (block/object like cuboid)
						// Sorting of FACES
						arrAllDepths_u['children'][a]['children'] = DepthManager.sortFaces(arrSeries[a], arrFaces[u][a], strChartType);
					}
				} else {
					// else for COLUMN
					// if clustering is yet to begin
					if (!clusterFound) {
						// start series id
						var startId:Number = u;
						// container for depth sorting of data items
						var arrBlockZValues:Array = new Array();
						// update flag
						clusterFound = true;
					}
					// iterate over the data items     
					for (var a = 0; a < seriesLength; ++a) {
						// populate container for depth sorting
						arrBlockZValues.push({idSeries:u, idBlock:a, z:DepthManager.getFirstZValue(arrSeries[a], strChartType)});
					}
					// if next series not of COLUMN type
					if (arrChartType[u + 1] != "COLUMN") {
						// update flag
						clusterFound = false;
						// sort depths of data items of the series
						arrBlockZValues.sortOn('z', 16);
						// iterate over all COLUMN series 
						for (var v = startId; v <= u; ++v) {
							// iterate over data items
							for (var b = 0; b < arrData[u].length; ++b) {
								// container for data item depths
								arrAllDepths[v]['children'][b] = new Array();
								// get and set depth of the data item
								arrAllDepths[v]['children'][b]['depth'] = DepthManager.getdepthFor(arrBlockZValues, v, b);
								// reference of a whole unit (block/object like cuboid)
								// Sorting of FACES
								arrAllDepths[v]['children'][b]['children'] = DepthManager.sortFaces(arrData[v][b], arrFaces[v][b], strChartType);
							}
						}
					}
				}
			}
		}
		// return
		return arrAllDepths;
	}
	/**
	 * sortFaces method is called to manage depths of faces
	 * of data item blocks.
	 * @param	arrObject			data item 3D plot points
	 * @param	arrRenderFaces		faces to be rendered
	 * @param	strChartType		chart type
	 * @return						map of face to depth
	 */
	private static function sortFaces(arrObject:Array, arrRenderFaces:Array, strChartType:String):Object {
		// number of faces
		var facesLength:Number = arrRenderFaces.length;
		// temporary array
		var arrDepths:Array = new Array();
		// to store depths of faces (per unit object)
		var objDepths:Object = new Object();
		// for AREA chart
		if (strChartType == "AREA") {
			// array to hold the z-coordinate values for depth management
			var arrZ:Array = new Array();
			// getting the z-coordinate value for each vertex of the cube (8 vertices)
			for (var i = 0; i < arrObject.length; ++i) {
				arrZ[i] = arrObject[i][2];
			}
			var objZData:Object;
			// total number of faces in the 2D primitive
			var numFaces:Number = arrObject.length / 2;
			var topmostFaceId:Number = null;
			var oneButTopfaceId:Number = null;
			// work on each face
			for (var i = 0; i < facesLength; ++i) {
				var faceId:Number = arrRenderFaces[i];
				// depth management for faces other than front and back
				if (faceId < numFaces - 1) {
					var arrThisFaceMap:Array = Primitive.getFaceMap(faceId, numFaces);
					var arrThisFaceZs:Array = DepthManager.getVerticesZ(arrThisFaceMap, arrZ);
					var zFaceCenter:Number = DepthManager.getfaceCenter(arrThisFaceZs);
					var objZData:Object = {z:zFaceCenter, faceId:faceId};
					arrDepths.push(objZData);
				} else if (faceId == numFaces - 1) {
					oneButTopfaceId = faceId;
				} else {
					topmostFaceId = faceId;
				}
			}
			//
			arrDepths.sortOn('z', 16);
			for (var i = 0; i < arrDepths.length; ++i) {
				arrDepths[i]['level'] = i;
			}
			
		}
		// Number of loops to run for setting depths to be decreased by one, in case of AREA chart and when             
		// either FRONT or BACK face is to be rendered. This is because, in such case, in final step of the 
		// continuing algorithm, we push depth for FRONT or BACK face, giving it the maximum level to be at
		// top of all. Else an undefined entry comes in.
		if (topmostFaceId != null) {
			facesLength--;
		}
		if (oneButTopfaceId != null) {
			facesLength--;
		}
		// for culled or not, both                                                                                                                       
		for (var i = 0; i < facesLength; ++i) {
			if (strChartType == "AREA") {
				var faceId:Number = arrDepths[i]['faceId'];
				var level:Number = arrDepths[i]['level'];
				
				objDepths[faceId] = level;
			} else {
				var strFace:String = arrRenderFaces[i];
				var level:Number = i;
				objDepths[strFace] = level;
			}
		}
		if (strChartType == "AREA") {
			if (oneButTopfaceId != null) {
				objDepths[oneButTopfaceId] = oneButTopfaceId;
			}
			// depth of FRONT or BACK face is pushed in the array with the topmost level, to be above all other faces.        
			if (topmostFaceId != null) {
				objDepths[topmostFaceId] = topmostFaceId;
			}
		}
		
		return objDepths;
	}
	/*
	 * getVerticesZ method is called to get all the Z-values of
	 * the faces to be rendered for depth management.
	 * @param	arrFaceMap	face map
	 * @param	arrZ		all z-values of all faces possible
	 * @return				z-values of the required faces only
	 */
	private static function getVerticesZ(arrFaceMap:Array, arrZ:Array):Array {
		var arrFaceZ:Array = new Array();
		for (var t = 0; t < arrFaceMap.length; ++t) {
			arrFaceZ.push(arrZ[arrFaceMap[t]]);
		}
		return arrFaceZ;
	}
	/**
	 * getfaceCenter method is called to return the characteristic
	 * value for the z-center of the face.
	 * @param	arrFace		vertices of the face
	 * @return				the z-center of face
	 */
	private static function getfaceCenter(arrFace:Array):Number {
		arrFace.sortOn(16);
		var p1:Number = (arrFace[0] + arrFace[2]) / 2;
		var p2:Number = (arrFace[1] + arrFace[3]) / 2;
		return (p1 + p2) / 2;
	}
	
	/**
	 * setZeroPlane method modifies the depth dataset for
	 * to accomodate the zero plane depths.
	 * @param		arrDepths			depth dataset
	 * @param		arrDataValues		data item values
	 * @param		camXAng				x angle of camera
	 * @param		arrChartType		series chart types
	 * @param		clustered			if columns be clustered
	 */
	public static function setZeroPlane(arrDepths:Array, arrDataValues:Array, camXAng:Number, arrChartType:Array, clustered:Boolean):Void {
		// minimise the angle
		camXAng = MathExt.minimiseAngle(camXAng);
		// no zero plane for side views
		if (camXAng == 0 || camXAng == 180 || camXAng == -180) {
			return;
		}
		// number of column series initialised to one     
		var numColumnDS:Number = 1;
		// if columns be clustered
		if (clustered) {
			// reinitialised to zero
			numColumnDS = 0;
			// chart type
			var num:Number = arrChartType.length;
			// iterate over each series
			for (var i = 0; i < num; i++) {
				// if chart type is column, update counter
				if (arrChartType[i] == 'COLUMN') {
					numColumnDS++;
				}
			}
		}
		// flag to manage zero plane depths w.r.t. shifting     
		var shiftNegatives:Boolean = (camXAng < 0 && camXAng > -180) ? true : false;
		// local variables
		var num:Number, num1:Number, num2:Number, shift:Number;
		var arrDataValues_i:Array, arrX:Array, arrDepths_i:Array;
		// note that number of elements in a series is >= number of MCs representing the chart data for the series.
		// number of series
		num = arrDataValues.length;
		// iterate for each series
		for (var i = 0; i < num; i++) {
			// alias of data values of data items
			arrDataValues_i = arrDataValues[i];
			// alias of data item depths
			arrDepths_i = arrDepths[i];
			// number of data items
			num1 = arrDataValues_i.length;
			// chart type specific control
			switch (arrChartType[i]) {
			case 'COLUMN' :
				// depth shift
				shift = numColumnDS * num1 + 1;
				// to allot depth for zeroplane
				arrX = arrDepths_i['children']['zeroPlane'] = [];
				// zero plane depth
				arrX['depth'] = shift - 1;
				// face id of plane that should be visible
				arrX['faceId'] = (shiftNegatives) ? 1 : 0;
				// shifting depths of data items as required
				for (var j = 0; j < num1; ++j) {
					if (shiftNegatives) {
						if (arrDataValues_i[j] < 0) {
							arrDepths_i['children'][j]['depth'] += shift;
						}
					} else {
						if (arrDataValues_i[j] >= 0) {
							arrDepths_i['children'][j]['depth'] += shift;
						}
					}
				}
				break;
			case 'AREA' :
				// to store block depth shifting flags
				var arrBlockSigns:Array = [];
				// flag for valid block found
				var checkBlockInit:Boolean = true;
				var dataValue:Number;
				// iterate over data items
				for (var j = 0; j < num1; j++) {
					// item data value
					dataValue = arrDataValues_i[j];
					// if valid data value
					if (isNaN(dataValue)) {
						// update flag
						checkBlockInit = true;
						continue;
					}
					if (checkBlockInit) {
						// caring case like: null,5,null
						if (isNaN(arrDataValues_i[j + 1])) {
							//continue;
						}
						// boolean to mean block reversal for upright chart                                                                                                                                                                                                                                                                                                               
						if (dataValue != 0) {
							// set shifting flag
							arrBlockSigns.push((dataValue > 0) ? false : true);
							checkBlockInit = false;
						}
					} else {
						if (dataValue * arrDataValues_i[j - 1] < 0) {
							// set shifting flag
							arrBlockSigns.push((dataValue > 0) ? false : true);
						}
					}
				}
				// depth shifting amount
				var shift:Number = num1 + 1;
				// to allot depth for zeroplane
				arrX = arrDepths_i['children']['zeroPlane'] = [];
				// zero plane depth
				arrX['depth'] = shift - 1;
				// face id of the zero plane that be visible
				arrX['faceId'] = (shiftNegatives) ? 1 : 0;
				// number of area blocks
				num2 = arrDepths_i['children'].length;
				// shifting depths of data MCs as required
				for (var j = 0; j < num2; ++j) {
					if (shiftNegatives) {
						if (arrBlockSigns[j] == true) {
							arrDepths_i['children'][j]['depth'] += shift;
						}
					} else {
						if (arrBlockSigns[j] == false) {
							arrDepths_i['children'][j]['depth'] += shift;
						}
					}
				}
				break;
			case 'LINE' :
				// no zero plane for LINE
				break;
			}
		}
	}
	/**
	 * getdepthFor method returns the depth for the specific 
	 * item.
	 * @param		arrZValues		sorted dataset for depth mapping
	 * @param		id				item
	 * @param		idx				face id (optional)
	 * @return						depth of the item
	 */
	private static function getdepthFor(arrZValues:Array, id:Number, idx:Number):Number {
		var arrLength:Number = arrZValues.length;
		// iterate to locate the item entry
		for (var u = 0; u < arrLength; ++u) {
			// if the item is not a face
			if (idx == undefined) {
				if (id == arrZValues[u]['id']) {
					return u;
				}
			} else {
				// else, if item is a face
				if (id == arrZValues[u]['idSeries'] && idx == arrZValues[u]['idBlock']) {
					return u;
				}
			}
		}
	}
	/**
	 * getFirstZValue method returns returns the z component
	 * of the first vertex found.
	 * @param		arrData			data model
	 * @param		strChartType	series chart types
	 * @return						first z value
	 */
	private static function getFirstZValue(arrData:Array, strChartType:String):Number {
		// if this is the pertinent data model level to work on
		if (typeof arrData[0][0] == 'number') {
			// for AREA chart type
			if (strChartType == 'AREA') {
				return (arrData[0][2] + arrData[arrData[0].length - 1][2]) / 2;
			} else {
				// else, for LINE and COLUMN
				return arrData[0][2];
			}
		} else {
			// dig to the pertinent data model level
			var zFirst:Number = arguments.callee(arrData[0], strChartType);
		}
		return zFirst;
	}
}
