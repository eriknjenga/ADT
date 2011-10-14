 /**
* DualYAxisChart chart extends the Chart class to render the generic
* template for chart with double axes.
* DualYAxis Charts have two axis - primary and secondary. Normally they
* are used to plot two inter-related quantities - like revenue & profit,
* revenue & quantity etc. The focus is maintained on primary axis and the
* secondary axis serves as trend indicator based on primary (axis) data.
*
* Fundamentals - Both primary and secondary axis can have their independent
* scales and upper/lower limits.
* Div lines are adjusted against primary axis. Secondary axis limits are
* adjusted as per div lines.
* Decimal and number formatting for each axis and related dataset can be
* different allowing for better flexibility in presentation.
* There can be data only for either primary axis or secondary axis without
* giving any errors. We'll just draw empty axis for which we don't have data.
*/
//Import parent Chart class
import com.fusioncharts.core.Chart;
import com.fusioncharts.helper.Utils;
import com.fusioncharts.helper.Logger;
import com.fusioncharts.extensions.DrawingExt;
import com.fusioncharts.extensions.ColorExt;
import com.fusioncharts.extensions.MathExt;
import mx.transitions.Tween;
class com.fusioncharts.core.DualYAxisChart extends Chart 
{
	//Version number (if different from super Chart class)
	//private var _version:String = "3.0.0";
	//Instance variables
	//Storage for div lines
	private var divLines : Array;
	private var sDivLines : Array;
	//Axis charts can have trend lines. trendLines array
	//stores the trend lines for an axis chart.
	private var trendLines : Array;
	//numTrendLines stores the number of trend lines
	private var numTrendLines : Number = 0;
	//Number of trend lines below
	private var numTrendLinesBelow : Number = 0;
	//Axis charts can have vertical lines dividing the x-axis
	//labels. Container to store those vLines.
	private var vLines : Array;
	//Number of vertical lines
	private var numVLines : Number = 0;
	/**
	* Constructor function. We invoke the super class'
	* constructor.
	*/
	function DualYAxisChart (targetMC : MovieClip, depth : Number, width : Number, height : Number, x : Number, y : Number, debugMode : Boolean, lang : String, scaleMode:String, registerWithJS:Boolean, DOMId:String)
	{
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
		//Initialize div lines array
		//Primary div lines
		this.divLines = new Array ();
		//Secondary div lines
		this.sDivLines = new Array ();
		//Initialize the trendlines array
		this.trendLines = new Array ();
		//Initialize vertical lines container
		this.vLines = new Array ();
	}
	/**
	* OVER-RIDING Chart Class's detectNumberScales method.
	* detectNumberScales method detects whether we've been provided
	* with number scales. If yes, we parse them. This method needs to
	* called before calculatePoints, as calculatePoint methods calls
	* formatNumber, which in turn uses number scales.
	* Here, we also adjust the numberPrefix and numberSuffix if they're
	* still present in encoded form. Like, if the user has specified encoded
	* numberPrefix and Suffix in dataURL mode, it will show the direct value.
	* Therefore, we need to change them into proper characters.
	*	@return	Nothing.
	*/
	private function detectNumberScales () : Void
	{
		var i : Number;
		//We set this.config.numberScaleDefined to true. The condition satisfies
		//every time. But, we keep formatNumberScale (Primary and secondary) to reflect
		//actual value, and we'll pass that only to formatNumber function - as flag to
		//whether to format number scale or not for that value.
		this.config.numberScaleDefined = true;
		//Check if either has been defined
		if ( ! (this.params.numberScaleValue.length == 0 || this.params.numberScaleUnit.length == 0 || this.params.formatNumberScale == false))
		{
			//Set flag to true
			this.params.formatNumberScale = true;
			//Split the data into arrays
			this.config.nsv = new Array ();
			this.config.nsu = new Array ();
			//Parse the number scale value
			this.config.nsv = this.params.numberScaleValue.split (",");
			//Convert all number scale values to numbers as they're
			//currently in string format.
			for (i = 0; i < this.config.nsv.length; i ++)
			{
				this.config.nsv [i] = Number (this.config.nsv [i]);
				//If any of numbers are NaN, set defined to false
				if (isNaN (this.config.nsv [i]))
				{
					this.params.formatNumberScale = false;
				}
			}
			//Parse the number scale unit
			this.config.nsu = this.params.numberScaleUnit.split (",");
			//If the length of two arrays do not match, set defined to false.
			if (this.config.nsu.length != this.config.nsv.length)
			{
				this.params.formatNumberScale = false;
			}
		}
		//Do the same for secondary axis
		if ( ! (this.params.sNumberScaleValue.length == 0 || this.params.sNumberScaleUnit.length == 0 || this.params.sFormatNumberScale == false))
		{
			//Set flag to true
			this.params.sFormatNumberScale = true;
			//Split the data into arrays
			this.config.snsv = new Array ();
			this.config.snsu = new Array ();
			//Parse the number scale value
			this.config.snsv = this.params.sNumberScaleValue.split (",");
			//Convert all number scale values to numbers as they're
			//currently in string format.
			for (i = 0; i < this.config.snsv.length; i ++)
			{
				this.config.snsv [i] = Number (this.config.snsv [i]);
				//If any of numbers are NaN, set defined to false
				if (isNaN (this.config.snsv [i]))
				{
					this.params.sFormatNumberScale = false;
				}
			}
			//Parse the number scale unit
			this.config.snsu = this.params.sNumberScaleUnit.split (",");
			//If the length of two arrays do not match, set defined to false.
			if (this.config.snsu.length != this.config.snsv.length)
			{
				this.params.sFormatNumberScale = false;
			}
		}
		//Convert numberPrefix and numberSuffix now.
		this.params.numberPrefix = this.unescapeChar (this.params.numberPrefix);
		this.params.numberSuffix = this.unescapeChar (this.params.numberSuffix);
		this.params.sNumberPrefix = this.unescapeChar (this.params.sNumberPrefix);
		this.params.sNumberSuffix = this.unescapeChar (this.params.sNumberSuffix);
		//Always keep to a decimal precision of minimum 2 if the number
		//scale is defined, as we've just checked for decimal precision of numbers
		//and not the numbers against number scale. So, even if they do not need yield a
		//decimal, we keep 2, as we do not force decimals on numbers.
		if (this.params.formatNumberScale == true || this.params.sFormatNumberScale == true)
		{
			maxDecimals = (maxDecimals > 2) ?maxDecimals : 2;
		}
		//Get proper value for decimals
		this.params.decimals = Number (getFV (this.params.decimals, maxDecimals));
		this.params.sDecimals = Number (getFV (this.params.sDecimals, maxDecimals));
		//Decimal Precision cannot be less than 0 - so adjust it
		if (this.params.decimals < 0)
		{
			this.params.decimals = 0;
		}
		if (this.params.sDecimals < 0)
		{
			this.params.sDecimals = 0;
		}
	}
	/**
	* FOLLOWING FUNCTION HAD TO BE REPLICATED FROM Chart CLASS EVEN THOUGH
	* THIS CLASS EXTENDS THE CHART CLASS. DUE TO ERRONEOUS BEHAVIOUR IN
	* FLASH PLAYER, IF WE REFER TO SUPER CLASS'S METHOD, IT'S RETURNING AN
	* UNDEFINED VALUE - WHEN EVERYTHING IS OK. AS SOON AS WE COPY-PASTE THE
	* METHOD HERE, IT SEEMS TO BE WORKING FINE.
	* EVEN WORSE: WHEN SUPER METHOD IS USED AND THE MOVIE IS RUN IN STAND ALONE
	* FLASH PLAYER (8), IT WORKS ABSOLUTELY FINE. BUT WHEN IT'S RUN IN BROWSER
	* (FLASH 9), IT STARTS GIVING WEIRD RESULTS.
	
	* unescapeChar method helps to unescape certain escape characters
	* which might have got through the XML. Like, %25 is escaped back to %.
	* This function would be used to format the number prefixes and suffixes.
	*	@param	strChar		The character or character sequence to be unescaped.
	*	@return			The unescaped character
	*/
	private function unescapeChar (strChar : String) : String
	{
		//Perform only if strChar is defined
		if (strChar == "" || strChar == undefined)
		{
			return "";
		}
		//If it doesnt contain a %, return the original string
		if (strChar.indexOf ("%") == - 1)
		{
			return strChar;
		}
		//We're not doing a case insensitive search, as there might be other
		//characters provided in the Prefix/Suffix, which need to be present in lowe case.
		//Create the conversion table.
		var cTable : Array = new Array ();
		cTable.push (
		{
			char : "%", encoding : "%25"
		});
		cTable.push (
		{
			char : "&", encoding : "%26"
		});
		cTable.push (
		{
			char : "£", encoding : "%A3"
		});
		cTable.push (
		{
			char : "€", encoding : "%E2%82%AC"
		});
		//v2.3 Backward compatible Euro
		cTable.push (
		{
			char : "€", encoding : "%80"
		});
		cTable.push (
		{
			char : "¥", encoding : "%A5"
		});
		cTable.push (
		{
			char : "¢", encoding : "%A2"
		});
		cTable.push (
		{
			char : "₣", encoding : "%E2%82%A3"
		});
		cTable.push (
		{
			char : "+", encoding : "%2B"
		});
		cTable.push (
		{
			char : "#", encoding : "%23"
		});
		//Loop variable
		var i : Number;
		//Return string (escaped)
		var rtnStr : String = strChar;
		for (i = 0; i < cTable.length; i ++)
		{
			if (strChar == cTable [i].encoding)
			{
				//If the given character matches the encoding, convert to character
				rtnStr = cTable [i].char;
				break;
			}
		}
		//Return it
		return rtnStr;
		//Clean up
		delete cTable;
	}
	/**
	* getPAxisLimits method helps calculate the primary axis limits based
	* on the given maximum and minimum value.
	* @param	maxValue		Maximum numerical value present in data
	*	@param	minValue		Minimum numerical value present in data
	*	@param	setMinAsZero	Whether to set the lower limit as 0 or a greater
	*							appropriate value (when dealing with positive numbers)
	*/
	private function getPAxisLimits (maxValue : Number, minValue : Number, setMinAsZero : Boolean) : Void 
	{
		//First check if both maxValue and minValue are proper numbers.
		//Else, set defaults as 0.1,0
		maxValue = (isNaN (maxValue) == true || maxValue == undefined) ? 0.1 : maxValue;
		minValue = (isNaN (minValue) == true || minValue == undefined) ? 0 : minValue;
		//Or, if only 0 data is supplied
		if ((maxValue == minValue) && (maxValue == 0))
		{
			maxValue = 0.1;
		}
		//Default for setMinAsZero
		setMinAsZero = Utils.getFirstValue (setMinAsZero, true);
		//Get the maximum power of 10 that is applicable to maxvalue
		//The Number = 10 to the power maxPowerOfTen + x (where x is another number)
		//For e.g., in 99 the maxPowerOfTen will be 1 = 10^1 + 89
		//And for 102, it will be 2 = 10^2 + 2
		var maxPowerOfTen : Number = Math.floor (Math.log (Math.abs (maxValue)) / Math.LN10);
		//Get the minimum power of 10 that is applicable to maxvalue
		var minPowerOfTen : Number = Math.floor (Math.log (Math.abs (minValue)) / Math.LN10);
		//Find which powerOfTen (the max power or the min power) is bigger
		//It is this which will be multiplied to get the y-interval
		var powerOfTen : Number = Math.max (minPowerOfTen, maxPowerOfTen);
		var y_interval : Number = Math.pow (10, powerOfTen);
		//For accomodating smaller range values (so that scale doesn't represent too large an interval
		if (Math.abs (maxValue) / y_interval < 2 && Math.abs (minValue) / y_interval < 2)
		{
			powerOfTen --;
			y_interval = Math.pow (10, powerOfTen);
		}
		//If the y_interval of min and max is way more than that of range.
		//We need to reset the y-interval as per range
		var rangePowerOfTen : Number = Math.floor (Math.log (maxValue - minValue) / Math.LN10);
		var rangeInterval : Number = Math.pow (10, rangePowerOfTen);
		//Now, if rangeInterval is 10 times less than y_interval, we need to re-set
		//the limits, as the range is too less to adjust the axis for max,min.
		//We do this only if range is greater than 0 (in case of 1 data on chart).
		if (((maxValue - minValue) > 0) && ((y_interval / rangeInterval) >= 10))
		{
			y_interval = rangeInterval;
			powerOfTen = rangePowerOfTen;
		}
		//Calculate the y-axis upper limit
		var y_topBound : Number = (Math.floor (maxValue / y_interval) + 1) * y_interval;
		//Calculate the y-axis lower limit
		var y_lowerBound : Number;
		//If the min value is less than 0
		if (minValue < 0)
		{
			//Then calculate by multiplying negative numbers with y-axis interval
			y_lowerBound = - 1 * ((Math.floor (Math.abs (minValue / y_interval)) + 1) * y_interval);
		} else 
		{
			//Else, simply set it to 0.
			if (setMinAsZero)
			{
				y_lowerBound = 0;
			} else 
			{
				y_lowerBound = Math.floor (Math.abs (minValue / y_interval) - 1) * y_interval;
				//Now, if minValue>=0, we keep x_lowerBound to 0 - as for values like minValue 2
				//lower bound goes negative, which is not required.
				y_lowerBound = (y_lowerBound < 0) ?0 : y_lowerBound;
			}
		}
		//Now, we need to make a check as to whether the user has provided an upper limit
		//and lower limit.
		if (this.params.PYAxisMaxValue == null || this.params.PYAxisMaxValue == undefined || this.params.PYAxisMaxValue == "" || Number (this.params.PYAxisMaxValue) == NaN)
		{
			this.config.PYMaxGiven = false;
		} else 
		{
			this.config.PYMaxGiven = true;
		}
		if (this.params.PYAxisMinValue == null || this.params.PYAxisMinValue == undefined || this.params.PYAxisMinValue == "" || Number (this.params.PYAxisMinValue) == NaN)
		{
			this.config.PYMinGiven = false;
		} else 
		{
			this.config.PYMinGiven = true;
		}
		//If he has provided it and it is valid, we leave it as the upper limit
		//Else, we enforced the value calculate by us as the upper limit.
		if (this.config.PYMaxGiven == false || (this.config.PYMaxGiven == true && Number (this.params.PYAxisMaxValue) < maxValue))
		{
			this.config.PYMax = y_topBound;
		} else 
		{
			this.config.PYMax = Number (this.params.PYAxisMaxValue);
		}
		//Now, we do the same for y-axis lower limit
		if (this.config.PYMinGiven == false || (this.config.PYMinGiven == true && Number (this.params.PYAxisMinValue) > minValue))
		{
			this.config.PYMin = y_lowerBound;
		} else 
		{
			this.config.PYMin = Number (this.params.PYAxisMinValue);
		}
		//Store axis range
		this.config.PRange = Math.abs (this.config.PYMax - this.config.PYMin);
		//Store interval
		this.config.PInterval = y_interval;
	}
	/**
	* getSAxisLimits method helps calculate the secondary axis limits based
	* on the given maximum and minimum value.
	* @param	maxValue		Maximum numerical value present in data
	*	@param	minValue		Minimum numerical value present in data
	*	@param	setMinAsZero	Whether to set the lower limit as 0 or a greater
	*							appropriate value (when dealing with positive numbers)
	*/
	private function getSAxisLimits (maxValue : Number, minValue : Number, setMinAsZero : Boolean) : Void 
	{
		//First check if both maxValue and minValue are proper numbers.
		//Else, set defaults as 0.1,0
		maxValue = (isNaN (maxValue) == true || maxValue == undefined) ? 0.1 : maxValue;
		minValue = (isNaN (minValue) == true || minValue == undefined) ? 0 : minValue;
		//Or, if only 0 data is supplied
		if ((maxValue == minValue) && (maxValue == 0))
		{
			maxValue = 0.1;
		}
		//Default for setMinAsZero
		setMinAsZero = Utils.getFirstValue (setMinAsZero, true);
		//Get the maximum power of 10 that is applicable to maxvalue
		//The Number = 10 to the power maxPowerOfTen + x (where x is another number)
		//For e.g., in 99 the maxPowerOfTen will be 1 = 10^1 + 89
		//And for 102, it will be 2 = 10^2 + 2
		var maxPowerOfTen : Number = Math.floor (Math.log (Math.abs (maxValue)) / Math.LN10);
		//Get the minimum power of 10 that is applicable to maxvalue
		var minPowerOfTen : Number = Math.floor (Math.log (Math.abs (minValue)) / Math.LN10);
		//Find which powerOfTen (the max power or the min power) is bigger
		//It is this which will be multiplied to get the y-interval
		var powerOfTen : Number = Math.max (minPowerOfTen, maxPowerOfTen);
		var y_interval : Number = Math.pow (10, powerOfTen);
		//For accomodating smaller range values (so that scale doesn't represent too large an interval
		if (Math.abs (maxValue) / y_interval < 2 && Math.abs (minValue) / y_interval < 2)
		{
			powerOfTen --;
			y_interval = Math.pow (10, powerOfTen);
		}
		//If the y_interval of min and max is way more than that of range.
		//We need to reset the y-interval as per range
		var rangePowerOfTen : Number = Math.floor (Math.log (maxValue - minValue) / Math.LN10);
		var rangeInterval : Number = Math.pow (10, rangePowerOfTen);
		//Now, if rangeInterval is 10 times less than y_interval, we need to re-set
		//the limits, as the range is too less to adjust the axis for max,min.
		//We do this only if range is greater than 0 (in case of 1 data on chart).
		if (((maxValue - minValue) > 0) && ((y_interval / rangeInterval) >= 10))
		{
			y_interval = rangeInterval;
			powerOfTen = rangePowerOfTen;
		}
		//Calculate the y-axis upper limit
		var y_topBound : Number = (Math.floor (maxValue / y_interval) + 1) * y_interval;
		//Calculate the y-axis lower limit
		var y_lowerBound : Number;
		//If the min value is less than 0
		if (minValue < 0)
		{
			//Then calculate by multiplying negative numbers with y-axis interval
			y_lowerBound = - 1 * ((Math.floor (Math.abs (minValue / y_interval)) + 1) * y_interval);
		} else 
		{
			//Else, simply set it to 0.
			if (setMinAsZero)
			{
				y_lowerBound = 0;
			} else 
			{
				y_lowerBound = Math.floor (Math.abs (minValue / y_interval) - 1) * y_interval;
				//Now, if minValue>=0, we keep x_lowerBound to 0 - as for values like minValue 2
				//lower bound goes negative, which is not required.
				y_lowerBound = (y_lowerBound < 0) ?0 : y_lowerBound;
			}
		}
		//Now, we need to make a check as to whether the user has provided an upper limit
		//and lower limit.
		if (this.params.SYAxisMaxValue == null || this.params.SYAxisMaxValue == undefined || this.params.SYAxisMaxValue == "" || Number (this.params.SYAxisMaxValue) == NaN)
		{
			this.config.SYMaxGiven = false;
		} else 
		{
			this.config.SYMaxGiven = true;
		}
		if (this.params.SYAxisMinValue == null || this.params.SYAxisMinValue == undefined || this.params.SYAxisMinValue == "" || Number (this.params.SYAxisMinValue) == NaN)
		{
			this.config.SYMinGiven = false;
		} else 
		{
			this.config.SYMinGiven = true;
		}
		//If he has provided it and it is valid, we leave it as the upper limit
		//Else, we enforced the value calculate by us as the upper limit.
		if (this.config.SYMaxGiven == false || (this.config.SYMaxGiven == true && Number (this.params.SYAxisMaxValue) < maxValue))
		{
			this.config.SYMax = y_topBound;
		} else 
		{
			this.config.SYMax = Number (this.params.SYAxisMaxValue);
		}
		//Now, we do the same for y-axis lower limit
		if (this.config.SYMinGiven == false || (this.config.SYMinGiven == true && Number (this.params.SYAxisMinValue) > minValue))
		{
			this.config.SYMin = y_lowerBound;
		} else 
		{
			this.config.SYMin = Number (this.params.SYAxisMinValue);
		}
		//Store axis range
		this.config.SRange = Math.abs (this.config.SYMax - this.config.SYMin);
		//Store interval
		this.config.SInterval = y_interval;
	}
	/**
	* calcDivs method calculates the best div line interval for the given/calculated
	* yMin, yMax, specified numDivLines and adjustDiv.
	* In this function whenever we refer to yMin, yMax, we're referring to PYMin and PYMax,
	* unless otherwise specified.
	* We re-set the PRIMARY y axis min and max value, if both were calculated by our
	* us, so that we get a best value according to numDivLines. The idea is to have equal
	* intervals on the axis, based on numDivLines specified. We do so, only if both yMin and
	* yMax have been calculated as per our values. Else, we adjust the numDiv Lines.
	*/
	private function calcDivs () : Void 
	{
		/**
		* There can be four cases of Primary yMin, yMax.
		* 1. User doesn't specify either. (our program calculates it).
		* 2. User specifies both in XML. (which our program still validates)
		* 3. User specifies only yMin. (we provide missing data)
		* 4. User specifies only yMax. (we provide missing data)
		*
		* Apart from this, the user can specify numDivLines (which if not specified takes a
		* default value of 4). Also, the user can specify adjustDiv (which can be 1 or 0).
		* adjustDiv works in all four cases (1,2,3,4).
		* Case 1 is modified to occur as under now: User doesn't specify either yMin or yMax
		* and adjustDiv is set to true (by default). If the user doesn't specify either yMin or
		* yMax, but adjustDiv is set to false, it doesn't appear as Case 1. However, if adjustDiv
		* is set to true and yMin,yMax is automatically calculated by FusionCharts, we adjust the
		* calculated yMin,yMax so that the given number of div lines can be well adjusted within.
		*
		* In case 2,3,4, we adjust numDivLines so that they space up equally based on the interval
		* and decimals required.
		*
		* So, the difference between Case 1 and Case 2,3,4 is that in Case 1, we adjust limits
		* to accomodate specified number of div lines. In Case 2,3,4, we adjust numDivLines to
		* accomodate within the given limits (y-axis range).
		*
		* numDivLines is always our primary focus when calculating them in all cases. In Case 1,
		* it's kept constant as center of calculation. In Case 2, it's modified to get a best
		* value.
		*
		* Now, for case 1, we can have three sub cases:
		* 1.1. yMax, yMin >=0
		* 1.2. yMin, yMax <=0
		* 1.3. yMax > 0 and yMin <0.
		* Case 1.1 and 1.2 are simple, as we just need to adjust the range between two positive
		* or two negative numbers such that the range can be equally divided into (numDivLines+1)
		* division.
		* Case 1.3 is tricky, as here, we additionally need to make sure that 0 plane is included
		* as a division.
		* We use two different methods to solved Case 1.1,1.2 and Case 1.3.
		* Note that in all Cases (1.1, 1.2 & 1.3), we adjust the auto-calculated yMax and yMin
		* to get best div line value. We do NOT adjust numDivLines here.
		*/
		//Check condition for case 1 first - limits not specified and adjustDiv is true
		if (this.config.PYMinGiven == false && this.config.PYMaxGiven == false && this.params.adjustDiv == true)
		{
			//Means neither chart max value nor min value has been specified and adjustDiv is true
			//Set flag that we do not have to format div (y-axis values) decimals
			this.config.formatPDivDecimals = false;
			//Now, if it's case 1.3 (yMax > 0 & yMin <0)
			if (this.config.PYMax > 0 && this.config.PYMin < 0)
			{
				//Case 1.3
				/**
				* Here, in this case, we start by generating the best fit range
				* for the given yMin, yMax, numDivLines and interval. We generate
				* range by adding sequential increments (rangeDiv * (ND+1) * interval).
				* Interval has been adjusted to smaller interval for larger values.
				* Now, for each divisible range generated by the program, we adjust the
				* yMin and yMax to check if 0 can land as a division in between them on
				* a proper distance.
				* We divide the y-axis range into two parts - small arm and big arm.
				* Say y-axis range is from 1 to -5. So, small arm is 1 and big arm is -5.
				* Or, if its from 16 to -3, small arm is -3 and big arm is 16.
				* Now, we try and get a value for extended small arm, which is multiple
				* of rangeDiv. Say chart min,max is 16,-3. So range becomes 19.
				* Let's assume numDivLines to be 2. So for 2 numDivLines, we get closest
				* adjusted range value as 21. Delta range = 21 - 19 (original range) = 2
				* Also, range division value = 21 / (ND + 1) = 21 / 3 = 7
				* We now get values for extended small arm as i*range division, where i
				* runs from 1 to (numDivLines+1)/2. We go only halfway as it's the smaller
				* arm and so cannot extend to a division beyond half way - else it would have
				* been the bigger arm.
				* So, first extended small arm = -7 * 1 = -7.
				* We get the difference between extended small arm and original small arm.
				* In this case it's 7 - 3 = 4 (all absolute values now - to avoid sign disparities).
				* We see that delta arm > delta range. So, we ignore this range and get a new range.
				* So, next range comes as = prev Range (21) + (numDivLines + 1)*interval
				* = 21 + (2+1)*1 = 24
				* Since the increment is sequential as a multiplication factor of
				* (numDivLines + 1)*interval, it is also a valid divisible range.
				* So we again check whether 0 can appear as a division. In this case, we
				* get rangeDiv as 8 and extended smaller arm as 8. For this extended smaller
				* arm, we get bigger arm as 16. Both of these are divisible by rangeDiv. That
				* means, this range can include 0 as division line. So, we store it and proceed.
				*/
				//Flag to indicate whether we've found the perfect range or not.
				var found : Boolean = false;
				//We re-calculate the interval to get smaller increments for large values.
				//For example, for 300 to -100 (with ND as 2), if we do not adjust interval, the min
				//max come as -200, 400. But with adjusted intervals, it comes as -150, 300, which is
				//more appropriate.
				var adjInterval = (this.config.PInterval > 10) ? (this.config.PInterval / 10) : this.config.PInterval;
				//Get the first divisible range for the given yMin, yMax, numDivLines and interval.
				//We do not intercept and adjust interval for this calculation here.
				var range : Number = getDivisibleRange (this.config.PYMin, this.config.PYMax, this.params.numDivLines, adjInterval, false);
				//Now, deduct delta range from nextRange initially, so that in while loop,
				//there's a unified statement for increment instead of 2 checks.
				var nextRange : Number = range - (this.params.numDivLines + 1) * (adjInterval);
				//Range division
				var rangeDiv : Number;
				//Delta in range
				var deltaRange : Number;
				//Multiplication factor
				var mf : Number;
				//Smaller and bigger arm of y-axis
				var smallArm : Number, bigArm : Number;
				//Exntended small and big arm
				var extSmallArm : Number, extBigArm : Number;
				//Loop variable
				var i : Number;
				//Now, we need to search for a range which is divisible in (this.params.numDivLines+1)
				//segments including 0. Run a while loop till that is found.
				while (found == false)
				{
					//Get range
					nextRange = nextRange + (this.params.numDivLines + 1) * (adjInterval);
					//If it's divisible for the given range and adjusted interval, proceed
					if (isRangeDivisible (nextRange, this.params.numDivLines, adjInterval))
					{
						//Delta Range
						deltaRange = nextRange - this.config.PRange;
						//Range division
						rangeDiv = nextRange / (this.params.numDivLines + 1);
						//Get the smaller arm of axis
						smallArm = Math.min (Math.abs (this.config.PYMin) , this.config.PYMax);
						//Bigger arm of axis.
						bigArm = this.config.PRange - smallArm;
						//Get the multiplication factor (if smaller arm is negative, set -1);
						mf = (smallArm == Math.abs (this.config.PYMin)) ? - 1 : 1;
						//If num div lines ==0, we do not calculate anything
						if (this.params.numDivLines == 0)
						{
							//Set flag to true to exit loop
							found = true;
						} else 
						{
							//Now, we need to make sure that the smaller arm of axis is a multiple
							//of rangeDiv and the multiplied result is greater than smallArm.
							for (var i = 1; i <= Math.floor ((this.params.numDivLines + 1) / 2); i ++)
							{
								//Get extended small arm
								extSmallArm = rangeDiv * i;
								//If extension is more than original intended delta, we move to next
								//value of loop as this range is smaller than our intended range
								if ((extSmallArm - smallArm) > deltaRange)
								{
									//Iterate to next loop value
									continue;
								}
								//Else if extended arm is greater than smallArm, we do the 0 div test
								if (extSmallArm > smallArm)
								{
									//Get extended big arm
									extBigArm = nextRange - extSmallArm;
									//Check whether for this range, 0 can come as a div
									//By checking whether both extBigArm and extSmallArm
									//are perfectly divisible by rangeDiv
									if (((extBigArm / rangeDiv) == (Math.floor (extBigArm / rangeDiv))) && ((extSmallArm / rangeDiv) == (Math.floor (extSmallArm / rangeDiv))))
									{
										//Store in global containers
										this.config.PRange = nextRange;
										this.config.PYMax = (mf == - 1) ? extBigArm : extSmallArm;
										this.config.PYMin = (mf == - 1) ? ( - extSmallArm) : ( - extBigArm);
										//Set found flag to true to exit loop
										found = true;
									}
								} else 
								{
									//Iterate to next loop value, as we need the arm to be greater
									//than original value.
									continue;
								}
							}
						}
					}
				}
			} else 
			{
				//Case 1.1 or 1.2
				/**
				* In this case, we first get apt divisible range based on yMin, yMax,
				* numDivLines and the calculated interval. Thereby, get the difference
				* between original range and new range and store as delta.
				* If yMax>0, add this delta to yMax. Else substract from yMin.
				*/
				//Get the adjusted divisible range
				var adjRange : Number = getDivisibleRange (this.config.PYMin, this.config.PYMax, this.params.numDivLines, this.config.PInterval, true);
				//Get delta (Calculated range minus original range)
				var deltaRange : Number = adjRange - this.config.PRange;
				//Update global range storage
				this.config.PRange = adjRange;
				//Now, add the change in range to yMax, if yMax > 0, else deduct from yMin
				if (this.config.PYMax > 0)
				{
					this.config.PYMax = this.config.PYMax + deltaRange;
				} else 
				{
					this.config.PYMin = this.config.PYMin - deltaRange;
				}
			}
		} else 
		{
			/**
			* Here, we've to handle the following cases
			* 2. User specifies both yMin, yMax in XML. (which our program still validates)
			* 3. User specifies only yMin. (we provide yMax)
			* 4. User specifies only yMax. (we provide yMin)
			* Now, for each of these, there can be two cases. If the user has opted to
			* adjust div lines or not. If he has opted to adjustDiv, we calculate the best
			* possible number of div lines for the given range. If not, we simply divide
			* the given (or semi-calculated) axis limits by the number of div lines.
			*/
			if (this.params.adjustDiv == true)
			{
				//We iterate from given numDivLines to 0,
				//Count helps us keep a counter of how many div lines we've checked
				//For the sake of optimization, we check only 25 div lines values
				//From (numDivLines to 0) and (numDivLines to (25-numDivLines))
				//We do it in a yoyo order - i.e., if numDivLines is set as 5,
				//we first check 6 and then 4. Next would be (8,3), (9,2), (10,1),
				//(11, (no value here, as we do not check for 0), 12, 13, 14, 15, 16,
				//17,18,19,20. So, in this way, we check for 25 possible numDivLines and
				//see if any one them fit in. If yes, we store that value. Else, we set it
				//as 0 (indicating no div line feasible for the given value).
				//Perform only if this.params.numDivLines>0
				if (this.params.numDivLines > 0)
				{
					var counter : Number = 0;
					var multiplyFactor : Number = 1;
					var numDivLines : Number;
					while (1 == 1)
					{
						//Increment,Decrement numDivLines
						numDivLines = this.params.numDivLines + (counter * multiplyFactor);
						//Cannot be 0
						numDivLines = (numDivLines == 0) ? 1 : numDivLines;
						//Check whether this number of numDivLines satisfy our requirement
						if (isRangeDivisible (this.config.PRange, numDivLines, this.config.PInterval))
						{
							//Exit loop
							break;
						}
						//Each counter comes twice: one for + count, one for - count
						counter = (multiplyFactor == - 1 || (counter > this.params.numDivLines)) ? ( ++ counter) : (counter);
						if (counter > 25)
						{
							//We do not go beyond 25 count to optimize.
							//If the loop comes here, it means that divlines
							//counter is not able to achieve the target.
							//So, we assume no div lines are possible and exit.
							numDivLines = 0;
							break;
						}
						//Switch to increment/decrement mode. If counter
						multiplyFactor = (counter <= this.params.numDivLines) ? (multiplyFactor * - 1) : (1);
					}
					//Store the value in params
					this.params.numDivLines = numDivLines;
					//Set flag that we do not have to format div (y-axis values) decimals
					this.config.formatPDivDecimals = false;
				}
			} else 
			{
				//We need to set flag that div lines intevals need to formatted
				//to the given precision.
				//Set flag that we have to format div (y-axis values) decimals
				this.config.formatPDivDecimals = true;
			}
		}
		//Now, adjust the secondary axis limits (if required).
		if (this.config.SYMinGiven == false && this.config.SYMaxGiven == false && this.params.adjustDiv == true)
		{
			/**
			* First get apt divisible range based on yMin, yMax,
			* numDivLines and the calculated interval. Thereby, get the difference
			* between original range and new range and store as delta.
			* If yMax>0, add this delta to yMax. Else substract from yMin.
			*/
			//Set flag that we do not have to format div (y-axis values) decimals
			this.config.formatSDivDecimals = false;
			//Get the adjusted divisible range
			var adjRange : Number = getDivisibleRange (this.config.SYMin, this.config.SYMax, this.params.numDivLines, this.config.SInterval, true);
			//Get delta (Calculated range minus original range)
			var deltaRange : Number = adjRange - this.config.SRange;
			//Update global range storage
			this.config.SRange = adjRange;
			//Now, add the change in range to yMax, if yMax > 0, else deduct from yMin
			if (this.config.SYMax > 0)
			{
				this.config.SYMax = this.config.SYMax + deltaRange;
			} else 
			{
				this.config.SYMin = this.config.SYMin - deltaRange;
			}
		}else
		{
			//We need to set flag that div lines intevals need to formatted
			//to the given precision.
			//Set flag that we have to format div (y-axis values) decimals
			this.config.formatSDivDecimals = true;
		}
		// ----------- FINAL CALCULATION ----------- //
		//Set flags pertinent to zero plane
		if (this.config.PYMax > 0 && this.config.PYMin < 0)
		{
			this.config.zeroPRequired = true;
		} else 
		{
			this.config.zeroPRequired = false;
		}
		//Div interval
		this.config.PDivInterval = (this.config.PYMax - this.config.PYMin) / (this.params.numDivLines + 1);
		this.config.SDivInterval = (this.config.SYMax - this.config.SYMin) / (this.params.numDivLines + 1);
		//Flag to keep a track whether zero plane is included
		this.config.zeroPIncluded = false;
		//We now need to store all the div line segments in the array this.divLines & this.sDivLines
		//We include yMin and yMax too in div lines to render in a single loop
		var PDivLineValue : Number = this.config.PYMin - this.config.PDivInterval;
		var SDivLineValue : Number = this.config.SYMin - this.config.SDivInterval;
		//Keeping a count of div lines
		var count : Number = 0;
		while (count <= (this.params.numDivLines + 1))
		{
			//Converting to string and back to number to avoid Flash's rounding problems.
			PDivLineValue = Number (String (PDivLineValue + this.config.PDivInterval));
			SDivLineValue = Number (String (SDivLineValue + this.config.SDivInterval));
			//Check whether zero plane is included
			this.config.zeroPIncluded = (PDivLineValue == 0) ? true : this.config.zeroPIncluded;
			//Add the div line to this.divLines
			this.divLines [count] = this.returnDataAsPDivLine (PDivLineValue);
			this.sDivLines [count] = this.returnDataAsSDivLine (SDivLineValue);
			//Based on yAxisValueStep, we need to hide required div line values
			if (count % this.params.yAxisValuesStep == 0)
			{
				this.divLines [count].showValue = true;
				this.sDivLines [count].showValue = true;
			} else 
			{
				this.divLines [count].showValue = false;
				this.sDivLines [count].showValue = false;
			}
			//Increment counter
			count ++;
		}
		//Now, the array this.divLines contains all the divisional values. But, it might
		//not contain 0 value in Case 2,3,4 (i.e., when the user manually sets things).
		//So, if zero plane is required but not included, we include it.
		if (this.config.zeroPRequired == true && this.config.zeroPIncluded == false)
		{
			//Include zero plane at the right place in the array.
			this.divLines.push (this.returnDataAsPDivLine (0));
			//Now, sort on value so that 0 automatically appears at right place
			this.divLines.sortOn ("value", Array.NUMERIC);
		}
		//We finally have the sorted div lines in this.divLines & this.sDivLines
		
	}
	/**
	* isRangeDivisible method helps us judge whether the given range is
	* perfectly divisible for specified y-interval, numDivLines, yMin and yMax.
	* To check that, we divide the given range into (numDivLines+1) section.
	* If the decimal places of this division value is <= that of interval,
	* that means, this range fits in our purpose. We return a boolean value
	* accordingly.
	*	@param	range		Range of y-axis (Max - Min). Absolute value
	*	@param	numDivLines	Number of div lines to be plotted.
	*	@param	interval	Y-axis Interval (power of ten).
	*	@return			Boolean value indicating whether this range is divisible
	*						by the given number of div lines.
	*/
	private function isRangeDivisible (range : Number, numDivLines : Number, interval : Number) : Boolean 
	{
		//Get range division
		var rangeDiv : Number = range / (numDivLines + 1);
		//Now, if the decimal places of rangeDiv and interval do not match,
		//it's not divisible, else it's divisible
		if (MathExt.numDecimals (rangeDiv) > MathExt.numDecimals (interval))
		{
			return false;
		} else 
		{
			return true;
		}
	}
	/**
	* getDivisibleRange method calculates a perfectly divisible range based
	* on y-interval, numDivLines, yMin and yMax specified.
	* We first get the range division for the existing range
	* and user specified number of div lines. Now, if that division satisfies
	* our needs (decimal places of division and interval is equal), we do NOT
	* change anything. Else, we round up the division to the next higher value {big delta
	* in case of smaller values i.e., interval <1 and small delta in case of bigger values >1).
	* We multiply this range division by number of div lines required and calculate
	* the new range.
	*	@param	yMin			Min value of y-axis
	*	@param	yMax			Max value of y-axis
	*	@param	numDivLines		Number of div lines to be plotted.
	*	@param	interval		Y-axis Interval (power of ten).
	*	@param	interceptRange	Boolean value indicating whether we've to change the range
	*							by altering interval (based on it's own value).
	*	@return				A range that is perfectly divisible into given number of sections.
	*/
	private function getDivisibleRange (yMin : Number, yMax : Number, numDivLines : Number, interval : Number, interceptRange : Boolean) : Number 
	{
		//Get the range division for current yMin, yMax and numDivLines
		var range = Math.abs (yMax - yMin);
		var rangeDiv : Number = range / (numDivLines + 1);
		//Now, the range is not divisible
		if ( ! isRangeDivisible (range, numDivLines, interval))
		{
			//We need to get new rangeDiv which can be equally distributed.
			//If intercept range is set to true
			if (interceptRange)
			{
				//Re-adjust interval so that gap is not much (conditional)
				//Condition check limit based on value
				var checkLimit : Number = (interval > 1) ? 2 : 0.5;
				if ((Number (rangeDiv) / Number (interval)) < checkLimit)
				{
					//Decrease power of ten to get closer rounding
					interval = interval / 10;
				}
			}
			//Adjust range division based on new interval
			rangeDiv = (Math.floor (rangeDiv / interval) + 1) * interval;
			//Get new range
			range = rangeDiv * (numDivLines + 1);
		}
		//Return range
		return range;
	}
	/**
	* returnDataAsPDivLine method returns the data provided to the method
	* as a div line object for the primary axis.
	*	@param	value	Value of div line
	*	@return		An object with the parameters of div line
	*/
	private function returnDataAsPDivLine (value : Number) : Object 
	{
		//Create a new object
		var divLineObject = new Object ();
		divLineObject.value = value;
		//Display value
		//Now, if numbers are to be restricted to decimal places,
		if (this.config.formatPDivDecimals)
		{
			//Round off the div line value to this.params.yAxisValueDecimals precision
			divLineObject.displayValue = this.formatNumber (value, this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
		} else 
		{
			if (this.params.formatNumberScale)
			{
				//If number scale is defined, we round the numbers
				//Round off the div line value to this.params.decimals precision
				divLineObject.displayValue = this.formatNumber (value, this.params.formatNumber, this.params.decimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
			}else
			{
				//Set decimal places as 10, so that none of the decimals get stripped off
				divLineObject.displayValue = this.formatNumber (value, this.params.formatNumber, 10, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
			}
		}
		//Flag to show values
		divLineObject.showValue = true;
		return divLineObject;
	}
	/**
	* returnDataAsSDivLine method returns the data provided to the method
	* as a div line object for the secondary axis.
	*	@param	value	Value of div line
	*	@return		An object with the parameters of div line
	*/
	private function returnDataAsSDivLine (value : Number) : Object 
	{
		//Create a new object
		var divLineObject = new Object ();
		divLineObject.value = value;
		//Display value
		//Now, if numbers are to be restricted to decimal places,
		if (this.config.formatSDivDecimals == true)
		{
			//Round off the div line value to this.params.yAxisValueDecimals precision
			divLineObject.displayValue = this.formatNumber (value, this.params.sFormatNumber, this.params.sYAxisValueDecimals, false, this.params.sFormatNumberScale, this.params.sDefaultNumberScale, this.config.snsv, this.config.snsu, this.params.sNumberPrefix, this.params.sNumberSuffix);
		} else 
		{
			if (this.params.formatNumberScale)
			{
				//If number scale is defined, we round the numbers
				//Round off the div line value to this.params.decimals precision
				divLineObject.displayValue = this.formatNumber (value, this.params.sFormatNumber, this.params.sDecimals, false, this.params.sFormatNumberScale, this.params.sDefaultNumberScale, this.config.snsv, this.config.snsu, this.params.sNumberPrefix, this.params.sNumberSuffix);
			}else
			{
				//Set decimal places as 10, so that none of the decimals get stripped off
				divLineObject.displayValue = this.formatNumber (value, this.params.sFormatNumber, 10, false, this.params.sFormatNumberScale, this.params.sDefaultNumberScale, this.config.snsv, this.config.snsu, this.params.sNumberPrefix, this.params.sNumberSuffix);
			}
		}
		//Flag to show values
		divLineObject.showValue = true;
		return divLineObject;
	}
	/**
	* getAxisPosition method gets the pixel position of a particular
	* point on the axis based on its value.
	*	@param	value			Numerical value for which we need pixel axis position
	*	@param	upperLimit		Numerical upper limit for that axis
	*	@param	lowerLimit		Numerical lower limit for that axis
	*	@param	startAxisPos	Pixel start position for that axis
	*	@param	endAxisPos		Pixel end position for that axis
	*	@param	isYAxis			Flag indicating whether it's y axis
	*	@param	xPadding		Padding at left and right sides in case of a x-axis
	*	@return				The pixel position of the value on the given axis.
	*/
	private function getAxisPosition (value : Number, upperLimit : Number, lowerLimit : Number, startAxisPos : Number, endAxisPos : Number, isYAxis : Boolean, xPadding : Number) : Number 
	{
		//Define variables to be used locally
		var numericalInterval : Number;
		var axisLength : Number;
		var relativePosition : Number;
		var absolutePosition : Number;
		//Get the numerical difference between the limits
		numericalInterval = (upperLimit - lowerLimit);
		if (isYAxis)
		{
			//If it's y axis, the co-ordinates are opposite in Flash
			axisLength = (endAxisPos - startAxisPos);
			relativePosition = (axisLength / numericalInterval) * (value - lowerLimit);
			//If it's a y axis co-ordinate then go according to Flash's co-ordinate system
			//(y decreases as we go upwards)
			absolutePosition = endAxisPos - relativePosition;
		} else 
		{
			axisLength = (endAxisPos - startAxisPos) - (2 * xPadding);
			relativePosition = (axisLength / numericalInterval) * (value - lowerLimit);
			//The normal x-axis rule - increases as we go right
			absolutePosition = startAxisPos + xPadding + relativePosition;
		}
		return absolutePosition;
	}
	/**
	* returnDataAsTrendObj method takes in functional parameters, and creates
	* an object to represent the trend line as a unified object.
	*	@param	parentYAxis		Which axis will the trend line draw on?
	*	@param	startValue		Starting value of the trend line.
	*	@param	endValue		End value of the trend line (if different from start)
	*	@param	displayValue	Display value for the trend (if custom).
	* 	@param	toolText		Tool-text to be displayed for the trendline
	*	@param	color			Color of the trend line
	*	@param	thickness		Thickness (in pixels) of line
	*	@param	alpha			Alpha of the line
	*	@param	isTrendZone		Flag to control whether to show trend as a line or block(zone)
	*	@param	showOnTop		Whether to show trend over data plot or under it.
	*	@param	isDashed		Whether the line would appear dashed.
	*	@param	dashLen			Length of dash (if isDashed selected)
	*	@param	dashGap			Gap of dash (if isDashed selected)
	*	@return				An object encapsulating these values.
	*/
	private function returnDataAsTrendObj (parentYAxis : String, startValue : Number, endValue : Number, displayValue : String,  toolText: String, color : String, thickness : Number, alpha : Number, isTrendZone : Boolean, showOnTop : Boolean, isDashed : Boolean, dashLen : Number, dashGap : Number) : Object 
	{
		//Create an object that will be returned.
		var rtnObj : Object = new Object ();
		//Store parameters as object properties
		rtnObj.parentYAxis = parentYAxis;
		rtnObj.startValue = startValue;
		rtnObj.endValue = endValue;
		rtnObj.displayValue = displayValue;
		rtnObj.toolText = toolText;
		rtnObj.color = color;
		rtnObj.thickness = thickness;
		rtnObj.alpha = alpha;
		rtnObj.isTrendZone = isTrendZone;
		rtnObj.showOnTop = showOnTop;
		rtnObj.isDashed = isDashed;
		rtnObj.dashLen = dashLen;
		rtnObj.dashGap = dashGap;
		//Whether value is to be shown on right side or left side.
		rtnObj.valueOnRight = (parentYAxis == "P") ?false : true;
		//Flag whether trend line is proper
		rtnObj.isValid = true;
		//Holders for dimenstions
		rtnObj.y = 0;
		rtnObj.toY = 0;
		//Text box y position
		rtnObj.tbY = 0;
		//Return
		return rtnObj;
	}
	/**
	* returnDataAsVLineObj method takes in functional parameters, and creates
	* an object to represent the vertical axis distribution line as a unified object.
	*	@param	index			Index of the vertical line w.r.t data specified.
	* 	@param	label			Label for the vertical line
	* 	@param	showLabelBorder	Whether to show border for this label
	* 	@param	labelHAlign		Horizontal alignment position for label
	* 	@param	labelVAlign		Vertical alignment position for label
	* 	@param	labelPosition	Vertical position of label (or horizontal in case of horizontal chart)
	* 	@param	linePosition	Horizontal position of line (or horizontal in case of horizontal chart)
	*	@param	color			Color of the vertical line.
	*	@param	thickness		Thickness of the line.
	*	@param	alpha			Alpha of the line.
	*	@param	isDashed		Whether the line should appear as dashed.
	*	@param	dashLen			Length of dash (if isDashed).
	*	@param	dashGap			Gap length (if isDashed)
	*	@return					An object encapsulating these values.
	*/
	private function returnDataAsVLineObj (index : Number, label:String, showLabelBorder:Boolean, labelHAlign:String, labelVAlign:String, labelPosition:Number, linePosition:Number, color : String, thickness : Number, alpha : Number, isDashed : Boolean, dashLen : Number, dashGap : Number) : Object 
	{
		//Create an object that will be returned.
		var rtnObj : Object = new Object ();
		//Store parameters as object properties
		rtnObj.index = index;
		rtnObj.label = label;
		rtnObj.labelHAlign = labelHAlign;
		rtnObj.labelVAlign = labelVAlign;
		rtnObj.showLabelBorder = showLabelBorder;
		rtnObj.labelPosition = labelPosition;
		rtnObj.linePosition = linePosition;
		rtnObj.color = color;
		rtnObj.thickness = thickness;
		rtnObj.alpha = alpha;
		rtnObj.isDashed = isDashed;
		rtnObj.dashLen = dashLen;
		rtnObj.dashGap = dashGap;
		//Set a flag for validity
		rtnObj.isValid = true;
		//Holders for dimenstions
		rtnObj.x = 0;
		//Return
		return rtnObj;
	}
	/**
	* parseVLineNode method parses the vertical line node and stores it in
	* local objects
	*	@param	vLineNode	XML Node representing the vertical axis division
	*						line.
	*	@param	index		Index of the division line. Index represents the
	*						numerical index of data item/category on the left
	*						side of v line.
	*/
	private function parseVLineNode (vLineNode : XMLNode, index : Number)
	{
		//Variables for local use
		var label : String, showLabelBorder : Boolean, labelHAlign:String, labelVAlign:String;
		var labelPosition : Number, linePosition : Number;
		var color : String, thickness : Number, alpha : Number;
		var isDashed : Boolean, dashLen : Number, dashGap : Number;
		//Increment count
		this.numVLines ++;
		//Get attributes array
		var lineAttr : Array = this.getAttributesArray (vLineNode);
		//Extract attributes
		label = getFV(lineAttr["label"], "");
		showLabelBorder = toBoolean (getFV(lineAttr["showlabelborder"], this.params.showVLineLabelBorder));
		labelHAlign = getFV(lineAttr["labelhalign"], "center");
		labelVAlign = getFV(lineAttr["labelvalign"], "bottom");
		labelPosition = getFN (lineAttr ["labelposition"] , 0);
		linePosition = getFN (lineAttr ["lineposition"] , 0.5);
		color = String (formatColor (getFV (lineAttr ["color"] , "333333")));
		thickness = getFN (lineAttr ["thickness"] , 1);
		alpha = getFN (lineAttr ["alpha"] , 80);
		isDashed = toBoolean (Number (getFV (lineAttr ["dashed"] , 0)));
		dashLen = getFN (lineAttr ["dashlen"] , 5);
		dashGap = getFN (lineAttr ["dashgap"] , 2);
		//Label and line position need to be between 0 and 1
		labelPosition = (labelPosition<0 || labelPosition>1)?0:labelPosition;
		linePosition = (linePosition<0 || linePosition>1)?0.5:linePosition;
		//Create object and store
		this.vLines [this.numVLines] = this.returnDataAsVLineObj (index, label, showLabelBorder, labelHAlign, labelVAlign, labelPosition, linePosition, color, thickness, alpha, isDashed, dashLen, dashGap);
	}
	/**
	* parseTrendLineXML method parses the XML node containing trend line nodes
	* and then stores it in local objects.
	*	@param		arrTrendLineNodes		Array containing Trend LINE nodes.
	*	@return							Nothing.
	*/
	private function parseTrendLineXML (arrTrendLineNodes : Array) : Void 
	{
		//Define variables for local use
		var parentYAxis : String;
		var startValue : Number, endValue : Number, displayValue : String;
		var toolText:String;
		var color : String, thickness : Number, alpha : Number;
		var isTrendZone : Boolean, showOnTop : Boolean, isDashed : Boolean;
		var dashLen : Number, dashGap : Number, valueOnRight : Boolean;
		//Loop variable
		var i : Number;
		//Iterate through all nodes in array
		for (i = 0; i <= arrTrendLineNodes.length; i ++)
		{
			//Check if LINE node
			if (arrTrendLineNodes [i].nodeName.toUpperCase () == "LINE")
			{
				//Update count
				numTrendLines ++;
				//Store the node reference
				var lineNode : XMLNode = arrTrendLineNodes [i];
				//Get attributes array
				var lineAttr : Array = this.getAttributesArray (lineNode);
				//Extract and store attributes
				parentYAxis = getFV (lineAttr ["parentyaxis"] , "P");
				//Capitalize parent Y axis
				parentYAxis = parentYAxis.toUpperCase ();
				//If not P or S, set to P
				if (parentYAxis != "P" && parentYAxis != "S")
				{
					parentYAxis = "P";
				}
				startValue = getFN (this.getSetValue(lineAttr ["startvalue"]) , this.getSetValue(lineAttr ["value"]));
				endValue = getFN (this.getSetValue(lineAttr ["endvalue"]) , startValue);
				displayValue = lineAttr ["displayvalue"];
				toolText = getFV(lineAttr["tooltext"], "");
				color = String (formatColor (getFV (lineAttr ["color"] , "333333")));
				thickness = getFN (lineAttr ["thickness"] , 1);
				isTrendZone = toBoolean (Number (getFV (lineAttr ["istrendzone"] , 0)));
				alpha = getFN (lineAttr ["alpha"] , (isTrendZone == true) ? 40 : 99);
				showOnTop = toBoolean (getFN (lineAttr ["showontop"] , 0));
				isDashed = toBoolean (getFN (lineAttr ["dashed"] , 0));
				dashLen = getFN (lineAttr ["dashlen"] , 5);
				dashGap = getFN (lineAttr ["dashgap"] , 2);
				//Create trend line object
				this.trendLines [numTrendLines] = returnDataAsTrendObj (parentYAxis, startValue, endValue, displayValue, toolText, color, thickness, alpha, isTrendZone, showOnTop, isDashed, dashLen, dashGap);
				//Update numTrendLinesBelow
				numTrendLinesBelow = (showOnTop == false) ? ( ++ numTrendLinesBelow) : numTrendLinesBelow;
			}
		}
	}
	/**
	* validateTrendLines method helps us validate the different trend line
	* points entered by user in XML. Some trend points may fall out of
	* chart range (yMin,yMax) and we need to invalidate them. Also, we
	* need to check if displayValue has been specified. Else, we specify
	* formatted number as displayValue.
	*	@return		Nothing
	*/
	private function validateTrendLines ()
	{
		//Sequentially do the following.
		//- Check if start value and end value are numbers. If not,
		//  invalidate them
		//- Check range of each trend line against chart yMin,yMax and
		//  devalidate wrong ones.
		//- Resolve displayValue conflict.
		//- Calculate and store y position of start and end position.
		//Loop variable
		var i : Number;
		for (i = 0; i <= this.numTrendLines; i ++)
		{
			//If the trend line start/end value is NaN or out of range
			if (isNaN (this.trendLines [i].startValue) || isNaN (this.trendLines [i].endValue))
			{
				//Invalidate it
				this.trendLines [i].isValid = false;
			} else 
			{
				//Now, if the trend line is based on primary y-axis
				if (this.trendLines [i].parentYAxis == "P")
				{
					//Check for range bound validation
					if ((this.trendLines [i].startValue < this.config.PYMin) || (this.trendLines [i].startValue > this.config.PYMax) || (this.trendLines [i].endValue < this.config.PYMin) || (this.trendLines [i].endValue > this.config.PYMax))
					{
						//Invalidate it
						this.trendLines [i].isValid = false;
					}
					else
					{
						//We resolve displayValue conflict
						this.trendLines [i].displayValue = getFV (this.trendLines [i].displayValue, this.formatNumber (this.trendLines [i].startValue, this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix));
					}
				} 
				else
				{
					//Check for range bound validation
					if ((this.trendLines [i].startValue < this.config.SYMin) || (this.trendLines [i].startValue > this.config.SYMax) || (this.trendLines [i].endValue < this.config.SYMin) || (this.trendLines [i].endValue > this.config.SYMax))
					{
						//Invalidate it
						this.trendLines [i].isValid = false;
					}
					else
					{
						//We resolve displayValue conflict
						this.trendLines [i].displayValue = getFV (this.trendLines [i].displayValue, this.formatNumber (this.trendLines [i].endValue, this.params.sFormatNumber, this.params.sYAxisValueDecimals, false, this.params.sFormatNumberScale, this.params.sDefaultNumberScale, this.config.snsv, this.config.snsu, this.params.sNumberPrefix, this.params.sNumberSuffix));
					}
				}
			}
		}
	}
	/**
	* reInit method re-initializes the chart. This method is basically called
	* when the user changes chart data through JavaScript. In that case, we need
	* to re-initialize the chart, set new XML data and again render.
	*/
	public function reInit () : Void 
	{
		//Invoke super class's reInit
		super.reInit ();
		//Re-set indexes to 0
		this.numTrendLines = 0;
		this.numTrendLinesBelow = 0;
		this.numVLines = 0;
		//Re-create container arrays
		this.divLines = new Array ();
		this.sDivLines = new Array ();
		this.trendLines = new Array ();
		this.vLines = new Array ();
	}
}
