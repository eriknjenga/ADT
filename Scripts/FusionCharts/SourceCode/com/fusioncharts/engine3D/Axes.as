/**
* @class Axes
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Axes class provides a number of static methods to
* model the axesBox, manage axesPlus and others.
*/
// import engine3D package
import com.fusioncharts.engine3D.*;
// class definition
class com.fusioncharts.engine3D.Axes {
	/**
	 * Axes class constructor.
	 */
	private function Axes() {
	}
	/**
	 * getAxes method creates the axesBox model.
	 * @param 	arrModelBounds		axes model bounds
	 * @return						axesBox model
	 */
	public static function getAxes(arrModelBounds:Array):Array {
		var arrOrigin:Array = [];
		var arrDimensions:Array = [];
		// loop runs to get model origin coordinate and axes dimensions
		for (var i = 0; i < 3; ++i) {
			// set model origin
			arrOrigin.push(arrModelBounds[i][0]);
			// set axes dimensions
			arrDimensions.push(Math.abs(arrModelBounds[i][0]) + Math.abs(arrModelBounds[i][1]));
		}
		// return the CUBOID model
		return Axes.getCuboidVertices(arrOrigin, arrDimensions);
	}
	/**
	 * getWalls method frames the 3D axesBox with thick walls 
	 * in model space.
	 * @param	arrModel		axes model vertices
	 * @param	arrThickness	wall thicknesses
	 * @return 					wall model
	 */
	public static function getWalls(arrModel:Array, arrThickness:Array):Array {
		// container for wall model
		var arrWalls:Array = [];
		var nPolygon:Number = 4;
		var arrFaceMap:Array = [];
		// face ids in reference to Primitive class
		// 3 type of faces bundled
		var arrWallMap:Array = [[0, 2], [3, 1], [5, 4]];
		var i:Number, thickness:Number, factor:Number;
		var num:Number = arrWallMap.length;
		// iterate for 3 type of (opposite) faces
		for (var k = 0; k < num; k++) {
			// wall thickness for this type of wall
			thickness = arrThickness[k];
			// iterate for both faces for each type
			for (var m = 0; m < 2; m++) {
				// thickness value sign
				factor = (m == 0) ? -1 : 1;
				// one specific face id out of 6 face ids
				i = arrWallMap[k][m];
				// get the face map
				arrFaceMap = Primitive.getFaceMap(i, nPolygon);
				// container for this wall vertices
				var arrFaceWall:Array = [];
				// half the number of vertices for the wall (or vertices for front face of the wall from within the axesBox)
				var num1:Number = arrFaceMap.length;
				// iterate for each vertex
				for (var j = 0; j < num1; j++) {
					// 3D point
					var arrPoint:Array = [];
					// vertices for the front facing vertex
					for (var h = 0; h < 3; h++) {
						arrPoint[h] = arrModel[arrFaceMap[j]][h];
					}
					// insert it in container
					arrFaceWall[j] = arrPoint;
					// now work to get the vertex corresponding to it in the back face
					var arrPoint:Array = [];
					// vertices for the front facing vertex, to be modified for the specific component out of x , y, z
					for (var h = 0; h < 3; h++) {
						arrPoint[h] = arrFaceWall[j][h];
					}
					// modify that specific component
					arrPoint[k] += factor * thickness;
					// insert at respective location
					arrFaceWall[j + 4] = arrPoint;
				}
				// wall vertices inserted
				arrWalls[i] = arrFaceWall;
			}
		}
		// axes walls model returned
		return arrWalls;
	}
	/**
	 * getCuboidVertices method returns the CUBOID model.
	 * @param	arrOrigin 		origin coordinate
	 * @param	arrDimension	axesBox dimensions
	 * @return					CUBOID model
	 */
	private static function getCuboidVertices(arrOrigin:Array, arrDimension:Array):Array {
		var xOrigin:Number, yOrigin:Number, zOrigin:Number, w:Number, h:Number, d:Number;
		// orgin components
		xOrigin = arrOrigin[0];
		yOrigin = arrOrigin[1];
		zOrigin = arrOrigin[2];
		// dimensions
		w = arrDimension[0];
		h = arrDimension[1];
		d = arrDimension[2];
		// container of model to be returned
		var arrCuboid:Array = [];
		// have to map arrFace (back, top, right ...) w.r.t. structure of arrPoints 
		// this is for a right handed coordinate system ... +x --> right, +y --> up, +z --> out of plane towards me
		// vertices of front face
		var arrPoints:Array = [[xOrigin, yOrigin], [xOrigin, yOrigin + h], [xOrigin + w, yOrigin + h], [xOrigin + w, yOrigin]];
		// iterate twice - for front and back
		for (var i = 0; i < 2; ++i) {
			// z shift factor
			var z:Number = (i == 1) ? zOrigin : zOrigin + d;
			// number of vertices in front face
			var num:Number = arrPoints.length;
			// iterate for vertex in the front face
			for (var e = 0; e < num; ++e) {
				// add the vertices
				arrCuboid.push([arrPoints[e][0], arrPoints[e][1], z]);
			}
		}
		// return
		return arrCuboid;
	}
	/**
	 * getColors method returns the axes face colors. 
	 * @param	color				base color
	 * @param	arrPoints			axes model
	 * @param	intensityControl	light intensity
	 * @return						face colors
	 */
	public static function getColors(color:Number, arrPoints:Array, intensityControl:Number):Array {
		// holder of colors
		var arrColors:Array = [];
		// number of sides in the primitive shape
		var numSides:Number = arrPoints.length / 2;
		// number of faces in 3D primitive
		var numFaces:Number = numSides + 2;
		var planeColor:Number, numLoops:Number;
		var arrFaceMap:Array;
		// iterate for faces
		for (var i = 0; i < numFaces; ++i) {
			// holder of face vertices
			var arrPlaneVertices:Array = [];
			// isInverted param is set to false for we need to color axes walls which are mere cuboids, not inverted.
			arrFaceMap = Primitive.getFaceMap(i, numSides, false);
			numLoops = arrFaceMap.length;
			// getting the face vertices
			for (var j:Number = 0; j < numLoops; ++j) {
				arrPlaneVertices[j] = arrPoints[arrFaceMap[j]];
			}
			// gettingthe face color w.r.t. light angle incident on it
			planeColor = Light.evalFaceColor(arrPlaneVertices, color, intensityControl);
			// add the face color
			arrColors.push(planeColor);
		}
		//return
		return arrColors;
	}
	/**
	 * getSeriesColors method returns face specific colors 
	 * based on a number of colors.
	 * @param	arrData				set of colors
	 * @param	arrPoints			model data
	 * @param	intensityControl	light intensity
	 * @return						set of face colors
	 */
	public static function getSeriesColors(arrData:Array, arrPoints:Array, intensityControl:Number):Array {
		// container for color sets for the faces
		var arrSeriesColors:Array = [];
		// for each color
		for (var i = 0; i < arrData.length; ++i) {
			// the color
			var color:Number = arrData[i]['color'];
			// get the face specific color w.r.t. light
			var arrColors:Array = Axes.getColors(color, arrPoints, intensityControl);
			// add the color set
			arrSeriesColors.push(arrColors);
		}
		// return
		return arrSeriesColors;
	}
	/**
	 * getRenderAxesWallsFaces method returns the faces of 
	 * the walls need be visible.
	 * @param	arrPlots	axesBox (wall)  model
	 * @param	arrFaces	renderable axes faces
	 * @return				renderable faces of the walls
	 */
	public static function getRenderAxesWallsFaces(arrPlots:Array, arrFaces:Array):Array {
		// container for renderable faces
		var arrVisibleWallsFaces:Array = [];
		var isVisible:Boolean;
		var faceId:Number;
		var numFaces:Number = 6;
		//
		var arrPoints:Array;
		var num:Number = arrFaces.length;
		// iterate for each face
		for (var k = 0; k < num; ++k) {
			// face id of thin axesBox
			faceId = arrFaces[k];
			// wall model for the face
			arrPoints = arrPlots[faceId];
			// container of faces to be visible for the wall
			arrVisibleWallsFaces[faceId] = [];
			// iterate for each faces of the wall
			for (var i = 0; i < numFaces; ++i) {
				// check its visibility
				isVisible = Axes.isPlaneVisible(i, arrPoints, false);
				// if be visible, add it
				if (isVisible) {
					arrVisibleWallsFaces[faceId].push(i);
				}
			}
		}
		return arrVisibleWallsFaces;
	}
	/**
	 * getRenderPlanes method returns the faces visible for 
	 * thin axesBox.
	 * @param	arrPoints	thin axesBox model
	 * @return				renderable faces
	 */
	public static function getRenderPlanes(arrPoints:Array):Array {
		var arrVisiblePlanes:Array = [];
		var numSides:Number = arrPoints.length / 2;
		var numFaces:Number = numSides + 2;
		//
		var isVisible:Boolean;
		// iterate for each face
		for (var i = 0; i < numFaces; ++i) {
			// check visibility
			isVisible = Axes.isPlaneVisible(i, arrPoints, true);
			// if be visible, add it
			if (isVisible) {
				arrVisiblePlanes.push(i);
			}
		}
		return arrVisiblePlanes;
	}
	/**
	 * isPlaneVisible method return visibility of a face.
	 * @param	faceId			face id
	 * @param	arrVertices		model vertices
	 * @param	isInverted		if viewed from inside of the 
	 *							primitive
	 * @return					face visibility
	 */
	private static function isPlaneVisible(faceId:Number, arrVertices:Array, isInverted:Boolean):Boolean {
		var arrFaceVertices:Array = [];
		var numSides:Number = arrVertices.length / 2;
		var numFaces:Number = numSides + 2;
		// get face map
		var arrFaceMap:Array = Primitive.getFaceMap(faceId, numSides, isInverted);
		// get face vertices
		for (var j:Number = 0; j < arrFaceMap.length; ++j) {
			arrFaceVertices[j] = arrVertices[arrFaceMap[j]];
		}
		// first 3 points to determone visibility
		var pt0:Array = arrFaceVertices[0];
		var pt1:Array = arrFaceVertices[1];
		var pt2:Array = arrFaceVertices[2];
		// 
		var delx1:Number = pt1[0] - pt0[0];
		var delx2:Number = pt2[0] - pt1[0];
		//
		var dely1:Number = pt1[1] - pt0[1];
		var dely2:Number = pt2[1] - pt1[1];
		// check visibility
		var isVisible:Boolean = (dely1 * delx2 < dely2 * delx1) ? true : false;
		return isVisible;
	}
	/**
	 * getAxesPlus method returns the axesPlus model.
	 * @param	objAxesPlus			axesPlus params
	 * @param	arrModelBounds		axesBox model bounds
	 * @return						axesPlus model
	 */
	public static function getAxesPlus(objAxesPlus:Object, arrModelBounds:Array):Array {
		// components of model extremities
		var xMin:Number = arrModelBounds[0][0];
		var xMax:Number = arrModelBounds[0][1];
		var yMin:Number = arrModelBounds[1][0];
		var yMax:Number = arrModelBounds[1][1];
		var zMin:Number = arrModelBounds[2][0];
		var zMax:Number = arrModelBounds[2][1];
		// container to be returned
		var arrData:Array = [];
		// iterate for each lineType
		for (var axesPlusType in objAxesPlus) {
			// sub-container
			var arrTypeData:Array = arrData[axesPlusType] = [];
			// iterate for each line of the type
			for (var i = 0; i < objAxesPlus[axesPlusType].length; ++i) {
				// model params for the line
				var objData:Object = objAxesPlus[axesPlusType][i];
				// sub-container for 6 faces
				arrTypeData[i] = new Array(6);
				// alias
				var arrSubData:Array = arrTypeData[i];
				// linetype specific control
				switch (axesPlusType) {
				case "HLines" :
					var y:Number = objData.y;
					// left
					arrSubData[0] = [[xMin, y, zMax], [xMin, y, zMin]];
					// right
					arrSubData[2] = [[xMax, y, zMax], [xMax, y, zMin]];
					//
					// front
					arrSubData[4] = [[xMin, y, zMax], [xMax, y, zMax]];
					// back
					arrSubData[5] = [[xMin, y, zMin], [xMax, y, zMin]];
					//
					// top
					arrSubData[1] = [];
					// bottom
					arrSubData[3] = [];
					break;
				case "VLines" :
					var x:Number = objData.x;
					// top
					arrSubData[1] = [[x, yMax, zMax], [x, yMax, zMin]];
					// bottom
					arrSubData[3] = [[x, yMin, zMax], [x, yMin, zMin]];
					//
					// front
					arrSubData[4] = [[x, yMin, zMax], [x, yMax, zMax]];
					// back
					arrSubData[5] = [[x, yMin, zMin], [x, yMax, zMin]];
					//
					// left
					arrSubData[0] = [];
					// right
					arrSubData[2] = [];
					break;
				case "TLines" :
					var y1:Number = objData.y1;
					var y2:Number = objData.y2;
					// left
					arrSubData[0] = [[xMin, y1, zMax], [xMin, y1, zMin]];
					// right
					arrSubData[2] = [[xMax, y2, zMax], [xMax, y2, zMin]];
					//
					// front
					arrSubData[4] = [[xMin, y1, zMax], [xMax, y2, zMax]];
					// back
					arrSubData[5] = [[xMin, y1, zMin], [xMax, y2, zMin]];
					//
					// top
					arrSubData[1] = [];
					// bottom
					arrSubData[3] = [];
					break;
				}
			}
		}
		return arrData;
	}
	/**
	 * getAxesNamePlots method returns the positions for 
	 * axesName labels.
	 * @param	arrAxesNamePlots	position params of labels
	 * @param	arrModelBounds		model bounds for the axesBox
	 * @return						3D positions of axesName labels
	 */
	public static function getAxesNamePlots(arrAxesNamePlots:Array, arrModelBounds:Object):Array {
		var arrPlots:Array = [];
		// components of model extremities
		var xMin:Number = arrModelBounds[0][0];
		var xMax:Number = arrModelBounds[0][1];
		var yMin:Number = arrModelBounds[1][0];
		var yMax:Number = arrModelBounds[1][1];
		var zMin:Number = arrModelBounds[2][0];
		var zMax:Number = arrModelBounds[2][1];
		//---- for x label rotation calculation-----//
		arrPlots.push([[xMax, yMin, zMax]]);
		//------- left and bottom placement-----//
		// x label
		arrPlots.push([[xMax / 2, yMin, zMax], [xMax / 2, yMin, zMin]]);
		// y label
		arrPlots.push([[xMin, (yMin + yMax) / 2, zMax], [xMin, (yMin + yMax) / 2, zMin]]);
		//------- top and right placement-----//
		// x label
		arrPlots.push([[xMax / 2, yMax, zMax], [xMax / 2, yMax, zMin]]);
		// y label
		arrPlots.push([[xMax, (yMin + yMax) / 2, zMax], [xMax, (yMin + yMax) / 2, zMin]]);
		//
		return arrPlots;
	}
	/**
	 * getLabels method returns the axes label positions.
	 * @param	objLabels			label positioning params
	 * @param	arrModelBounds		axesBox bounds
	 * @param	objGaps				gaps from axes edges
	 * @return						label positions
	 */
	public static function getLabels(objLabels:Object, arrModelBounds:Object, objGaps:Object):Array {
		// components of model extremities
		var xMin:Number = arrModelBounds[0][0];
		var xMax:Number = arrModelBounds[0][1];
		var yMin:Number = arrModelBounds[1][0];
		var yMax:Number = arrModelBounds[1][1];
		var zMin:Number = arrModelBounds[2][0];
		var zMax:Number = arrModelBounds[2][1];
		// edge gaps
		var xGap:Number = objGaps.xGap;
		var yGap:Number = objGaps.yGap;
		var xGapNoWall:Number = objGaps.xGapNoWall;
		var yGapNoWall:Number = objGaps.yGapNoWall;
		// container for label positions to be returned
		var arrData:Array = [];
		// iterate for each label type
		for (var labelType in objLabels) {
			// sub-container
			var arrTypeData:Array = arrData[labelType] = [];
			// iterate for each label
			for (var i = 0; i < objLabels[labelType].length; ++i) {
				// label position params
				var objData:Object = objLabels[labelType][i];
				// sub-container for 6 faces
				arrTypeData[i] = new Array(6);
				// alias
				var arrSubData:Array = arrTypeData[i];
				// label type specific control
				switch (labelType) {
				case "yLabels" :
					var y:Number = objData.y;
					// first 2 for labelling mode in which BACK face is available and the next 2 for and when BACK face is unavailable
					// left
					arrSubData[0] = [[xMin, y, zMax], [xMin - xGap, y, zMax], [xMin, y, zMin], [xMin - xGap, y, zMin]];
					// right
					arrSubData[2] = [[xMax, y, zMax], [xMax + xGap, y, zMax], [xMax, y, zMin], [xMax + xGap, y, zMin]];
					// front
					arrSubData[4] = [];
					// back
					arrSubData[5] = [];
					// top
					arrSubData[1] = [];
					// bottom
					arrSubData[3] = [];
					break;
					//
				case "xLabels" :
					var x:Number = objData.x;
					// first 2 for labelling mode in which BACK face is available and the next 2 for and when BACK face is unavailable
					// top
					arrSubData[1] = [[x, yMax, zMax], [x, yMax + yGap, zMax], [x, yMax, zMin], [x, yMax + yGap, zMin]];
					// bottom
					arrSubData[3] = [[x, yMin, zMax], [x, yMin - yGap, zMax], [x, yMin, zMin], [x, yMin - yGap, zMin]];
					// front
					arrSubData[4] = [];
					// back
					arrSubData[5] = [];
					// left
					arrSubData[0] = [];
					// right
					arrSubData[2] = [];
					break;
					//
				case "tLabels" :
					var y1:Number = objData.y1;
					var y2:Number = objData.y2;
					// first 2 for labelling mode in which BACK face is available and the next 2 for and when BACK face is unavailable
					if (objData.valueOnRight) {
						// left
						arrSubData[0] = [[xMax, y2, zMin], [xMax + xGapNoWall, y2, zMin], [xMax, y2, zMax], [xMax + xGapNoWall, y2, zMax]];
						// right
						arrSubData[2] = [[xMin, y1, zMin], [xMin - xGapNoWall, y1, zMin], [xMin, y1, zMax], [xMin - xGapNoWall, y1, zMax]];
					} else {
						// left
						arrSubData[0] = [[xMin, y1, zMax], [xMin - xGap, y1, zMax], [xMin, y1, zMin], [xMin - xGap, y1, zMin]];
						// right
						arrSubData[2] = [[xMax, y2, zMax], [xMax + xGap, y2, zMax], [xMax, y2, zMin], [xMax + xGap, y2, zMin]];
					}
					// front
					arrSubData[4] = [];
					// back
					arrSubData[5] = [];
					//
					// top
					arrSubData[1] = [];
					// bottom
					arrSubData[3] = [];
					break;
				}
			}
		}
		return arrData;
	}
	/**
	 * setAxesLabelsData method returns a rearrangement of
	 * of axes labels w.r.t. face combinations.
	 * @param	arrData		axes labels model
	 * @return				remapped model
	 */
	public static function setAxesLabelsData(arrData:Array):Array {
		// container to be returned
		var arrDataSet:Array = [];
		// left:0, top:1, right:2, bottom:3, front:4, back:5
		var arrFacePairs:Array = [[5, 4], [0, 2], [1, 3]];
		// container to hold all combinations
		var arrCombinations:Array = [];
		var a:Number, b:Number, c:Number;
		// getting all possible combinations of 3 faces
		// iterate for front and back
		for (var i = 0; i < 2; ++i) {
			a = arrFacePairs[0][i];
			// iterate for left and right
			for (var j = 0; j < 2; ++j) {
				b = arrFacePairs[1][j];
				// iterate for top and bottom
				for (var k = 0; k < 2; ++k) {
					c = arrFacePairs[2][k];
					// add the combination
					arrCombinations.push([a, b, c]);
				}
			}
		}
		// function to return the combination id
		var evalIndex:Function = function (arrFaceComb:Array):Number {
			// back/front
			var p1:Number = (arrFaceComb[0] == 5) ? 0 : 1;
			// left/right
			var p2:Number = (arrFaceComb[1] == 0) ? 0 : 1;
			// top/bottom
			var p3:Number = (arrFaceComb[2] == 1) ? 0 : 1;
			//
			return p1 << 2 | p2 << 1 | p3;
		};
		//
		var arrSubData:Array, arrSubDataSet:Array, arrSubDataSetType:Array;
		var num:Number, num1:Number, index:Number;
		num = arrCombinations.length;
		// iterate for each combination
		for (var i = 0; i < num; ++i) {
			// the combination
			var arrFaceCombination:Array = arrCombinations[i];
			// array placement ids
			var arrSpaceIds:Array = (arrFaceCombination[0] == 5) ? [0, 1] : [2, 3];
			var yAxislabelId:Number = (arrFaceCombination[1] == 0) ? 0 : 2;
			var xAxislabelId:Number = (arrFaceCombination[2] == 1) ? 1 : 3;
			// get combination id
			index = evalIndex(arrFaceCombination);
			// sub-container for the face combination
			arrSubDataSet = arrDataSet[index] = [];
			// iterate for each label type
			for (var labelType in arrData) {
				// array index id
				var dataId:Number = (labelType == 'xLabels') ? xAxislabelId : yAxislabelId;
				// model data for the labelType
				arrSubData = arrData[labelType];
				// number of labels
				num1 = arrSubData.length;
				// sub-container for the label type
				arrSubDataSetType = arrSubDataSet[labelType] = [];
				// iterate for each label
				for (var j = 0; j < num1; ++j) {
					arrSubDataSetType[j] = [arrSubData[j][dataId][arrSpaceIds[0]], arrSubData[j][dataId][arrSpaceIds[1]]];
				}
			}
		}
		// return
		return arrDataSet;
	}
	/**
	 * setAxesPlusData method returns a rearrangement of
	 * of axesPlus model w.r.t. face combinations.
	 * @param	arrData		axesPlus model
	 * @return				remapped model
	 */
	public static function setAxesPlusData(arrData:Array):Array {
		// container to be returned
		var arrDataSet:Array = [];
		// left:0, top:1, right:2, bottom:3, front:4, back:5
		var arrFacePairs:Array = [[5, 4], [0, 2], [1, 3]];
		// container to hold all combinations
		var arrCombinations:Array = [];
		var a:Number, b:Number, c:Number;
		// getting all possible combinations of 3 faces
		// iterate for front and back
		for (var i = 0; i < 2; ++i) {
			a = arrFacePairs[0][i];
			// iterate for left and right
			for (var j = 0; j < 2; ++j) {
				b = arrFacePairs[1][j];
				// iterate for top and bottom
				for (var k = 0; k < 2; ++k) {
					c = arrFacePairs[2][k];
					// add the combination
					arrCombinations.push([a, b, c]);
				}
			}
		}
		// function to return the combination id
		var evalIndex:Function = function (arrFaceComb:Array):Number {
			// back/front
			var p1:Number = (arrFaceComb[0] == 5) ? 0 : 1;
			// left/right
			var p2:Number = (arrFaceComb[1] == 0) ? 0 : 1;
			// top/bottom
			var p3:Number = (arrFaceComb[2] == 1) ? 0 : 1;
			//
			return p1 << 2 | p2 << 1 | p3;
		};
		//---------------------------------------//
		var arrSubData:Array, arrSubDataSet:Array, arrSubDataSetType:Array;
		var num:Number, num1:Number, index:Number;
		//
		num = arrCombinations.length;
		// iterate for each combination
		for (var i = 0; i < num; ++i) {
			// the combination
			var arrFaceCombination:Array = arrCombinations[i];
			// get its id
			index = evalIndex(arrFaceCombination);
			// sub-container for the combination
			arrSubDataSet = arrDataSet[index] = [];
			// line types
			for (var lineType in arrData) {
				// the 2 faces for which to set the data for the line type
				var arr2Faces:Array = (lineType == 'VLines') ? [arrFaceCombination[0], arrFaceCombination[2]] : [arrFaceCombination[0], arrFaceCombination[1]];
				// sort for later requirement
				arr2Faces.sort(16);
				// line type model
				arrSubData = arrData[lineType];
				// number of lines
				num1 = arrSubData.length;
				// sub-container for the line type
				arrSubDataSetType = arrSubDataSet[lineType] = [];
				// iterate for each line
				for (var j = 0; j < num1; ++j) {
					// sub-container for the 2 faces
					arrSubDataSetType[j] = [];
					// set data for the 2 faces
					for (var k = 0; k < 2; ++k) {
						// id of the face
						var faceId:Number = arr2Faces[k];
						// add data
						arrSubDataSetType[j][faceId] = arrSubData[j][faceId];
					}
				}
			}
		}
		// return
		return arrDataSet;
	}
	/**
	 * setAxesWallsData method returns a rearrangement of
	 * of axesWalls model w.r.t. face combinations.
	 * @param	arrData		axes walls model
	 * @return				remapped model
	 */
	public static function setAxesWallsData(arrData:Array):Array {
		// container to be returned
		var arrDataSet:Array = [];
		// left:0, top:1, right:2, bottom:3, front:4, back:5
		var arrFacePairs:Array = [[5, 4], [0, 2], [1, 3]];
		// container to hold all combinations
		var arrCombinations:Array = [];
		var a:Number, b:Number, c:Number;
		// getting all possible combinations of 3 faces
		// iterate for front and back
		for (var i = 0; i < 2; ++i) {
			a = arrFacePairs[0][i];
			// iterate for left and right
			for (var j = 0; j < 2; ++j) {
				b = arrFacePairs[1][j];
				// iterate for top and bottom
				for (var k = 0; k < 2; ++k) {
					c = arrFacePairs[2][k];
					// add the combination
					arrCombinations.push([a, b, c]);
				}
			}
		}
		// function to return the combination id
		var evalIndex:Function = function (arrFaceComb:Array):Number {
			// back/front
			var p1:Number = (arrFaceComb[0] == 5) ? 0 : 1;
			// left/right
			var p2:Number = (arrFaceComb[1] == 0) ? 0 : 1;
			// top/bottom
			var p3:Number = (arrFaceComb[2] == 1) ? 0 : 1;
			//
			return p1 << 2 | p2 << 1 | p3;
		};
		//---------------------------------------//
		var arrSubData:Array, arrSubDataSet:Array, arrSubDataSetType:Array;
		var num:Number, num1:Number, index:Number;
		var arrFaceCombination:Array;
		// total number of combinations
		num = arrCombinations.length;
		// iterate for each combination
		for (var i = 0; i < num; ++i) {
			// the combination
			arrFaceCombination = arrCombinations[i];
			// comination id
			index = evalIndex(arrFaceCombination);
			// sort for later requirement
			arrFaceCombination.sort(16);
			// sub-container for the combination
			arrSubDataSet = arrDataSet[index] = [];
			// number of faces in the combination
			num1 = arrFaceCombination.length;
			// iterate for each face
			for (var k = 0; k < num1; ++k) {
				// id of the face
				var faceId:Number = arrFaceCombination[k];
				// add the face model
				arrSubDataSet[faceId] = arrData[faceId];
			}
		}
		// return
		return arrDataSet;
	}
}
