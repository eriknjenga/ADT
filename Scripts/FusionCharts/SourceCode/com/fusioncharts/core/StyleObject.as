 /**
* @class StyleObject
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006

* StyleObject class helps us group the various style options
* that we offer to end users. This class is made dynamic so
* that we can add any named style property to any StyleObject
* at run-time.
* In FusionCharts, the following styles are supported:
* FONT - Lets the user specify font and text properties
* PAINT - Lets the user specify fill and border properties
* ANIMATION - Lets the user specify animation effects
* SHADOW - Applies a shadow effect to the specified object.
* BLUR - Applies a blur effect to the specified object.
* GLOW - Applies a glow effect to the specified object.
*/
import com.fusioncharts.extensions.ColorExt;
dynamic class com.fusioncharts.core.StyleObject 
{
	function StyleObject ()
	{
		//Empty constructor.
		
	}
	//Some methods that help us validate the data entered for
	//each style object.
	/**
	* This method takes in a hex color (string value) and
	* checks whether the hex value is correct as required by
	* FusionCharts. FusionCharts hex value needs to be without #.
	* @param	strColor	Hex value to be checked
	* @return				Formatted hex value
	*/
	public static function checkHexColor (strColor : String) : String 
	{
		return ColorExt.formatHexColor (strColor);
	}
}
