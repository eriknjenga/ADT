/**
 * @class DefaultValues
 * @author InfoSoft Global (P) Ltd.
 * @version 3.0
 *
 * Copyright (C) InfoSoft Global Pvt. Ltd. 2008
 *
 * DefaultValues class holds various default values.
 */
 // class definition
class com.fusioncharts.engine3D.DefaultValues {
	// not to be instantiated (so kept private)
	private function DefaultValues() {
	}
	// default light intensity 
	public static var LIGHT_INTENSITY:Number = 0.2;
	// lower limit of chart scaling
	public static var MIN_SCALE:Number = 20;
	// defalut width of single data  (for LINE and AREA)
	public static var WIDTH_SINGLE_DATA:Number = 2;
	
}
