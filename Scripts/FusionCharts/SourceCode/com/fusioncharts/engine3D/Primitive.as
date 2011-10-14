/**
* @class Primitive
* @author InfoSoft Global (P) Ltd.
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Primitive class basically provides a method which returns
* vertex mapping of a face provided the face id along with
* primitive geometry.
*/
// class  definition
class com.fusioncharts.engine3D.Primitive {
	/**
	 * Constructor of Primitive class.
	 */
	private function Primitive() {
	}
	/**
	 * getFaceMap method returns the vertex mapping for the
	 * passed face id and primitive (polygon) geometric 
	 * characteristic.
	 * @param	faceId				numeric face id
	 * @param	polygonN			number of sides of primitive polygon
	 * @param	invertedPolygon		should polygon be mapped for 
	 *								face inversely (required for internal faces)
	 * @returns						vertex mapping
	 */
	public static function getFaceMap(faceId:Number, polygonN:Number, invertedPolygon:Boolean):Array {
		// container to hold the mapping
		var arrFaceMap:Array = [];
		// if the primitive defining polygon is a line or triangle or quadrilateral
		if (polygonN <= 4) {
			// if class already compiled and polygon not to be treated inversely
			if (Primitive.compiled && !invertedPolygon) {
				// return predefined face maps (face maps stored using this method itself when compiled)
				return Primitive['map_' + faceId + '_' + polygonN];
			}
		}
		//------------------------//     
		// The following portion of code executes for cases:
		// 1.	During compilation
		// 2.	For polygon to be treated inversely (for mapping inner faces)
		// 3.	For polygon with number of sides greater than 4
		//------------------------//
		// N.B: All mappings initially done to define outer face of the primitive. Reversing the map changes it define
		// the corresponding inner face.
		if (faceId < polygonN) {
			// -- for faces other than 'front' and 'back' ones, i.e. the side faces -- //
			/*
			N.B: Every side face will have exactly 4 vertices defining it. 
			Here, face vertex mapping is done in such a way that side vectors so obtained in order of the 
			mapping will provide the surface normal (by right hand screw rule) which directs outward.
			*/
			// to map the 2 front facing vertices
			for (var i = 0; i < 2; ++i) {
				// checking for cyclic end of vertices ... the zeroth one
				if (i == 1 && faceId == polygonN - 1) {
					// pushing the zeroth vertex
					arrFaceMap.push(0);
				} else {
					// pushing thee first vertex and conditionally the second vertex if its not the zeroth one
					arrFaceMap.push(faceId + i);
				}
			}
			// to map the 2 back facing vertices
			// iterating over the previous 2 vertex id in opposite order for correct ordering of vertices
			for (var i = 1; i >= 0; --i) {
				// pushing the respective front face vertex id plus the number of faces of the polygon
				arrFaceMap.push(arrFaceMap[i] + polygonN);
			}
		} else {
			// -- for 'front' or 'back' face -- //
			// if not a PLANE
			if (polygonN > 2) {
				// this number is the difference between vertex ids of a front facing vertex compared to its 
				// back facing counterpart vertex
				var addValue:Number = (faceId == polygonN) ? 0 : polygonN;
				// face vertex mapping
				for (var i = 0; i < polygonN; ++i) {
					arrFaceMap.push(i + addValue);
				}
				// if "front" face, reverse the map formed to comply with right hand screw rule for face normals
				if (addValue == 0) {
					arrFaceMap.reverse();
				}
				/*
				Some part of the polygon may be concave ... if that part is used to test for culling the face,                 
				then the face is culled ... although the face may not be culled actually. Culling algorithm uses
				first 3 vertices of the polygon face. Following line of code ensures that the first 3 points will
				always provide a convex situation. Actually, 3 points give 2 lines. We use the side of the 
				polygon parallel to x-axis, to be the first line of the 2, obtained by joining the first 2 points 
				of the 3.
				N.B: Here, we work only for FRONT and BACK faces of the 3D polygon. All other faces, are necessarily
				rectanngles or their perspective thereof. So, no chance of having concave situation with them.
				*/
				// shifting the last element in the map to the first position (cyclic order remains same); only that
				// the first 2 ids offer a vector parallel to the x-axis, for reason mentioned above
				arrFaceMap.unshift(arrFaceMap.splice(arrFaceMap.length - 1, 1));
			} else if (polygonN == 2) {
				// if a PLANE, a face id of "2" is possible, which claim the vertex map of
				// the line defining front side of the plane
				arrFaceMap.push(0, 1);
			}
		}
		/*
		 For the special case of the PLANE "vertex data structure", zeroth index is used to keep a vertex that
		 helps in depth management for the LINEs in THIS "engine". Actual vertices are at 1,2,3,4 indices.
		*/
		// if a PLANE
		if (polygonN == 2) {
			// iterate over the face map
			for (var i = 0; i < arrFaceMap.length; ++i) {
				// shift each id by +1
				arrFaceMap[i]++;
			}
		}
		// if face map required is that of internal rather than external, 
		// in which case face normal should direct in opposite direction
		if (invertedPolygon) {
			// just reverse the map order
			arrFaceMap.reverse();
		}
		// return the map
		return arrFaceMap;
	}
	/*
	 The following are some frequently used face maps, stored ready for optimization.
	 The catch lies in using a static method of this class itself to populate data in
	 them at compile time.
	*/
	// line
	private static var map_0_2:Array = getFaceMap(0, 2);
	private static var map_1_2:Array = getFaceMap(1, 2);
	private static var map_2_2:Array = getFaceMap(2, 2);
	// triangle
	private static var map_0_3:Array = getFaceMap(0, 3);
	private static var map_1_3:Array = getFaceMap(1, 3);
	private static var map_2_3:Array = getFaceMap(2, 3);
	private static var map_3_3:Array = getFaceMap(3, 3);
	private static var map_4_3:Array = getFaceMap(4, 3);
	// quadrilateral
	private static var map_0_4:Array = getFaceMap(0, 4);
	private static var map_1_4:Array = getFaceMap(1, 4);
	private static var map_2_4:Array = getFaceMap(2, 4);
	private static var map_3_4:Array = getFaceMap(3, 4);
	private static var map_4_4:Array = getFaceMap(4, 4);
	private static var map_5_4:Array = getFaceMap(5, 4);
	// flag at class end to indicate that compilation is over; refer "getFaceMap()" above to see its utility.
	private static var compiled:Boolean = true;
}
