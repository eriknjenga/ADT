/**
* @class Matrix3D
* @author InfoSoft Global (P) Ltd.
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2008
*
* Matrix3D class creates a 3x3 matrix and provides a 
* number of functions relating matrix math operations.
*/
// import the MathExt class
import com.fusioncharts.extensions.MathExt;
// class definition
class com.fusioncharts.engine3D.Matrix3D {
	// array to hold the columns as sub-arrays
	private var arrMatrix:Array;
	/**
	 * Matrix3D constructor which populates its 9 elements 
	 * being passed as arguments.
	 * @param	a	element of row 1 column 1
	 * @param	b	element of row 1 column 2
	 * @param	c	element of row 1 column 3
	 * @param	d	element of row 2 column 1
	 * @param	e	element of row 2 column 2
	 * @param	f	element of row 2 column 3
	 * @param	g	element of row 3 column 1
	 * @param	h	element of row 3 column 2
	 * @param	i	element of row 3 column 3
	 */
	public function Matrix3D(a:Number, b:Number, c:Number, d:Number, e:Number, f:Number, g:Number, h:Number, i:Number) {
		arrMatrix = [];
		/*
		
		 |  a b c  |
		 |  d e f  |
		 |  g h i  |
		 
		*/
		// each sub array is a column of the matrix
		// first column
		arrMatrix[0] = [a, d, g];
		// second column
		arrMatrix[1] = [b, e, h];
		// third column
		arrMatrix[2] = [c, f, i];
	}
	/**
	 * concat method transforms the passed row vector by
	 * multiplying it with the matrix (instance) to return
	 * the resultant transformed row vector.
	 * @param	arrVector	row vector to be transformed (array)
	 * @returns				transformed row vector (array)
	 */
	public function concat(arrVector:Array):Array {
		// [arrVector][arrMatrix] = [transformedVector]
		// Both arrVector and transformedVector are row vectors.
		// local reference of frequently used functions
		var roundUp:Function = MathExt.roundUp;
		var scalarProduct:Function = this.scalarProduct;
		// container to constitute the transformed vector created
		var transformedVector:Array = [];
		// array length
		var num:Number = arrVector.length;
		// iterate for 3 columns of arrMatrix
		for (var i = 0; i < num; ++i) {
			// scalar product of row vector and the matrix column under loop evaluated, resultant being
			// the corresponding entry of the transformed row vector
			transformedVector[i] = roundUp(scalarProduct(arrVector, arrMatrix[i]));
		}
		// returns the new vector
		return transformedVector;
	}
	/**
	 * scalarProduct method returns the resultant value after
	 * due scalar multiplication of the 2 passed arrays.
	 * @param	arr1	array holding 3 entries
	 * @param	arr2	array holding another 3 entries
	 * @returns			resultant scalar product 
	 */
	private function scalarProduct(arr1:Array, arr2:Array):Number {
		// container to hold the calculation
		var productvalue:Number = 0;
		// array length
		var num:Number = arr1.length;
		// iterated once for each entry in either of the passed arrays
		for (var i = 0; i < num; ++i) {
			// multiplies respective entries from the 2 arrays
			productvalue += arr1[i] * arr2[i];
		}
		// returns the result
		return productvalue;
	}
	/**
	 * concatGeom method returns a new matrix after due 
	 * concatenation of the matrix (instance) with the
	 * passed matrix in order [matrixInstance][matrixParam].
	 * @param	otherMatrix3D	matrix to concate with instance
	 * @returns					resultant concatenated matrix
	 */
	public function concatGeom(otherMatrix3D:Matrix3D):Matrix3D {
		// order: [matrixInstance] x [matrixParam]
		// container to form rows for scalar multiplication with ready columns of passed matrix
		var arrRow:Array = [];
		// resultant matrix created without passing its 9 entries
		var arrProduct:Matrix3D = new Matrix3D();
		// order of square matrix ... number to be used in iteration
		var order:Number = this.arrMatrix.length;
		// work with i th column of second matrix
		for (var i = 0; i < order; ++i) {
			// work with j th row of first matrix
			for (var j = 0; j < order; ++j) {
				// j th row to be formed in an array
				for (var k = 0; k < order; ++k) {
					// storing respective elements for the row
					arrRow[k] = arrMatrix[k][j];
				}
				// each of the 9 entries of the resultant matrix evaluated through scalar multiplication
				// of row from first matrix and the respective column from the second matrix, and filled 
				// in its respective position
				// entry for i th column and j th row
				arrProduct.arrMatrix[i][j] = MathExt.roundUp(this.scalarProduct(arrRow, otherMatrix3D.arrMatrix[i]));
			}
		}
		// returns the resultant concatenated matrix
		return arrProduct;
	}
	/**
	 * transpose method undergoes matrix transposition of
	 * the matrix instance.
	 */
	public function transpose() {
		// a temporary container to hold entries in required order
		var arrTemp:Array = [];
		// storing all 9 elements in order together, with all 3 elements of first row followed 
		// by all 3 of second and so on.
		for (var i = 0; i < 3; ++i) {
			for (var j = 0; j < 3; ++j) {
				arrTemp.push(this.arrMatrix[j][i]);
			}
		}
		// voiding column arrays
		this.arrMatrix = [];
		// refilling column arrays so as to get the transpose
		for (var i = 0; i < 3; ++i) {
			this.arrMatrix.push(arrTemp.splice(0, 3));
		}
	}
	/**
	 * clone method returns an independent clone of the 
	 * matrix instance.
	 */
	public function clone():Matrix3D {
		// new matrix instance formed
		var newMatrix:Matrix3D = new Matrix3D();
		// entries filled in
		for (var i = 0; i < 3; ++i) {
			for (var j = 0; j < 3; ++j) {
				newMatrix.arrMatrix[i][j] = this.arrMatrix[i][j];
			}
		}
		// clone returns
		return newMatrix;
	}
	/**
	 * data is a getter method that returns the actual
	 * array holding the 9 entries in 3 sub-arrays as
	 * columns.
	 */
	public function get data():Array {
		return this.arrMatrix;
	}
	/**
	 * getElement method returns the respective entry for
	 * the row and column ids passed.
	 * @param	rowId		row id
	 * @param	columnId	column id
	 * @returns				the respective element
	 */
	public function getElement(rowId:Number, columnId:Number):Number {
		// index of row and column are zero relative 
		return this.arrMatrix[columnId][rowId];
	}
	/**
	 * getCofactor method returns the cofactor after after
	 * due calculation w.r.t. passed row and column ids.
	 * @param	rowId		row id
	 * @param	columnId	column id
	 * @returns				the cofactor value
	 */
	public function getCofactor(rowId:Number, columnId:Number):Number {
		// index of row and column are zero relative 
		// container to hold the cofactor entries
		var arrCofactor:Array = [];
		// work with columns of the matrix
		for (var i = 0; i < 3; ++i) {
			// no work with column corresponding to the passed id
			if (i != columnId) {
				// current length of the array
				var arrLength:Number = arrCofactor.push([]);
				// array to fill entries in (cofactor entry)
				var arrWorking:Array = arrCofactor[arrLength - 1];
				// work with rows of the matrix
				for (var j = 0; j < 3; ++j) {
					// no work with row corresponding to the passed id
					if (j != rowId) {
						// filling elements in
						arrWorking.push(this.arrMatrix[i][j]);
					}
				}
			}
		}
		// absolute value of cofactor found
		var coFactorValue:Number = arrCofactor[0][0] * arrCofactor[1][1] - arrCofactor[0][1] * arrCofactor[1][0];
		// sign of cofactor added
		coFactorValue *= Math.pow(-1, rowId + columnId);
		// cofactor returned
		return coFactorValue;
	}
	/**
	 * determinant is a getter method to return the
	 * determinant of 3x3 matrix.
	 */
	public function get determinant():Number {
		// first term of determinant
		var a:Number = this.getElement(0, 0) * this.getCofactor(0, 0);
		// second term of determinant
		var b:Number = this.getElement(0, 1) * this.getCofactor(0, 1);
		// third term of determinant
		var c:Number = this.getElement(0, 2) * this.getCofactor(0, 2);
		// summation of the 3 terms to give the determinant
		var detValue:Number = a + b + c;
		// returns the determinant
		return detValue;
	}
	/**
	 * inverse is getter method used to return the inverse
	 * of the matrix instance.
	 */
	public function get inverse():Matrix3D {
		// a new matrix instance formed
		var inverseMatrix:Matrix3D = new Matrix3D();
		// work with columns
		for (var i = 0; i < 3; ++i) {
			// work with rows
			for (var j = 0; j < 3; ++j) {
				// cofactors of each position evaluated and filled in the position itself
				inverseMatrix.arrMatrix[i][j] = this.getCofactor(j, i);
			}
		}
		// transpose the matrix
		inverseMatrix.transpose();
		// get the determinant of the original matrix instance whose inverse is required
		var determinant:Number = this.determinant;
		// if the original matrix is non-singular
		if (determinant != 0) {
			// multiply the reciprocal of the detrminant with the formed matrix to get the ultimate
			// inverse matrix
			inverseMatrix.multiply(1 / determinant);
		} else {
			// else, matrix is singular and inverse not possible
			// stops working ... returns nothing
			return;
		}
		//inverse matrix returned
		return inverseMatrix;
	}
	/**
	 * multiply method is used for scalar multiplication of 
	 * matrix.
	 * @param	multiplier	the scalar to multiply
	 */
	private function multiply(multiplier:Number):Void {
		// work with columns
		for (var i = 0; i < 3; ++i) {
			// work with rows
			for (var j = 0; j < 3; ++j) {
				// each element of the matrix is multiplied by the passed number (a scalar by matrix terminology)
				this.arrMatrix[i][j] *= multiplier;
			}
		}
	}
}
