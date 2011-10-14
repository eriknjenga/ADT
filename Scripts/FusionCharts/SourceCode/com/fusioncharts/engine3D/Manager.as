/**
* @class Manager
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Manager class provides a number of helper methods.
*/
// import the engine3D package
import com.fusioncharts.engine3D.*;
// class definition
class com.fusioncharts.engine3D.Manager {
	/**
	 * Manager class constructor.
	 */
	private function Manager() {
	}
	/**
	 * getRenderFaces method returns the renderable 
	 * faces in the data model.
	 * @param		arrView3D		data model in view space
	 * @param		arrChartType	series chart types
	 * @param		culling			face culling boolean
	 * @return						renderable faces
	 */
	public static function getRenderFaces(arrView3D:Array, arrChartType:Array, culling:Boolean):Array {
		// For a series of columns, faces visible for one is to be applied in others too (irrespective of series).
		// flag to indicate that rendreable faces for a column is obtained
		var gotColumn:Boolean = false;
		// container for renderable faces of a column
		var arrColumnFaces:Array = [];
		// chart type
		var strChartType:String;
		// container for renderable faces
		var arrRenderables:Array = (arguments[3] == undefined) ? [] : arguments[3];
		// iterate over the data model
		for (var u = 0; u < arrView3D.length; ++u) {
			// series chart type
			strChartType = (arguments[4] == undefined) ? arrChartType[u] : arguments[4];
			// if not the pertinent level of data model
			if (typeof arrView3D[u] == 'object' && typeof arrView3D[u][0][0] == 'object') {
				//
				arrRenderables[u] = [];
				// dig to the required level
				arrRenderables[u] = arguments.callee(arrView3D[u], null, culling, arrRenderables[u], strChartType);
			} else {
				// data item level
				// number fo sides of 2D shape primitive
				var numSides:Number = (arrView3D[u].length - ((strChartType == "LINE") ? 1 : 0)) / 2;
				// number of faces of 3D primitive
				var numFaces:Number = numSides + ((strChartType == "LINE") ? 0 : 2);
				// for no face culling
				if (culling == false) {
					var arrAllFaces:Array = [];
					for (var i = 0; i < numSides; ++i) {
						arrAllFaces.push(i);
					}
					arrRenderables.push(arrAllFaces);
				} else {
					// for face culling:
					// 
					var isVisible:Boolean;
					var arrVisibleFaces:Array = [];
					// if not a column or its column and colors not yet found for it 
					if ((!gotColumn && strChartType == "COLUMN") || strChartType != "COLUMN") {
						// iterate over faces
						for (var i = 0; i < numFaces; ++i) {
							// if face is visible
							isVisible = Manager.isFaceVisible(i, arrView3D[u], strChartType, numSides);
							// if visible, add it
							if (isVisible) {
								arrVisibleFaces.push(i);
							}
						}
						// for LINE type, if no renderable faces found, means viewing from side
						if (strChartType == "LINE" && arrVisibleFaces.length == 0) {
							// so add the side id
							arrVisibleFaces.push(2);
						}
						// add the faces for the data item   
						arrRenderables.push(arrVisibleFaces);
						// for COLUMN (check to see if number of faces found is greater than one is for 
						// the case of zero height columns at series start)
						if (strChartType == "COLUMN" && arrVisibleFaces.length>1) {
							// update flag
							gotColumn = true;
							// store the faces for further use
							arrColumnFaces = arrVisibleFaces;
						}
					} else {
						// gotColumn is true and its COLUMN
						arrRenderables.push(arrColumnFaces);
					}
				}
			}
		}
		return arrRenderables;
	}
	/**
	 * isFaceVisible method returns the visibility of a face.
	 * @param		faceId			face id
	 * @param		arrVertices		data item vertices
	 * @param		strChartType	chart type
	 * @param		numSides		number of sides for the 2D shape 
	 *								primitive
	 * @return						face visibility
	 */
	private static function isFaceVisible(faceId:Number, arrVertices:Array, strChartType:String, numSides:Number):Boolean {
		// container for face vertices
		var arrFaceVertices:Array = [];
		// number of faces
		var numFaces:Number = (strChartType == "LINE") ? 2 : numSides + 2;
		// face map
		var arrFaceMap:Array = Primitive.getFaceMap(faceId, numSides);
		// get the face vetices together
		for (var j:Number = 0; j < arrFaceMap.length; ++j) {
			arrFaceVertices[j] = arrVertices[arrFaceMap[j]];
		}
		// first vertex
		var pt0:Array = arrFaceVertices[0];
		//  number of vertices for the face to work on
		var num:Number = arrFaceVertices.length - 1;
		// iterate over other vretices than the first one
		for (var j:Number = 1; j < num; ++j) {
			// next 2 vertices
			var pt1:Array = arrFaceVertices[j];
			var pt2:Array = arrFaceVertices[j + 1];
			// 
			var delx1:Number = pt1[0] - pt0[0];
			var delx2:Number = pt2[0] - pt1[0];
			//
			var dely1:Number = pt1[1] - pt0[1];
			var dely2:Number = pt2[1] - pt1[1];
			//
			// zero vector issue ... set and commented
			if ((delx2 == 0 && dely2 == 0) || (delx1 == 0 && dely1 == 0)) {
				continue;
			}
			// angles   
			var ang1:Number = Math.atan2(dely1, delx1) * (180 / Math.PI);
			var ang2:Number = Math.atan2(dely2, delx2) * (180 / Math.PI);
			// absolute rounded difference in the angles
			var diffAng:Number = Math.abs(Math.round(ang1-ang2))
			// if the 2 arms are in a straight line
			if(diffAng == 0 || diffAng == 180){
				// discard this vertex and check the next one
				continue
			}
			// 
			ang2 -= ang1;
			ang2 = Math.round(ang2);
			// face visibility obtained
			return ((ang2 > 0 && ang2 < 180) || (ang2 < -180)) ? true : false;
		}
		// if face visibility can't be evaluated
		return false;
	}
	/**
	 * getDataModelYMinMax method returns the extremities of 
	 * "y" in the passed data model.
	 * @param		arrData		data model
	 * @return 					"y" extremities
	 */
	public static function getDataModelYMinMax(arrData:Array):Object {
		// container to be returned
		var objMaxMin:Object = {};
		// extreme values possible
		var minDataY:Number = Number.MAX_VALUE;
		var maxDataY:Number = -Number.MAX_VALUE;
		var yValue:Number;
		//
		var num:Number, num1:Number, num2:Number;
		var arrData_i:Array, arrData_i_j:Array;
		// number of series
		num = arrData.length;
		// iterate for each series
		for (var i = 0; i < num; i++) {
			// alias of the series
			arrData_i = arrData[i];
			// number of data items in the series
			num1 = arrData_i.length;
			// iterate for each data item
			for (var j = 0; j < num1; j++) {
				// alias for the data item
				arrData_i_j = arrData_i[j];
				// number of vertices
				num2 = arrData_i_j.length;
				// iterate for each vertex
				for (var k = 0; k < num2; k++) {
					// the 'y' value
					yValue = arrData_i_j[k][1];
					// checking the "y" value against the so far obtained extremes
					minDataY = (yValue < minDataY) ? yValue : minDataY;
					maxDataY = (yValue > maxDataY) ? yValue : maxDataY;
				}
			}
		}
		// setting the final extreme values
		objMaxMin.minY = minDataY;
		objMaxMin.maxY = maxDataY;
		// return
		return objMaxMin;
	}
	/**
	 * getPlaneDefiningPoints method return the vertices 
	 * defining the plane required face depending on the 
	 * params passed.
	 * @param		arrPointset		view model of dta items
	 * @param		arrMap			face map
	 * @param		mcBlockId		block id
	 * @param		seriesId		series id
	 * @return				 		the face defining vertices
	 */
	public static function getPlaneDefiningPoints(arrPointset:Array, arrMap:Array, mcBlockId:Number, seriesId:Number):Array {
		// container to return
		var arrNPoints:Array;
		// if required level in model structure obtained
		if (typeof arrPointset[0][0][0] == 'number') {
			// data item block
			var arrThePointset:Array = arrPointset[mcBlockId];
			// face map
			var arrFaceMap:Array = arrMap;
			// container for face defining vertices
			var arrAllPoints:Array = new Array();
			for (var i = 0; i < arrFaceMap.length; ++i) {
				// vertex id
				var id:Number = arrFaceMap[i];
				// vertex components
				var x:Number = arrThePointset[id][0];
				var y:Number = arrThePointset[id][1];
				var z:Number = arrThePointset[id][2];
				//
				// Note: here arrThePointset[id] can be used instead of [x, y, z]; but issue lies with reference 
				// data-type of 'array' i.e. arrThePointset[id], in which case the original repository gets modified
				// due transformations.
				// construct the vertex and add
				arrAllPoints.push([x, y, z]);
			}
			// assign the vertices
			arrNPoints = arrAllPoints;
		} else {
			// if at series level, call recursively to dig to the next lower level
			arrNPoints = arguments.callee(arrPointset[seriesId], arrMap, mcBlockId, seriesId);
		}
		return arrNPoints;
	}
	/**
	 * getPlanePointZ method  returns the "z" value 
	 * corresponding to the view "x" and "y" for the 
	 * plane provided.
	 * @param		p4				view x and y
	 * @param		arrPlane3D		plane vertices
	 * @return						the corresponding z 
	 */
	public static function getPlanePointZ(p4:Array, arrPlane3D:Array):Number {
		var p1:Array, p2:Array, p3:Array;
		// consecutive 3 vertices of the plane
		p1 = arrPlane3D[0];
		p2 = arrPlane3D[1];
		p3 = arrPlane3D[2];
		// get parameters required by the formula to be applied to get the z
		var a:Number = p4[0] - p1[0];
		var b:Number = p4[1] - p1[1];
		// 
		var arr1:Array = [p2[1] - p1[1], p2[2] - p1[2]];
		var arr2:Array = [p3[1] - p1[1], p3[2] - p1[2]];
		//
		var arr3:Array = [p2[2] - p1[2], p2[0] - p1[0]];
		var arr4:Array = [p3[2] - p1[2], p3[0] - p1[0]];
		//
		var arr5:Array = [p2[0] - p1[0], p2[1] - p1[1]];
		var arr6:Array = [p3[0] - p1[0], p3[1] - p1[1]];
		// get  determinants
		var detA:Number = Vector.det2x2(arr1, arr2);
		var detB:Number = Vector.det2x2(arr3, arr4);
		var detC:Number = Vector.det2x2(arr5, arr6);
		// formula
		var z:Number = -((a * detA + b * detB) / detC) + p1[2];
		//return
		return z;
	}
	/**
	 * getModelBounds method returns the bounds of the model
	 * for axesBox in model space.
	 * @param		arrModel		axesbox model
	 * @param		objAxesPlus		axesPlus model
	 * @param		chartWidth		chart width
	 * @return						model bounds
	 */
	public static function getModelBounds(arrModel:Array, objAxesPlus:Object, chartWidth:Number):Array {
		// get model extremes
		var arrMax:Array = Manager.getModelMaxBounds(arrModel);
		var arrMin:Array = Manager.getModelMinBounds(arrModel);
		// to keep the equal free spacing on left and right sides of the charts within the axesBox.
		arrMax[0] += arrMin[0];
		arrMax[0] = chartWidth;
		// to keep the equal free spacing on front and back sides of the charts within the axesBox.
		arrMax[2] += arrMin[2];
		// get axesPlus extremes
		var arrAxesMax:Array = Manager.getAxesMaxBounds(objAxesPlus);
		var arrAxesMin:Array = Manager.getAxesMinBounds(objAxesPlus);
		// to maintain xOrigin and zOrigin of axesBox at zero perfectly, of model coordinate system
		arrAxesMin[0] = 0;
		arrAxesMin[2] = 0;
		// container to be returned
		var arrModelBounds:Array = new Array(3);
		// iterate for 3 dimensions
		for (var i = 0; i < 3; ++i) {
			arrModelBounds[i] = [Math.min(arrMin[i], arrAxesMin[i]), Math.max(arrMax[i], arrAxesMax[i])];
		}
		return arrModelBounds;
	}
	/**
	 * getAxesMaxBounds method returns the maximum extremes 
	 * for axesPlus model.
	 * @param		objAxesPlus		axesPlus model
	 * @return						max extremes
	 */
	private static function getAxesMaxBounds(objAxesPlus:Object):Array {
		// minimum values possible for all 3 components
		var arrMax:Array = [-Number.MAX_VALUE, -Number.MAX_VALUE, -Number.MAX_VALUE];
		var x:Number, y:Number;
		// iterate over Vlines
		for (var u = 0; u < objAxesPlus["VLines"].length; ++u) {
			x = objAxesPlus["VLines"][u]['x'];
			arrMax[0] = (arrMax[0] >= x) ? arrMax[0] : x;
		}
		// iterate over HLines
		for (var u = 0; u < objAxesPlus["HLines"].length; ++u) {
			y = objAxesPlus["HLines"][u]['y'];
			arrMax[1] = (arrMax[1] >= y) ? arrMax[1] : y;
		}
		//
		return arrMax;
	}
	/**
	 * getAxesMinBounds method returns the minimum extremes 
	 * for axesPlus model.
	 * @param		objAxesPlus		axesPlus model
	 * @return						min extremes
	 */
	private static function getAxesMinBounds(objAxesPlus:Object):Array {
		// maximum values possible for all 3 components
		var arrMin:Array = [Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE];
		//
		var x:Number, y:Number;
		// iterate over Vlines
		for (var u = 0; u < objAxesPlus["VLines"].length; ++u) {
			x = objAxesPlus["VLines"][u]['x'];
			arrMin[0] = (arrMin[0] <= x) ? arrMin[0] : x;
		}
		// iterate over HLines
		for (var u = 0; u < objAxesPlus["HLines"].length; ++u) {
			y = objAxesPlus["HLines"][u]['y'];
			arrMin[1] = (arrMin[1] <= y) ? arrMin[1] : y;
		}
		//
		return arrMin;
	}
	/**
	 * getModelMaxBounds method returns the maximum extremes
	 * for the model provided.
	 * @param		arrModel 	model to work on
	 * @return					max extremes
	 */
	private static function getModelMaxBounds(arrModel:Array):Array {
		var arrMax:Array;
		if (arguments[1] == undefined) {
			// minimum values possible for all 3 components
			arrMax = [-Number.MAX_VALUE, -Number.MAX_VALUE, -Number.MAX_VALUE];
		} else {
			arrMax = arguments[1];
		}
		// iterate over the model levels
		for (var u = 0; u < arrModel.length; ++u) {
			// if not the required level
			if (typeof arrModel[u] == 'object') {
				// call recursively to dig to the required level
				arrMax = arguments.callee(arrModel[u], arrMax);
			} else {
				arrMax[u] = (arrMax[u] >= arrModel[u]) ? arrMax[u] : arrModel[u];
			}
		}
		//
		return arrMax;
	}
	/**
	 * getModelMinBounds method returns the minimum extremes
	 * for the model provided.
	 * @param		arrModel 	model to work on
	 * @return					min extremes
	 */
	private static function getModelMinBounds(arrModel:Array):Array {
		var arrMin:Array;
		if (arguments[1] == undefined) {
			// maximum values possible for all 3 components
			arrMin = [Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE];
		} else {
			arrMin = arguments[1];
		}
		// iterate over the model levels
		for (var u = 0; u < arrModel.length; ++u) {
			// if not the required level
			if (typeof arrModel[u] == 'object') {
				// call recursively to dig to the required level
				arrMin = arguments.callee(arrModel[u], arrMin);
			} else {
				arrMin[u] = (arrMin[u] <= arrModel[u]) ? arrMin[u] : arrModel[u];
			}
		}
		//
		return arrMin;
	}
	/**
	 * getModelCenter method returns the mean point coordinate
	 * of the model.
	 * @param		arrModelBounds		model bounds
	 * @return							mean point of model
	 */
	public static function getModelCenter(arrModelBounds:Array):Array {
		var arrMean:Array = new Array();
		// iterate for 3 components of the mean point
		for (var d = 0; d < 3; ++d) {
			arrMean[d] = (arrModelBounds[d][0] + arrModelBounds[d][1]) / 2;
		}
		return arrMean;
	}
	/**
	 * getZOrigins method returns the the z origins for all
	 * series of the model provided.
	 * @param		arrData		data model to work on
	 * @return					z origins
	 */
	public static function getZOrigins(arrData:Array):Array {
		var arrZ:Array = new Array();
		// iterate for each series
		for (var i = 0; i < arrData.length; ++i) {
			// get the first z value of the series data model
			arrZ.push([0, 0, Manager.getFirstZValue(arrData[i])]);
		}
		return arrZ;
	}
	/**
	 * getFirstZValue method returns the very first z value 
	 * for the first vertex found.
	 * @param		arrData  	data model to work on
	 * @return					z value of first vertex found
	 */
	private static function getFirstZValue(arrData:Array):Number {
		if (typeof arrData[0][0] == 'number') {
			return arrData[0][2];
		} else {
			// dig to the required level
			var zFirst:Number = arguments.callee(arrData[0]);
		}
		return zFirst;
	}
}
