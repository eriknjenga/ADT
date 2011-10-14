/**
* @class Model
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Model class is responsible for providing methods
* for basic modelling of data items in model space.
*/
// import the engine3D package
import com.fusioncharts.engine3D.*;
// import the MathExt class
import com.fusioncharts.extensions.MathExt;
// class definition
class com.fusioncharts.engine3D.Model {
	/**
	 * Model class constructor.
	 */
	private function Model() {
	}
	/**
	 * getDataModel method returns a clone of the data item 
	 * model with an extra fourth component same as the 'y' 
	 * per vertex, to be used to animate chart initially with 
	 * growing data item appearance.
	 * @param		arrData		data item model
	 * @return 					clone of data model with fourth component
	 */
	public static function getDataModel(arrData:Array):Array {
		// local variables declared
		var num:Number, num1:Number, num2:Number, num3:Number;
		var arrData_i:Array, arrData_i_j:Array, arrData_i_j_k:Array;
		var arrClone_i:Array, arrClone_i_j:Array, arrClone_i_j_k:Array;
		// container to be returned
		var arrClone:Array = [];
		// number of series
		num = arrData.length;
		// iterate for each series
		for (var i = 0; i < num; i++) {
			// clone sub-container for series
			arrClone_i = arrClone[i] = [];
			// alias
			arrData_i = arrData[i];
			// number of data items in the series
			num1 = arrData_i.length;
			// iterate for each data item
			for (var j = 0; j < num1; j++) {
				// clone sub-container for data item
				arrClone_i_j = arrClone_i[j] = [];
				// alias
				arrData_i_j = arrData_i[j];
				// number of vertices for the data item
				num2 = arrData_i_j.length;
				// iterate for each vertex
				for (var k = 0; k < num2; k++) {
					// sub-container for vertex
					arrClone_i_j_k = arrClone_i_j[k] = [];
					// alias
					arrData_i_j_k = arrData_i_j[k];
					// number of components constituting the vertex
					num3 = arrData_i_j_k.length;
					// iterate for each component
					for (var m = 0; m < num3; m++) {
						// component cloned
						arrClone_i_j_k[m] = arrData_i_j_k[m];
						// adding the fourth component; same as "y"
						if (m == 1) {
							arrClone_i_j_k['y'] = arrClone_i_j_k[m];
						}
					}
				}
			}
		}
		return arrClone;
	}
	/**
	 * setNextDataModel method modifies the passed data model 
	 * by incrementing the second component (y) of each vertex.
	 * @param		arrData		data model to be modified
	 * @param		absDelY		value by which "y" be incremented
	 */
	public static function setNextDataModel(arrData:Array, absDelY:Number):Void {
		// alias
		var abs:Function = Math.abs;
		// variables declared
		var yValue:Number, yNow:Number, yNext:Number, yFinal:Number, sign:Number;
		var num:Number, num1:Number, num2:Number;
		var arrData_i:Array, arrData_i_j:Array, arrData_i_j_k:Array;
		// number of series
		num = arrData.length;
		// iterate for each series
		for (var i = 0; i < num; i++) {
			// alias of series data
			arrData_i = arrData[i];
			// number of data items in the series
			num1 = arrData_i.length;
			// iterate for each data item
			for (var j = 0; j < num1; j++) {
				// alias of the data item model
				arrData_i_j = arrData_i[j];
				// number of vertices in the data item
				num2 = arrData_i_j.length;
				// iterate for each vertex
				for (var k = 0; k < num2; k++) {
					// alias for the vertex
					arrData_i_j_k = arrData_i_j[k];
					// original "y" value
					yValue = arrData_i_j_k['y'];
					// sense of increment
					sign = (yValue != 0) ? abs(yValue) / yValue : 0;
					// current "y" value
					yNow = arrData_i_j_k[1];
					// if current and original "y" values are same
					if (yNow == yValue) {
						// no increment
						continue;
					}
					// next "y" value        
					yNext = yNow + sign * absDelY;
					// validating next "y" value compared to the original value
					yFinal = ((yValue - yNow) * (yValue - yNext) < 0) ? yValue : yNext;
					// "y" modified
					arrData_i_j_k[1] = yFinal;
				}
			}
		}
	}
	/**
	 * setIniDataModel method modifies passed data model to 
	 * make all second vertex component ("y") as zero.
	 * @param	arrData		data model to be modified
	 */
	public static function setIniDataModel(arrData:Array):Void {
		// variable declarations
		var num:Number, num1:Number, num2:Number;
		var arrData_i:Array, arrData_i_j:Array;
		// number of series
		num = arrData.length;
		// iterate for each series
		for (var i = 0; i < num; i++) {
			// alias of the series data
			arrData_i = arrData[i];
			// number of data items in the series
			num1 = arrData_i.length;
			// iterate for each data item
			for (var j = 0; j < num1; j++) {
				// alias for each vertex in the data item model
				arrData_i_j = arrData_i[j];
				// number of vertices
				num2 = arrData_i_j.length;
				// iterate for each vertex
				for (var k = 0; k < num2; k++) {
					// change "y" to zero
					arrData_i_j[k][1] = 0;
				}
			}
		}
	}
	/**
	 * getCuboidVertices method returns the cuboid model 
	 * in model space.
	 * @param		xOrigin		x origin
	 * @param		yOrigin		y origin
	 * @param		zOrigin		z origin
	 * @param		w			width
	 * @param		h			height
	 * @param		d			depth
	 * @return 					cuboid model
	 */
	public static function getCuboidVertices(xOrigin:Number, yOrigin:Number, zOrigin:Number, w:Number, h:Number, d:Number):Array {
		// container to be returned
		var arrVertex3D:Array = [];
		// have to map arrFace (back, top, right ...) w.r.t. structure of arrPoints 
		// this is for a right handed coordinate system ... +x --> right, +y --> up, +z --> out of plane towards me
		//
		// y origin
		var yOrigin:Number = (h < 0) ? yOrigin + h : yOrigin;
		// clockwise arrangement of 2D model
		var arrPoints:Array = [[xOrigin - w / 2, yOrigin], [xOrigin - w / 2, yOrigin + Math.abs(h)], [xOrigin + w / 2, yOrigin + Math.abs(h)], [xOrigin + w / 2, yOrigin]];
		// iterate for front and back facing vertices
		for (var i = 0; i < 2; ++i) {
			// z for the 2 faces
			var z:Number = (i == 1) ? zOrigin : zOrigin + d;
			// iterate for the 4 vertices per face
			for (var e = 0; e < arrPoints.length; ++e) {
				// cuboid possible if height specified
				if (isNaN(h)) {
					// add a blank array with provision for 3 components
					arrVertex3D.push(new Array(3));
					continue;
				}
				// vertex for valid cuboid added        
				arrVertex3D.push([arrPoints[e][0], arrPoints[e][1], z]);
			}
		}
		// return
		return arrVertex3D;
	}
	/**
	 * getPlaneVertices method returns the plane model in 
	 * model space.
	 * @param		x1			starting x
	 * @param		y1			starting y
	 * @param		x2			ending x
	 * @param		y2			ending y
	 * @param		zOrigin		z origin
	 * @param		d			z depth
	 * @return 					plane model
	 */
	public static function getPlaneVertices(x1:Number, y1:Number, x2:Number, y2:Number, zOrigin:Number, d:Number):Array {
		// container to be returned
		var arrVertex3D:Array = [];
		// have to map arrFace (back, top, right ...) w.r.t. structure of arrPoints 
		// this is for a right handed coordinate system ... +x --> right, +y --> up, +z --> out of plane towards me
		// 2D model - left to right
		var arrPoints:Array = [[x1, y1], [x2, y2]];
		// iterate twice - front and back (though neither front nor back face exists for PLANE)
		for (var i = 0; i < 2; ++i) {
			// pertinent z component value
			var z:Number = (i == 1) ? zOrigin : zOrigin + d;
			// 
			for (var e = 0; e < arrPoints.length; ++e) {
				arrVertex3D.push([arrPoints[e][0], arrPoints[e][1], z]);
			}
		}
		// if parameters invalid for creating a PLANE
		if (isNaN(y1) || isNaN(y2)) {
			// return blank vertices
			arrVertex3D = [[], [], [], []];
		}
		// an extra vertex added for intra series depth management                                                                                                                                                                                                                                       
		arrVertex3D.unshift([arrPoints[0][0], 0, zOrigin + d]);
		// return
		return arrVertex3D;
	}
	/**
	 * getArea3DVertices method returns the area3D models
	 * for the full series in model space.
	 * @param		arrH		set of heights for the data items
	 * @param		zOrigin		z origin
	 * @param		d			z depth
	 * @return 					area3D model for the full series
	 */
	public static function getArea3DVertices(arrH:Array, zOrigin:Number, d:Number):Array {
		// container to be returned
		var arrVertex3D:Array = [];
		// map of data item ids to manage discrete area3D models for provided invalid heights
		var arrDataIndexMap:Array = [];
		// map it
		for (var j = 0; j < arrH.length; ++j) {
			arrDataIndexMap.push((isNaN(arrH[j]['y'])) ? null : j);
		}
		// get the discrete area3D blocks
		// container for discrete blocks
		var arrSubDataBlocks:Array = [];
		// iterate over the data items
		for (var i = 0; i < arrDataIndexMap.length; ++i) {
			// create a sub-container for the first block initially
			if (i == 0) {
				arrSubDataBlocks.push([]);
			}
			// if a valid data item found    
			if (arrDataIndexMap[i] != null) {
				// add its id for the block
				arrSubDataBlocks[arrSubDataBlocks.length - 1].push(i);
			} else {
				// else, if an invalid data item found, create new block sub-container
				arrSubDataBlocks.push([]);
			}
		}
		// now remove blocks containing a single id or no id at all (a single data item can't make a area3D)
		for (var k = arrSubDataBlocks.length - 1; k >= 0; --k) {
			if (arrSubDataBlocks[k].length < 2) {
				arrSubDataBlocks.splice(k, 1);
			}
		}
		// go for creating the area3D models
		for (var i = 0; i < arrSubDataBlocks.length; ++i) {
			// container for holding data item params required for creating the models
			var arrBlockData:Array = [];
			// iterate over data item entries for the block
			for (var m = 0; m < arrSubDataBlocks[i].length; ++m) {
				// data item id 
				var id:Number = arrSubDataBlocks[i][m];
				// params added
				arrBlockData.push({x:arrH[id]['x'], y:arrH[id]['y']});
			}
			// get the are3D model for the block (actually may return more than one model for interception by zero plane)
			var arrVertex3DBlock:Array = getArea3DBlocks(arrBlockData, zOrigin, d);
			// add all models returned in the basic container
			for (var index = 0; index < arrVertex3DBlock.length; ++index) {
				arrVertex3D.push(arrVertex3DBlock[index]);
			}
		}
		// return
		return arrVertex3D;
	}
	/**
	 * getArea3DBlocks returns the area3D models for the 
	 * provided data managing intercept by zero plane.
	 * @param		arrH		set of heights
	 * @param		zOrigin		z origin
	 * @param		d			z depth
	 * @return 					area3D models
	 */
	public static function getArea3DBlocks(arrH:Array, zOrigin:Number, d:Number):Array {
		var x:Number, y:Number;
		// container to be returned
		var arrVertex3D:Array = [];
		// have to map arrFace (back, top, right ...) w.r.t. structure of arrPoints 
		// this is for a right handed coordinate system ... +x --> right, +y --> up, +z --> out of plane towards me
		// container holding face vertices of front face
		var arrPoints:Array = [];
		// if very first data item height not zero, add a vertex to start from zero height
		if (arrH[0]['y'] != 0) {
			arrPoints.push([arrH[0]['x'], 0]);
		}
		// iterate over data item entries for the block   
		for (var i = 0; i < arrH.length; ++i) {
			// vertex coordinates
			x = arrH[i]['x'];
			y = arrH[i]['y'];
			// add vertex
			arrPoints.push([x, y]);
		}
		// if last vertex is not of zero height, add one
		if (arrH[arrH.length - 1] != 0) {
			arrPoints.push([x, 0]);
		}
		// front face vertices ready   
		// now work to check and manage zero plane interception
		// to hold the first non-zero height; initialised to zero
		var firstNonZeroH:Number = 0;
		// get the first non-zero height entry
		for (var i = 0; i < arrPoints.length - 1; ++i) {
			if (arrPoints[i][1] != 0) {
				firstNonZeroH = arrPoints[i][1];
				break;
			}
		}
		// flag initialised for the first area3D block of whether to reverse the first block vertices
		var reverseBlock:Boolean = (firstNonZeroH > 0) ? false : true;
		// container to hold information about discrete blocks due zero palne intercepts
		var arrIntercept:Array = [];
		// iterate over the front face vertices
		for (var i = 0; i < arrPoints.length - 1; ++i) {
			// if consecutive heights are of opposite sign
			if (arrPoints[i + 1][1] * arrPoints[i][1] < 0) {
				// got a zero plane intercept
				// differences in coordinates of the 2 vertices
				var delX:Number = arrPoints[i + 1][0] - arrPoints[i][0];
				var delY:Number = arrPoints[i + 1][1] - arrPoints[i][1];
				// left vertex coordinates
				var x0:Number = arrPoints[i][0];
				var y0:Number = arrPoints[i][1];
				// get the x-intercept position
				var xIntercept:Number = MathExt.roundUp(-(delX / delY) * y0 + x0);
				// record the left data item id along with the x-intercept
				arrIntercept.push([i, xIntercept]);
			} else if (arrPoints[i + 2][1] * arrPoints[i][1] < 0 && arrPoints[i + 1][1] == 0) {
				// else, if a vertex lies on the zero plane
				// record the data item id and null for the x-intercept
				arrIntercept.push([i + 1, null]);
			}
		}
		// its all ready to go for final modelling for all
		var arrAreas:Array = [];
		// starting data item id for the first block is zero
		var id1:Number = 0;
		var x:Number;
		// iterate over the number of intercepts found, plus one for the ending block
		for (var i = 0; i <= arrIntercept.length; ++i) {
			// ending data item id for the block
			var id2:Number = (i != arrIntercept.length) ? arrIntercept[i][0] : arrPoints.length - 1;
			// get the vertices (2D) for the block
			var arrSubArea:Array = [];
			// first vertex of blocks other than the first block
			if (i != 0 && x != null) {
				arrSubArea.push([x, 0]);
			}
			// add the vertices   
			for (var j = id1; j <= id2; ++j) {
				arrSubArea.push([arrPoints[j][0], arrPoints[j][1]]);
			}
			// last vertex of blocks other than the last block or block which have ending vertex on zero plane
			if (i != arrIntercept.length && arrIntercept[i][1] != null) {
				arrSubArea.push([arrIntercept[i][1], 0]);
			}
			// if block below zero plane (negative heights), reverse the vertices   
			if (reverseBlock) {
				arrSubArea.reverse();
			}
			// reverse the flag for the next block which must be on opposite side of the zero plane   
			reverseBlock = !reverseBlock;
			// add the block 2D model
			arrAreas.push(arrSubArea);
			// starting x value for the next bloxk
			x = arrIntercept[i][1];
			// starting data item id for next block
			id1 = id2 + ((arrIntercept[i][1] == null) ? 0 : 1);
		}
		// iterate over all blocks
		for (var m = 0; m < arrAreas.length; ++m) {
			// sub-container for the area3D model for this block
			arrVertex3D[m] = [];
			// 2D vertices of the block
			var arrPoints:Array = arrAreas[m];
			// iterate twice - front and back face
			for (var i = 0; i < 2; ++i) {
				// pertinent z value for the face
				var z:Number = (i == 1) ? zOrigin : zOrigin + d;
				// iterate over the 2D vertices
				for (var e = 0; e < arrPoints.length; ++e) {
					// add the 3D vertex
					arrVertex3D[m].push([arrPoints[e][0], arrPoints[e][1], z]);
				}
			}
		}
		// return
		return arrVertex3D;
	}
}
