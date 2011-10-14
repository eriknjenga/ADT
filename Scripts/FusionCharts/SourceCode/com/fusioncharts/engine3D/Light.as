/**
 * @class Light
 * @author InfoSoft Global (P) Ltd.
 * @version 3.0
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2008
 *
 * Light class groups a number methods to work with 
 * light.
 */
// import the engine3D package
import com.fusioncharts.engine3D.*;
// import MathExt class
import com.fusioncharts.extensions.ColorExt;
// class definition
class com.fusioncharts.engine3D.Light {
	/**
	 * Light class constructor.
	 */
	private function Light() {
	}
	/**
	 * getLightIntensity method returns the light intensity.
	 * @param		intensity		intensity to be validated
	 * @return						validated intensity
	 */
	public static function getLightIntensity(intensity:Number):Number {
		// range for user: 0 - 10
		// range for engine: 0.4 to 0.05 (respectively)
		// remapping of intensity
		intensity = 0.05 + 0.035 * (10 - intensity);
		var intensityControl:Number;
		// validation
		if (intensity <= 0.4 && intensity >= 0.05) {
			intensityControl = intensity;
		} else {
			// default value
			intensityControl = DefaultValues.LIGHT_INTENSITY;
		}
		return intensityControl;
	}
	/**
	 * getNormals method returns the normal unit vector for 
	 * all faces.
	 * @param		arrData			data item model in model space
	 * @param		arrCategory		series chart types
	 * @return						normal unit vectors of all faces in model
	 */
	public static function getNormals(arrData:Array, arrCategory:Array):Array {
		var arrNormals:Array = [];
		// hardcoded to optimize
		// left, top, right, bottom, front, back
		var arrColumnNormals:Array = [[-1, 0, 0], [0, 1, 0], [1, 0, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]];
		// local variables declared
		var num1:Number, num2:Number, num3:Number, num4:Number;
		var arrData_i:Array, arrData_i_j:Array, arrData_i_j_k:Array;
		var arrNormals_i:Array, arrNormals_i_j:Array;
		var seriesCategory:String;
		// number of series
		num1 = arrData.length;
		//iterate for each series
		for (var i = 0; i < num1; ++i) {
			// sub-container for each series
			arrNormals_i = arrNormals[i] = [];
			// chart type
			seriesCategory = arrCategory[i];
			// alias of series data
			arrData_i = arrData[i];
			// number od data items
			num2 = arrData_i.length;
			// iterate for each data item
			for (var j = 0; j < num2; ++j) {
				// control by chart type
				switch (seriesCategory) {
				case "COLUMN" :
					// normals for all 6 faces
					arrNormals_i[j] = arrColumnNormals;
					break;
				case "AREA" :
				case "LINE" :
					// sub-container for face normals
					arrNormals_i_j = arrNormals_i[j] = [];
					// alias of the data item
					arrData_i_j = arrData_i[j];
					// number of vertices
					num3 = arrData_i_j.length;
					// number of sides of 2D shape primitive
					var numSides:Number = (num3 - ((seriesCategory == "LINE") ? 1 : 0)) / 2;
					// number of faces of the 3D primitive
					var numFaces:Number = numSides + ((seriesCategory == "LINE") ? 1 : 2);
					// container for face vertices
					var arrFaceVertices:Array = [];
					// iterate for each face
					for (var k = 0; k < numFaces; ++k) {
						// get the face map
						var arrFaceMap:Array = Primitive.getFaceMap(k, numSides);
						// number of vertices in the face map
						num4 = arrFaceMap.length;
						// get the face vertices together
						for (var m = 0; m < num4; ++m) {
							arrFaceVertices[m] = arrData_i_j[arrFaceMap[m]];
						}
						// get the gace normal unit vector and add it
						arrNormals_i_j[k] = Light.getFaceNormal(arrFaceVertices);
					}
					break;
				}
			}
		}
		return arrNormals;
	}
	/**
	 * getFaceNormal method returns the normal unit vector 
	 * of the face.
	 * @param		arrFaceVertices		face vertices
	 * @return							normal unit vector
	 */
	private static function getFaceNormal(arrFaceVertices:Array):Array {
		// the first vector
		var a:Array = Vector.getVectorAB(arrFaceVertices[0], arrFaceVertices[1]);
		var b:Array;
		// 
		for (var i = 0; i < arrFaceVertices.length - 2; ++i) {
			// get the second vector
			b = Vector.getVectorAB(arrFaceVertices[i + 1], arrFaceVertices[i + 2]);
			// get the unit vector
			var n:Array = Vector.unitVectorAxB(a, b);
			// checking for a valid unit vector
			if (n != undefined) {
				// required obtained
				break;
			}
		}
		return n;
	}
	/**
	 * getFaceColorsUsingNormals method returns the face 
	 * colors using the face normals.
	 * @param		arrNormals			set of face normals
	 * @param		arrColors			color for series sets
	 * @param		intensityControl	light intensity
	 * @param		arrFaces			renderable faces
	 * @param		matrix				transformation matrix
	 * @return							face colors
	 */
	public static function getFaceColorsUsingNormals(arrNormals:Array, arrColors:Array, intensityControl:Number, arrFaces:Array, matrix:Matrix3D):Array {
		// container to be returned
		var arrFaceColors:Array = [];
		// local variables
		var num1:Number, num2:Number, num3:Number;
		var arrNormals_i:Array, arrNormals_i_j:Array;
		// number of series
		num1 = arrNormals.length;
		// iterate for each series
		for (var i = 0; i < num1; ++i) {
			// sub-container for series
			arrFaceColors[i] = [];
			// series base color
			var faceColor:Number = arrColors[i][0];
			// alias of face normals for the series
			arrNormals_i = arrNormals[i];
			// number of data items
			num2 = arrNormals_i.length;
			// iterate for each data item
			for (var j = 0; j < num2; ++j) {
				// sub-container for data item
				arrFaceColors[i][j] = [];
				// alias for face normals of the data item
				arrNormals_i_j = arrNormals_i[j];
				// number of faces
				num3 = arrFaces[i][j].length;
				// iterate for each face
				for (var k = 0; k < num3; ++k) {
					// face id
					var faceId:Number = arrFaces[i][j][k];
					// face normal in model space
					var arrNormalVector:Array = arrNormals_i_j[faceId];
					// transform the unit vector by the transformation matrix (resultant is a unit vector too)
					var arrVectorTransformed:Array = Transform3D.ptWorldToView(arrNormalVector, matrix);
					// color control factor
					var factor:Number = (1 - intensityControl) + intensityControl * arrVectorTransformed[2];
					// get the required color for the face
					var finalColorValue:Number = ColorExt.getDarkColor(faceColor.toString(16), factor);
					// add it
					arrFaceColors[i][j][faceId] = finalColorValue;
				}
			}
		}
		return arrFaceColors;
	}
	/**
	 * getFaceColors method returns the face colors without 
	 * using face normals.
	 * @param		arrColors			colors for series sets
	 * @param		arrPlot				data model in light space
	 * @param		arrChartType		series chart types
	 * @param		intensityControl	light intensity
	 * @return							face colors
	 */
	public static function getFaceColors(arrColors:Array, arrPlot:Array, arrChartType:Array, intensityControl:Number):Array {
		var strChartType:String;
		// container for colors
		var arrFaceColors:Array = (arguments[4] == undefined) ? [] : arguments[4];
		// iterate over data model
		for (var u = 0; u < arrPlot.length; ++u) {
			// chart type
			strChartType = (arguments[5] == undefined) ? arrChartType[u] : arguments[5];
			// if not the required data model level
			if (typeof arrPlot[u] == 'object' && typeof arrPlot[u][0][0] == 'object') {
				// sub-container for colors
				arrFaceColors[u] = [];
				// call recursively itself to dig to the pertinent level of data model
				arrFaceColors[u] = arguments.callee(arrColors[u], arrPlot[u], null, intensityControl, arrFaceColors[u], strChartType);
			} else {
				// for columns, color is evaluated for first block only and assigned to all others in the series
				// for first block of column type series
				if (u == 0 && strChartType == "COLUMN") {
					// flag to track whether a proper block with all face colors defined found (for zero vector issue)
					var found:Boolean = false;
				}
				// if not a column or its column and colors not yet found for it    
				if ((!found && strChartType == "COLUMN") || strChartType != "COLUMN") {
					// container for face vertices
					var arrFaceVertices:Array = [];
					// container for face colors
					var objColors:Object = {};
					// number of sides for the 2D shape primitive
					var numSides:Number = (arrPlot[u].length - ((strChartType == "LINE") ? 1 : 0)) / 2;
					// number of faces for the 3D primitive
					var numFaces:Number = numSides + ((strChartType == "LINE") ? 1 : 2);
					// iterate for each face
					for (var i:Number = 0; i < numFaces; ++i) {
						// face map
						var arrFaceMap:Array = Primitive.getFaceMap(i, numSides);
						// number of vertices defining the face
						var numLoops:Number = arrFaceMap.length;
						// get all vertices together
						for (var j:Number = 0; j < numLoops; ++j) {
							arrFaceVertices[j] = arrPlot[u][arrFaceMap[j]];
						}
						// get the face color and add it
						objColors[i] = Light.evalFaceColor(arrFaceVertices, arrColors[0], intensityControl);
					}
					//------------- zero vector issue --------------//
					// for column series
					if (strChartType == "COLUMN") {
						// flag for colors not found
						var notFound:Boolean = false;
						// iterate over face to check valid colors
						for (var faceId in objColors) {
							// if color value is zero
							if (objColors[faceId] == 0) {
								// invalid color ... thus colors not found
								notFound = true;
								break;
							}
						}
						// update flag
						if (notFound == false) {
							found = true;
						}
					}
					//--------------------------//                                                      
				}
				// add face colors    
				arrFaceColors.push(objColors);
			}
		}
		return arrFaceColors;
	}
	/**
	 * evalFaceColor method returns the face color.
	 * @param		arrFaceVertices		face vertices
	 * @param		faceColor			face base color
	 * @param		intensityControl 	light intensity
	 * @return							face color
	 */
	public static function evalFaceColor(arrFaceVertices:Array, faceColor:Number, intensityControl:Number):Number {
		// first vector
		var a:Array = Vector.getVectorAB(arrFaceVertices[0], arrFaceVertices[1]);
		var b:Array;
		// get the second valid vector for the purpose
		for (var i = 0; i < arrFaceVertices.length - 2; ++i) {
			// another vector
			b = Vector.getVectorAB(arrFaceVertices[i + 1], arrFaceVertices[i + 2]);
			// unit vector of cross product
			var n:Array = Vector.unitVectorAxB(a, b);
			// checking for valid unit vector
			if (n != undefined) {
				// found ... break
				break;
			}
		}
		// face normal unit vector found
		// unit vector along z-axis of light space
		var k:Array = [0, 0, 1];
		// angle between the 2 unit vectors
		var cosAlpha:Number = Vector.AdotB(n, k);
		// angle is the color control
		var intensity:Number = cosAlpha;
		// get the face color
		var finalColorValue:Number = ColorExt.getDarkColor(faceColor.toString(16), (1 - intensityControl) + intensityControl * intensity);
		return finalColorValue;
	}
}
