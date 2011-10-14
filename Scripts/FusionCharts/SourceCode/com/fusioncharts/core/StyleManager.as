 /**
* @class StyleManager
* @author InfoSoft Global (P) Ltd. www.InfoSoftGlobal.com
* @version 3.0
*
* Copyright (C) InfoSoft Global Pvt. Ltd. 2005-2006

* StyleManager class helps each chart manage its own list of styles
* and apply them to individual objects of the chart.
* In FusionCharts v3, the following styles are supported:
* FONT - Lets the user specify font and text properties
* ANIMATION - Lets the user specify his own animation effects
* SHADOW - Applies a shadow effect to the specified object.
* BLUR - Applies a blur effect to the specified object.
* GLOW - Applies a glow effect to the specified object.
* BEVEL - Applies a bevel effect to the specified object.
*
* We've three data storage structures in this class.
* 1. styles - HashTable -	Stores Style name as key
*							and StyleObject as value.
*							Central repository for style
*							definition.
* 2. objectStyle - Array - Stores a list of style for each
*							chart object. The key is the object
*							id (numeric) and the value is an array
*							of style names applicable to that object.
* 3. styleType - Array -	Stores a list of style and it's type.
* 							Basically, meant for faster look-up.
*/
//Import tween class to support animations
import mx.transitions.Tween;
//Import relevant classes
import com.fusioncharts.core.Chart;
import com.fusioncharts.helper.Utils;
import com.fusioncharts.extensions.StringExt;
import com.fusioncharts.helper.FCEnum;
import com.fusioncharts.helper.FCError;
import com.fusioncharts.core.StyleObject;
import com.fusioncharts.helper.Logger;
import com.fusioncharts.helper.HashTable;
import com.fusioncharts.helper.Macros;
//Import filter classes
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.BevelFilter;
import flash.filters.GlowFilter;
class com.fusioncharts.core.StyleManager 
{
	//Create enumeration for the various style type that's supported
	public var TYPE : FCEnum;
	//styles HashTable stores all the style defintion for the chart
	private var styles : HashTable;
	//objectStyle array stores the object-style association info
	private var objectStyle : Array;
	//styleType array stores the style-type association info
	private var styleType : Array;
	//Chart class which is associated with this style manager
	private var chartIns : Chart;
	//Constructor function
	function StyleManager (chartIns : Chart)
	{
		//Store chart instance
		this.chartIns = chartIns;
		//Intitiate the styles array
		styles = new HashTable ();
		//Initiate other arrays too.
		objectStyle = new Array ();
		styleType = new Array ();
		//Enumerate the list
		TYPE = new FCEnum ("FONT", "ANIMATION", "SHADOW", "BLUR", "GLOW", "BEVEL");
	}
	/**
	* addStyle method defines a style method for this chart.
	* @param	strStyleName	Name of the style
	* @param	intStyleType	Type of style.
	* @param	objStyle		Style object with style
	*							parameters.
	* @return					Boolean value indicating
	*							whether the style was successfully
	*							added to style register.
	*/
	public function addStyle (strStyleName : String, intStyleType : Number, objStyle : StyleObject) : Boolean 
	{
		//Remove any spaces from style name
		strStyleName = StringExt.replace (strStyleName, " ", "");
		//Capitalize for case insensitive string match
		strStyleName = strStyleName.toUpperCase ();
		//Add the name and type to style object
		objStyle.name = strStyleName;
		objStyle.type = intStyleType;
		//Add the style to register (hash table)
		styles.put (strStyleName, objStyle);
		//Add the style to style-Type register
		this.styleType [strStyleName] = intStyleType;
		return true;
	}
	/**
	* associateStyle method associates a style with a chart object.
	*	@param	chartObject		Numeric index of chart object for which
	*							we're defining style
	*	@param	strStyleName	Name of style which we're associating.
	*/
	public function associateStyle (chartObject : Number, strStyleName : String) : Boolean 
	{
		//Remove any spaces from style name
		strStyleName = StringExt.replace (strStyleName, " ", "");
		//Capitalise for case-insensitive string match
		strStyleName = strStyleName.toUpperCase ();
		//Check if the style name is a valid one
		if ( ! isValidStyle (strStyleName))
		{
			//Throw error
			throw new FCError ("Invalid Style Name in Style Definition", "Style \"" + strStyleName + "\" has not been defined and as such cannot be associated with a chart object.", Logger.LEVEL.ERROR);
			return false;
		}
		//Get the current list of styles defined for this object
		var currentStyles : Array;
		currentStyles = this.objectStyle [chartObject];
		if (currentStyles == undefined)
		{
			//Create a new array to store styles for this object
			this.objectStyle [chartObject] = new Array (strStyleName);
		} else 
		{
			//We iterate through the array to find, whether this style
			//has already been associated with this chart object
			var associated : Boolean = false;
			var i : Number;
			for (i = 0; i < currentStyles.length; i ++)
			{
				//Check whether the style exists for the object
				if (strStyleName == currentStyles [i])
				{
					associated = true;
					break;
				}
			}
			//If the style was not already associated, push it in
			if ( ! associated)
			{
				this.objectStyle [chartObject].push (strStyleName);
			}
		}
	}
	/**
	* overrideAssociation association over-rides the association of a style
	* with another style. This is useful when a particular user defined style
	* method is over-riden with default values. In that case, we create a new
	* style by merging the values of user defined and default object, and then
	* add it to style register. Post that, we update the association of the
	* object from old style name to new style name.
	*	@param		chartObject		Chart object for which we've to update.
	*	@param		strOldStyleName	Old style name which we've to update.
	*	@param		strStyleName	New Style name which will update the old one.
	*/
	private function overrideAssociation (chartObject : Number, strOldStyleName : String, strStyleName : String) : Void 
	{
		//Get the current list of styles defined for this object
		var currentStyles : Array;
		currentStyles = this.objectStyle [chartObject];
		//Iterate through the array and update the array
		var i : Number;
		for (i = 0; i < currentStyles.length; i ++)
		{
			if (currentStyles [i] == strOldStyleName)
			{
				//Replace
				currentStyles [i] = strStyleName;
			}
		}
		//Re-set the array in association register
		this.objectStyle [chartObject] = currentStyles;
	}
	/**
	* getStyleTypeId method returns the id of a given style.
	* Id is the numerical value stored in TYPE array of this class.
	*	@param	strStyleType	Style type whose id we need to find
	*	@return				The id of the type if found. Else -1
	*/
	public function getStyleTypeId (strStyleType : String) : Number 
	{
		//Capitalize strStyleType for case-insensitive match
		strStyleType = strStyleType.toUpperCase ();
		//Type id
		var typeId : Number;
		//Select from enumeration
		typeId = this.TYPE [strStyleType];
		//If the type is not defined, we set it as -1 and also throw error
		if (typeId == undefined)
		{
			typeId = - 1;
			//Throw error
			throw new FCError ("Invalid Style Type", "Invalid Style type \"" + strStyleType + "\" specified. Only possible values for Style type are FONT, ANIMATION, SHADOW, BEVEL, GLOW & BLUR.", Logger.LEVEL.ERROR);
		}
		return typeId;
	}
	/**
	* getStyle method does two things:
	* 1. It helps check whether a style of a particular type has
	* been defined for the given object.
	* 2. If yes, it returns that style for the object.
	* NOTE: If the style is animation, we also check against the param
	* property of animation style object, as multiple animation styles
	* can be defined for a single object.
	*	@param	chartObject		Numeric id of the chart object for which
	*							we need the style
	*	@param	strStyleType	Style Type which we've to find for the object
	*	@param	animationParam	Animation Parameter to check against (only in
	*							case of animation)
	*	@return				A style object containing style properties for that
	*							type for that object. If the style is not defined
	*							for that type and object, an empty style object
	*							with isDefined flag defined set as false is returned.
	* 							Else, this flag is set as true and the style object
	*							contains actual style properties.
	*/
	public function getStyle (chartObject : Number, intStyleType : Number, animationParam : String) : StyleObject 
	{
		//Get the list of styles applicable for this object
		var objStyles : Array = new Array ();
		objStyles = this.objectStyle [chartObject];
		//Style object to be returned
		var rtnStyleObj : StyleObject = new StyleObject ();
		//By default assume, style is not present
		var isDefined : Boolean = false;
		var i : Number;
		//If the style type is animation
		if (intStyleType == this.TYPE.ANIMATION)
		{
			//List all the animation styles for this obhect and compare
			//the param attribute of style object with animationParam.
			//If match is found, return true
			//First get all animation style objects for this chart object
			//Storage container
			var animationStyles : Array = new Array ();
			for (i = 0; i < objStyles.length; i ++)
			{
				if (intStyleType == this.styleType [objStyles [i]])
				{
					animationStyles.push (this.styles.get (objStyles [i]));
				}
			}
			//Capitalize animation parameter for case insensitive match
			animationParam = animationParam.toUpperCase ();
			//Now iterate through the animation styles and see if a style has
			//been defined for the animationParam property for this object
			for (i = 0; i < animationParam.length; i ++)
			{
				if (animationStyles [i].param.toUpperCase () == animationParam)
				{
					//Save the style
					rtnStyleObj = StyleObject (animationStyles [i]);
					isDefined = true;
					break;
				}
			}
		} else 
		{
			//Check whether a style of this type is already present in the list
			//If yes, return true
			for (i = 0; i < objStyles.length; i ++)
			{
				if (intStyleType == this.styleType [objStyles [i]])
				{
					rtnStyleObj = StyleObject (this.styles.get (objStyles [i]));
					isDefined = true;
					break;
				}
			}
		}
		//Set the flag
		rtnStyleObj.isDefined = isDefined;
		return rtnStyleObj;
	}
	/**
	* overrideStyle method helps us detect which style parameter to use
	* in case of conflicts. For example, when the user has defined a global
	* attribute and after that a style tag for a particular element, this
	* method helps resolve.
	* @param	chartObject		Numerical id of the chart object for which
	*							we're working on style details.
	* @param
	* @return					The final style object
	*/
	public function overrideStyle (chartObject : Number, defaultObject : StyleObject, intStyleType : Number, animationParam : String) : StyleObject 
	{
		//First, get the style for this object
		var objectStyle : StyleObject = new StyleObject ();
		objectStyle = this.getStyle (chartObject, intStyleType, animationParam);
		//Now, if the style is already defined for this object and type
		if (objectStyle.isDefined == true)
		{
			//We need to merge the two styles - style for this object
			//and our default style parameters.
			//First read the parameters already existing in user
			//defined style
			var newStyle : StyleObject = new StyleObject ();
			var item : Object;
			for (item in objectStyle)
			{
				newStyle [item] = Utils.getFirstValue (objectStyle [item] , defaultObject [item]);
			}
			//Now, for those items which are not present in user style object
			for (item in defaultObject)
			{
				newStyle [item] = Utils.getFirstValue (objectStyle [item] , defaultObject [item]);
			}
			/*
			* Reason for creating new style:
			* One style definition can be associated with multiple objects in the chart.
			* So, if we over-ride some of user defined style values with our internal
			* values, we are actually over-riding this style for all objects. Whereas,
			* it should just be over-ridden for that particular object. So, we create a new
			* style object internally, allot it the merged attributes from user defined
			* style and our default style, add the object to style register, and update
			* the association of the chart object from old style name (user defined) to
			* the new one.
			*/
			//Add this new style to style registry
			//First, check if a name has been defined for this style. If not
			//attach an arbitrary name.
			var styleName : String = defaultObject.name.toUpperCase ();
			styleName = (styleName == undefined) ? (String ("_S" + getTimer ())) : (styleName);
			//Finally update the style registry with the new style object
			this.addStyle (styleName, intStyleType, newStyle);
			//Over-ride association - i.e., over-ride the old style object's name
			//associated with this chart object to the newly created one.
			this.overrideAssociation (chartObject, objectStyle.name, styleName);
			//Return
			return objectStyle;
		} else 
		{
			//First, check if a name has been defined for this style. If not
			//attach an arbitrary name.
			var styleName : String = defaultObject.name;
			styleName = (styleName == undefined) ? (String ("_S" + getTimer ())) : (styleName);
			//We add this style to our style register
			this.addStyle (styleName, intStyleType, defaultObject);
			//And, we associate it with the given chart object
			this.associateStyle (chartObject, styleName);
			//Return
			return defaultObject;
		}
	}
	/**
	* isValidStyle checks whether a given style name is a valid
	* name. A valid style name is one which has been fed into
	* styles hashtable using addStyle method.
	* @param	strStyleName	Style named to be validated
	* @return					Boolean value indicating whether
	*							the given style name is valid.
	*/
	public function isValidStyle (strStyleName : String) : Boolean 
	{
		//Just check in the hash table and return value
		return styles.containsKey (strStyleName);
	}
	/**
	* getTextStyle method helps get the style properties of the text as an object
	* for a particular chart object.
	* @param	chartObject		Numeric id of the chart object, for which we've
	*							to retrieve the font properties and convert it into
	*							a text format.
	* @return					Object with tf as text format object reflecting the style
	*							properties of this object and any other miscellaneous parameters
	*							as properties of object.
	*/
	public function getTextStyle (chartObject : Number) : Object 
	{
		//Get the style properties of this object
		var objStyle : StyleObject = new StyleObject ();
		objStyle = getStyle (chartObject, this.TYPE.FONT, "");
		//Create a new return Object
		var rtnObj : Object = new Object ();
		//Set the properties and defaults
		rtnObj.align = Utils.getFirstValue (objStyle.align, "center");
		rtnObj.vAlign = Utils.getFirstValue (objStyle.valign, "middle");
		rtnObj.bold = (objStyle.bold == "1") ? true : false;
		rtnObj.italic = (objStyle.italic == "1") ? true : false;
		rtnObj.underline = (objStyle.underline == "1") ? true : false;
		rtnObj.font = Utils.getFirstValue (objStyle.font, "Verdana");
		rtnObj.size = Number (Utils.getFirstValue (objStyle.size, 9));
		rtnObj.color = StyleObject.checkHexColor (Utils.getFirstValue (objStyle.color, "000000"));
		rtnObj.isHTML = (objStyle.ishtml == "1") ? true : false;
		rtnObj.leftMargin = Number (Utils.getFirstValue (objStyle.leftmargin, 0));
		rtnObj.letterSpacing = Number (Utils.getFirstValue (objStyle.letterspacing, 0));
		rtnObj.bgColor = StyleObject.checkHexColor (objStyle.bgcolor);
		rtnObj.borderColor = StyleObject.checkHexColor (objStyle.bordercolor);
		return rtnObj;
	}
	/**
	* getMaxAnimationTime method helps us get the maximum animation time required
	* for the list of chart objects specified. Each chart object can have multiple
	* animation sequences. So, we first get the maximum animation time for all
	* animation defined for a chart object. Then we compare it against the other
	* chart objects.
	*	@param	List of chart objects separated by comma.
	*	@return	Maximum animation time required for any animation style
	*				for the given chart objects.
	*/
	public function getMaxAnimationTime () : Number
	{
		//Initialize variables
		var time : Number = 0;
		var totalMaxTime : Number = 0
		var chartObjMaxTime : Number = 0;
		//Array to store the styles for a particular object
		var objStyles : Array
		//Iterate through all the parameters (chart object ids) provided
		var i : Number, j : Number;
		for (i = 0; i < arguments.length; i ++)
		{
			//Get the list of styles applicable for this object
			objStyles = new Array ();
			objStyles = this.objectStyle [arguments [i]];
			//Iterate through all the animation styles for this object and store max
			for (j = 0; j < objStyles.length; j ++)
			{
				//If it's animation style
				if (this.styleType [objStyles [j]] == this.TYPE.ANIMATION)
				{
					//If duration is not defined, we take 2 as default, as later on too,
					//when animating, we take 2 as default.
					time = Number (Utils.getFirstValue (this.styles.get (objStyles [j]).duration, 2));
					if ( ! isNaN (Number (this.styles.get (objStyles [j]).wait)))
					{
						time = time + Number (this.styles.get (objStyles [j]).wait);
					}
					chartObjMaxTime = (time > chartObjMaxTime) ?time : chartObjMaxTime;
				}
			}
			//Compare for the maximum among different chart objects
			totalMaxTime = (chartObjMaxTime > totalMaxTime) ?chartObjMaxTime : totalMaxTime;
		}
		//Convert to milli-seconds and then return
		return totalMaxTime * 1000;
	}
	/**
	* applyAnimation method adds animation to the given movie clip
	* from the style repository, based on the numeric id of the chart
	* object which is being represented by this movie clip
	*	@param	mc			Movie clip to which we've to apply animation
	*	@param	chartObject	The numeric id of chart object which is being
	*						represented by this movie clip
	*/
	public function applyAnimation (mc : MovieClip, chartObject : Number, macroIns : Macros, dX : Number, adX : Number, dY : Number, adY : Number, dAlpha : Number, dXScale : Number, dYScale : Number, dRotation : Number) : Void 
	{
		//First up, we need to get a list of animation styles defined for this chart object.
		//Get the list of styles applicable for this object
		var objStyles : Array = new Array ();
		objStyles = this.objectStyle [chartObject];
		var i : Number;
		//First get all animation style objects for this chart object
		//Storage container for all animation styles
		var animationStyles : Array = new Array ();
		for (i = 0; i < objStyles.length; i ++)
		{
			//If it's animation style
			if (this.styleType [objStyles [i]] == this.TYPE.ANIMATION)
			{
				animationStyles.push (this.styles.get (objStyles [i]));
			}
		}
		//Now, apply the animations
		if (animationStyles.length > 0)
		{
			var tweens : Array = new Array ();
			var easing : String;
			var easingFunction : Function;
			for (i = 0; i < animationStyles.length; i ++)
			{
				//We first get the end value for this tween animation.
				//End values are specified as parameters as dX or dY or dAlpha.
				//So, suppose a particular chart object can support only XScale and Alpha
				//animations. Only dXScale and dAlpha would be provided to this function
				//and those would serve as the animation (tween) end values. For rest,
				//we wouldn't animate at all
				var start : Number;
				var end : Number;
				switch (animationStyles [i].param.toLowerCase ())
				{
					case "_x" :
					end = dX;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start)) - Number (adX);
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
					case "_y" :
					end = dY;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start)) - Number (adY);
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
					case "_xscale" :
					end = dXScale;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start));
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
					case "_yscale" :
					end = dYScale;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start));
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
					case "_rotation" :
					end = dRotation;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start));
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
					case "_alpha" :
					end = dAlpha;
					try
					{
						start = Number (macroIns.evalMacroExp (animationStyles [i].start));
					}catch (e : com.fusioncharts.helper.FCError)
					{
						//If the control comes here, that means the macro was invalid.
						//Set start as end, so that this animation doesn't perform
						start = end;
						//So, we need to log it.
						this.chartIns.log (e.name, e.message, e.level);
					}
					break;
				}
				//If end is still undefined or null or not a number, or start and
				//end values are same we do not perform animation
				if ( ! (end == null || end == undefined || isNaN (end)) && ! (start == end))
				{
					//Get the easing function for animation.
					//Define a default easing property, if no easing property has
					//been specified
					easing = Utils.getFirstValue (animationStyles [i].easing, "regular");
					//Based on easing property, get the easing function
					switch (easing.toLowerCase ())
					{
						case "back" :
						easingFunction = mx.transitions.easing.Back.easeOut;
						break;
						case "elastic" :
						easingFunction = mx.transitions.easing.Elastic.easeOut;
						break;
						case "bounce" :
						easingFunction = mx.transitions.easing.Bounce.easeOut;
						break;
						case "regular" :
						easingFunction = mx.transitions.easing.Regular.easeOut;
						break;
						case "strong" :
						easingFunction = mx.transitions.easing.Strong.easeOut;
						break;
						case "none" :
						easingFunction = mx.transitions.easing.None.easeNone;
						break;
						default :
						easingFunction = mx.transitions.easing.Regular.easeOut;
						break;
					}
					//Get duration - 2 as default
					var duration : Number = Number (Utils.getFirstValue (animationStyles [i].duration, 2));
					//If the user has scheduled a wait, we create a tween function
					//to wait for the specified period.
					if (animationStyles [i].wait != undefined && animationStyles [i].wait != null && (Number (animationStyles [i].wait) > 0))
					{
						//Create a tween with no change in the parameter for the waiting period
						tweens [i] = new Tween (mc, animationStyles [i].param, easingFunction, start, start, Number (animationStyles [i].wait) , true);
						//Store the values in local variables so that they'll be
						//accessible inside onMotionFinished event handler function
						tweens [i].onMotionFinished = function ()
						{
							//Since the waiting period is now over, we can
							//change the visual property
							this.continueTo (end, duration);
							//Delete the event handler
							delete this.onMotionFinished;
						};
					} else 
					{
						//Just define a normal tween
						tweens [i] = new Tween (mc, animationStyles [i].param, easingFunction, start, end, duration, true);
					}
				}
			}
			//Delete tweens array
			delete tweens;
		}
	}
	/**
	* applyFilters method applies the filter effect to the given movie clip
	* from the style repository, based on the numeric id of the chart
	* object which is being represented by this movie clip
	*	@param	mc			Movie clip to which we've to apply filter
	*	@param	chartObject	The numeric id of chart object which is being
	*						represented by this movie clip
	*	@param	arrNotApply	Array containing ids of filter types not to apply.
	*						Specifically useful when you do not want to apply a particular
	*						filter type.
	*/
	public function applyFilters (mc : MovieClip, chartObject : Number, arrNotApply : Array) : Void 
	{
		//First up, we need to get a list of filters defined for this chart object.
		//Get the list of styles applicable for this object
		var objStyles : Array = new Array ();
		objStyles = this.objectStyle [chartObject];
		var i : Number;
		//First get all filter style objects for this chart object
		var filterStyles : Array = mc.filters;
		//Also, create an array to store the filter objects for mc
		//If the mc already has few filters applied, get it.
		var mcFilters : Array = mc.filters;
		//If it's empty, create a new array
		if (mcFilters.length == 0 || mcFilters == undefined)
		{
			mcFilters = new Array ();
		}
		for (i = 0; i < objStyles.length; i ++)
		{
			//If it's a filter style, push the style object in filterStyles
			if ((this.styleType [objStyles [i]] == this.TYPE.SHADOW) || (this.styleType [objStyles [i]] == this.TYPE.BLUR) || (this.styleType [objStyles [i]] == this.TYPE.GLOW) || (this.styleType [objStyles [i]] == this.TYPE.BEVEL))
			{
				//Now if this filter style is present in arrNotApply, we do not push it to our array
				//By default assume that it's not present.
				var presentInNotApply : Boolean = false;
				for (var j = 0; j < arrNotApply.length; j ++)
				{
					if (arrNotApply [j] == this.styleType [objStyles [i]])
					{
						presentInNotApply = true;
						break;
					}
				}
				//If the style is not in the list of "Not apply" we add it to our array to apply.
				if (presentInNotApply == false)
				{
					filterStyles.push (this.styles.get (objStyles [i]));
				}
			}
		}
		var shadowFilter : DropShadowFilter;
		var blFilter : BlurFilter;
		var glFilter : GlowFilter;
		var bvFilter : BevelFilter;
		//Now, apply the filters
		if (filterStyles.length > 0)
		{
			var filters : Array = new Array ();
			for (i = 0; i < filterStyles.length; i ++)
			{
				//Create filter objects based on filter type
				switch (filterStyles [i].type)
				{
					case this.TYPE.SHADOW :
					//It's a shadow filter
					/**
					* Properties for the DropShadowFilter filter which the user
					* can specify
					* distance: The offset distance for the shadow, in pixels.
					*			The default value is 2 (floating point).
					* angle:	The angle of the shadow. Valid values are 0 to
					*			360˚ (floating point). The default value is 210.
					* color:	The color of the shadow. Valid values are in hexadecimal
					*			format RRGGBB. The default value is 666666.
					* alpha:	The alpha transparency value for the shadow color.
					*			Valid values are 0 to 1. For example, .25 sets a
					*			transparency value of 25%. The default value is .6.
					* blurX:	The amount of horizontal blur. Valid values are 0 to
					*			255 (floating point). The default value is 4. Values
					*			that are a power of 2 (such as 2, 4, 8, 16 and 32) are
					*			optimized to render more quickly than other values.
					* blurY:	The amount of vertical blur. Valid values are 0 to
					*			255 (floating point). The default value is 4. Values
					*			that are a power of 2 (such as 2, 4, 8, 16 and 32) are
					*			optimized to render more quickly than other values.
					* strength:The strength of the imprint or spread. The higher the
					*			value, the more color is imprinted and the stronger the
					*			contrast between the shadow and the background. Valid
					*			values are from 0 to 255. The default is 1.
					* quality:	The number of times to apply the filter. Valid values are
					*			0 to 15. The default value is 1, which is equivalent to low
					*			quality. A value of 2 is medium quality, and a value of 3 is
					*			high quality. Filters with lower values are rendered quicker.
					*/
					//Retrieve the properties from style object and set defaults
					var distance : Number = Number (Utils.getFirstValue (filterStyles [i].distance, 2));
					var angle : Number = Number (Utils.getFirstValue (filterStyles [i].angle, 210));
					var color : String = StyleObject.checkHexColor (Utils.getFirstValue (filterStyles [i].color, "666666"));
					var alpha : Number = Number (Utils.getFirstValue (filterStyles [i].alpha, 60));
					//Convert alpha to range 0-1
					alpha = alpha / 100;
					var blurX : Number = Number (Utils.getFirstValue (filterStyles [i].blurx, 4));
					var blurY : Number = Number (Utils.getFirstValue (filterStyles [i].blury, 4));
					var strength : Number = Number (Utils.getFirstValue (filterStyles [i].strength, 1));
					var quality : Number = Number (Utils.getFirstValue (filterStyles [i].quality, 1));
					//Create shadow object and set it's properties
					shadowFilter = new DropShadowFilter (distance, angle, parseInt (color, 16) , alpha, blurX, blurY, strength, quality, false, false, false);
					//Add the filter style to mcFilters array
					mcFilters.push (shadowFilter);
					break;
					case this.TYPE.BLUR :
					//It's a blur filter
					/**
					* Properties for the BlurFilter filter which the user
					* can specify
					* blurX: 	The amount to blur horizontally. Valid values are
					*			from 0 to 255 (floating-point value). The default value
					*			is 4. Values that are a power of 2 (such as 2, 4, 8, 16
					*			and 32) are optimized to render quicker than other values.
					* blurY: 	The amount to blur vertically.
					* quality:	The number of times to apply the filter. The default value
					*			is 1, which is equivalent to low quality. A value of 2 is
					*			medium quality, and a value of 3 is high quality and
					*			approximates a Gaussian blur.
					*/
					var blurX : Number = Number (Utils.getFirstValue (filterStyles [i].blurx, 4));
					var blurY : Number = Number (Utils.getFirstValue (filterStyles [i].blury, 4));
					var quality : Number = Number (Utils.getFirstValue (filterStyles [i].quality, 1));
					//Create the filter
					blFilter = new BlurFilter (blurX, blurY, quality);
					//Add the filter style to mcFilters array
					mcFilters.push (blFilter);
					break;
					case this.TYPE.GLOW :
					//It's a GlowFilter.
					/**
					* Properties for the GlowFilter filter which the user
					* can specify
					* blurX:	The amount of horizontal blur. Valid values are 0 to
					*			255 (floating point). The default value is 8. Values
					*			that are a power of 2 (such as 2, 4, 8, 16 and 32) are
					*			optimized to render more quickly than other values.
					* blurY:	The amount of vertical blur. Valid values are 0 to
					*			255 (floating point). The default value is 8. Values
					*			that are a power of 2 (such as 2, 4, 8, 16 and 32) are
					*			optimized to render more quickly than other values.
					* strength:The strength of the imprint or spread. The higher the
					*			value, the more color is imprinted and the stronger the
					*			contrast between the glow and the background. Valid values
					*			are 0 to 255. The default is 2.
					* quality:	The number of times to apply the filter. Valid values are
					*			0 to 15. The default value is 1, which is equivalent to low
					*			quality. A value of 2 is medium quality, and a value of 3 is
					*			high quality. Filters with lower values are rendered quicker.
					* alpha:	The alpha transparency value for the shadow color.
					*			Valid values are 0 to 1. For example, .25 sets a
					*			transparency value of 25%. The default value is 1.
					* color:	The color of the glow. Valid values are in the hexadecimal
					*			format RRGGBB. The default value is FF0000.
					*/
					//Retrieve the properties from style object and set defaults
					var color : String = StyleObject.checkHexColor (Utils.getFirstValue (filterStyles [i].color, "FF0000"));
					var alpha : Number = Number (Utils.getFirstValue (filterStyles [i].alpha, 100));
					//Convert alpha to range 0-1
					alpha = alpha / 100;
					var blurX : Number = Number (Utils.getFirstValue (filterStyles [i].blurx, 8));
					var blurY : Number = Number (Utils.getFirstValue (filterStyles [i].blury, 8));
					var strength : Number = Number (Utils.getFirstValue (filterStyles [i].strength, 2));
					var quality : Number = Number (Utils.getFirstValue (filterStyles [i].quality, 1));
					//Create shadow object and set it's properties
					glFilter = new GlowFilter (parseInt (color, 16) , alpha, blurX, blurY, strength, quality, false, false);
					//Add the filter style to mcFilters array
					mcFilters.push (glFilter);
					break;
					case this.TYPE.BEVEL :
					//It's a bevel filter.
					/*
					* blurX:		The amount of horizontal blur in pixels. Valid values are from
					* 				0 to 255 (floating point). The default value is 4. Values that
					*				are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to
					*				render more quickly than other values.
					* blurY:		The amount of vertical blur in pixels. Valid values are from
					* 				0 to 255 (floating point). The default value is 4. Values that
					*				are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to
					*				render more quickly than other values.
					* angle:		The angle of the bevel. Valid values are from 0 to 360 degrees.
					*				The default value is 45.
					* distance:	The offset distance of the bevel. Valid values are in pixels
					*				(floating point). The default value is 4.
					* strength:	The strength of the imprint or spread. Valid values are from 0
					*				to 255. The larger the value, the more color is imprinted and
					*				the stronger the contrast between the bevel and the background.
					*				The default value is 1.
					* quality:		The number of times to apply the filter. The default value is 1,
					*				which is equivalent to low quality. A value of 2 is medium quality,
					*				and a value of 3 is high quality. Filters with lower values are
					*				rendered more quickly.
					* shadowAlpha:	The alpha transparency value of the shadow color. This value is
					*				specified as a normalized value from 0 to 1. For example, .25
					*				sets a transparency value of 25%. The default value is 0.5.
					* shadowColor:	The shadow color of the bevel. Valid values are in hexadecimal
					*				format, RRGGBB. The default value is 000000.
					* highlightAlpha:	The alpha transparency value of the highlight color. The
					*					value is specified as a normalized value from 0 to 1. For
					*					example, .25 sets a transparency value of 25%. The default
					*					value is 0.5.
					* highlightColor:	The highlight color of the bevel. Valid values are in
					*					hexadecimal format, RRGGBB. The default value is FFFFFF
					*/
					//Retrieve the properties from style object and set defaults
					var distance : Number = Number (Utils.getFirstValue (filterStyles [i].distance, 4));
					var angle : Number = Number (Utils.getFirstValue (filterStyles [i].angle, 45));
					var shadowColor : String = StyleObject.checkHexColor (Utils.getFirstValue (filterStyles [i].shadowcolor, "000000"));
					var shadowAlpha : Number = Number (Utils.getFirstValue (filterStyles [i].shadowalpha, 50));
					//Convert alpha to range 0-1
					shadowAlpha = shadowAlpha / 100;
					var highlightColor : String = StyleObject.checkHexColor (Utils.getFirstValue (filterStyles [i].highlightColor, "FFFFFF"));
					var highlightAlpha : Number = Number (Utils.getFirstValue (filterStyles [i].highlightAlpha, 50));
					//Convert alpha to range 0-1
					highlightAlpha = highlightAlpha / 100;
					var blurX : Number = Number (Utils.getFirstValue (filterStyles [i].blurx, 4));
					var blurY : Number = Number (Utils.getFirstValue (filterStyles [i].blury, 4));
					var strength : Number = Number (Utils.getFirstValue (filterStyles [i].strength, 1));
					var quality : Number = Number (Utils.getFirstValue (filterStyles [i].quality, 1));
					bvFilter = new BevelFilter (distance, angle, parseInt (highlightColor, 16) , highlightAlpha, parseInt (shadowColor, 16) , shadowAlpha, blurX, blurY, strength, quality, "inner", false);
					//Add the filter style to mcFilters array
					mcFilters.push (bvFilter);
					break;
				}
			}
			//Apply the filters to the movie clip
			mc.filters = mcFilters;
			//Delete filters array finally
			delete filters;
		}
	}
}
