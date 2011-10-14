 /**
* XYPlotChart chart extends the Chart class to render the generic
* template for a chart with X and Y Plot axis(like Scatter, Bubble)
*/
//Import parent Chart class
import com.fusioncharts.core.Chart;
import com.fusioncharts.helper.Utils;
import com.fusioncharts.helper.Logger;
import com.fusioncharts.extensions.DrawingExt;
import com.fusioncharts.extensions.ColorExt;
import com.fusioncharts.extensions.MathExt;
//Legend Class
import com.fusioncharts.helper.Legend;
import mx.transitions.Tween;
//Delegate
import mx.utils.Delegate;
class com.fusioncharts.core.XYPlotChart extends Chart
{
	//Version number (if different from super Chart class)
	//private var _version:String = "3.0.0";
	//Instance variables
	//Storage for data
	private var dataset : Array;
	//Array to store x-axis categories (labels)
	private var categories : Array;
	//Number of data sets
	private var numDS : Number = 0;
	//Number of data items (max)
	private var num : Number = 0;
	//Number of categories
	private var numCat : Number = 0;
	//Storage for div lines
	private var divLines : Array;
	//Axis charts can have trend lines. trendLines array
	//stores the trend lines for an axis chart.
	private var trendLines : Array;
	//Vertical trend lines
	private var vTrendLines : Array;
	//numTrendLines stores the number of trend lines
	private var numTrendLines : Number = 0;
	//Number of trend lines below
	private var numTrendLinesBelow : Number = 0;
	//Vertical trend lines
	private var numVTrendLines : Number = 0;
	//Reference to legend component of chart
	private var lgnd : Legend;
	//Reference to legend movie clip
	private var lgndMC : MovieClip;
	/**
	* Constructor function. We invoke the super class'
	* constructor.
	*/
	function XYPlotChart (targetMC : MovieClip, depth : Number, width : Number, height : Number, x : Number, y : Number, debugMode : Boolean, lang : String, scaleMode:String, registerWithJS:Boolean, DOMId:String)
	{
		//Invoke the super class constructor
		super (targetMC, depth, width, height, x, y, debugMode, lang, scaleMode, registerWithJS, DOMId);
		//Data Storage array
		this.categories = new Array ();
		this.dataset = new Array ();
		//Initialize div lines array
		this.divLines = new Array ();
		//Initialize the trendlines array
		this.trendLines = new Array ();
		this.vTrendLines = new Array ();
	}
	/**
	* getMaxYDataValue method gets the maximum y-axis data value present
	* in the data.
	*	@return	The maximum value present in the data provided.
	*/
	private function getMaxYDataValue () : Number
	{
		var maxValue : Number;
		var firstNumberFound : Boolean = false;
		var i : Number, j : Number;
		for (i = 1; i <= this.numDS; i ++)
		{
			for (j = 1; j <= this.num; j ++)
			{
				//By default assume the first non-null number to be maximum
				if (firstNumberFound == false)
				{
					if (this.dataset [i].data [j].isDefined == true)
					{
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be maximum.
						maxValue = this.dataset [i].data [j].yv;
					}
				} else
				{
					//If the first number has been found and the current data is defined, compare
					if (this.dataset [i].data [j].isDefined)
					{
						//Store the greater number
						maxValue = (this.dataset [i].data [j].yv > maxValue) ? this.dataset [i].data [j].yv : maxValue;
					}
				}
			}
		}
		return maxValue;
	}
	/**
	* getMinYDataValue method gets the minimum y-axis data value present
	* in the data
	*	@reurns		The minimum value present in data
	*/
	private function getMinYDataValue () : Number
	{
		var minValue : Number;
		var firstNumberFound : Boolean = false;
		var i : Number, j : Number;
		for (i = 1; i <= this.numDS; i ++)
		{
			for (j = 1; j <= this.num; j ++)
			{
				//By default assume the first non-null number to be minimum
				if (firstNumberFound == false)
				{
					if (this.dataset [i].data [j].isDefined == true)
					{
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be minimum.
						minValue = this.dataset [i].data [j].yv;
					}
				} else
				{
					//If the first number has been found and the current data is defined, compare
					if (this.dataset [i].data [j].isDefined)
					{
						//Store the lesser number
						minValue = (this.dataset [i].data [j].yv < minValue) ? this.dataset [i].data [j].yv : minValue;
					}
				}
			}
		}
		return minValue;
	}
	/**
	* getMaxXDataValue method gets the maximum x-axis data value present
	* in the data.
	*	@return	The maximum value present in the data provided.
	*/
	private function getMaxXDataValue () : Number
	{
		var maxValue : Number;
		var firstNumberFound : Boolean = false;
		var i : Number, j : Number;
		for (i = 1; i <= this.numDS; i ++)
		{
			for (j = 1; j <= this.num; j ++)
			{
				//By default assume the first non-null number to be maximum
				if (firstNumberFound == false)
				{
					if (this.dataset [i].data [j].isDefined == true)
					{
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be maximum.
						maxValue = this.dataset [i].data [j].xv;
					}
				} else
				{
					//If the first number has been found and the current data is defined, compare
					if (this.dataset [i].data [j].isDefined)
					{
						//Store the greater number
						maxValue = (this.dataset [i].data [j].xv > maxValue) ? this.dataset [i].data [j].xv : maxValue;
					}
				}
			}
		}
		return maxValue;
	}
	/**
	* getMinXDataValue method gets the minimum x-axis data value present
	* in the data
	*	@reurns		The minimum value present in data
	*/
	private function getMinXDataValue () : Number
	{
		var minValue : Number;
		var firstNumberFound : Boolean = false;
		var i : Number, j : Number;
		for (i = 1; i <= this.numDS; i ++)
		{
			for (j = 1; j <= this.num; j ++)
			{
				//By default assume the first non-null number to be minimum
				if (firstNumberFound == false)
				{
					if (this.dataset [i].data [j].isDefined == true)
					{
						//Set the flag that "We've found first non-null number".
						firstNumberFound = true;
						//Also assume this value to be minimum.
						minValue = this.dataset [i].data [j].xv;
					}
				} else
				{
					//If the first number has been found and the current data is defined, compare
					if (this.dataset [i].data [j].isDefined)
					{
						//Store the lesser number
						minValue = (this.dataset [i].data [j].xv < minValue) ? this.dataset [i].data [j].xv : minValue;
					}
				}
			}
		}
		return minValue;
	}
	/**
	* getXAxisLimits method helps calculate the X-axis limits based
	* on the given maximum and minimum value.
	* @param	maxValue		Maximum numerical value (X) present in data
	*	@param	minValue		Minimum numerical value (X) present in data
	*/
	private function getXAxisLimits (maxValue : Number, minValue : Number) : Void
	{
		//First check if both maxValue and minValue are proper numbers.
		//Else, set defaults as 90,0
		maxValue = (isNaN (maxValue) == true || maxValue == undefined) ? 0.1 : maxValue;
		minValue = (isNaN (minValue) == true || minValue == undefined) ? 0 : minValue;
		//Or, if only 0 data is supplied
		if ((maxValue == minValue) && (maxValue == 0))
		{
			maxValue = 90;
		}
		//Get the maximum power of 10 that is applicable to maxvalue
		//The Number = 10 to the power maxPowerOfTen + x (where x is another number)
		//For e.g., in 99 the maxPowerOfTen will be 1 = 10^1 + 89
		//And for 102, it will be 2 = 10^2 + 2
		var maxPowerOfTen : Number = Math.floor (Math.log (Math.abs (maxValue)) / Math.LN10);
		//Get the minimum power of 10 that is applicable to maxvalue
		var minPowerOfTen : Number = Math.floor (Math.log (Math.abs (minValue)) / Math.LN10);
		//Find which powerOfTen (the max power or the min power) is bigger
		//It is this which will be multiplied to get the x-interval
		var powerOfTen : Number = Math.max (minPowerOfTen, maxPowerOfTen);
		var x_interval : Number = Math.pow (10, powerOfTen);
		//For accomodating smaller range values (so that scale doesn't represent too large an interval
		if (Math.abs (maxValue) / x_interval < 2 && Math.abs (minValue) / x_interval < 2)
		{
			powerOfTen --;
			x_interval = Math.pow (10, powerOfTen);
		}
		//If the x_interval of min and max is way more than that of range.
		//We need to reset the x-interval as per range
		var rangePowerOfTen : Number = Math.floor (Math.log (maxValue - minValue) / Math.LN10);
		var rangeInterval : Number = Math.pow (10, rangePowerOfTen);
		//Now, if rangeInterval is 10 times less than x_interval, we need to re-set
		//the limits, as the range is too less to adjust the axis for max,min.
		//We do this only if range is greater than 0 (in case of 1 data on chart).
		if (((maxValue - minValue) > 0) && ((x_interval / rangeInterval) >= 10))
		{
			x_interval = rangeInterval;
			powerOfTen = rangePowerOfTen;
		}
		//Calculate the x-axis upper limit
		var x_topBound : Number = (Math.floor (maxValue / x_interval) + 1) * x_interval;
		//Calculate the x-axis lower limit
		var x_lowerBound : Number;
		//If the min value is less than 0
		if (minValue < 0)
		{
			//Then calculate by multiplying negative numbers with x-axis interval
			x_lowerBound = - 1 * ((Math.floor (Math.abs (minValue / x_interval)) + 1) * x_interval);
		} else
		{
			x_lowerBound = Math.floor (Math.abs (minValue / x_interval) - 1) * x_interval;
			//Now, if minValue>=0, we keep x_lowerBound to 0 - as for values like minValue 2
			//lower bound goes negative, which is not required.
			x_lowerBound = (x_lowerBound < 0) ?0 : x_lowerBound;
		}
		//If he has provided it and it is valid, we leave it as the upper limit
		//Else, we enforced the value calculate by us as the upper limit.
		if (this.params.xAxisMaxValue == null || this.params.xAxisMaxValue == undefined || this.params.xAxisMaxValue == "" || Number (this.params.xAxisMaxValue) == NaN || Number (this.params.xAxisMaxValue) < maxValue)
		{
			this.config.xMax = x_topBound;
		} else
		{
			this.config.xMax = Number (this.params.xAxisMaxValue);
		}
		//Now, we do the same for x-axis lower limit
		if (this.params.xAxisMinValue == null || this.params.xAxisMinValue == undefined || this.params.xAxisMinValue == "" || Number (this.params.xAxisMinValue) == NaN || Number (this.params.xAxisMinValue) > minValue)
		{
			this.config.xMin = x_lowerBound;
		} else
		{
			this.config.xMin = Number (this.params.xAxisMinValue);
		}
	}
	/**
	* getYAxisLimits method helps calculate the Y-axis limits based
	* on the given maximum and minimum value.
	* @param	maxValue		Maximum numerical value (Y) present in data
	*	@param	minValue		Minimum numerical value (Y) present in data
	*	@param	stopMaxAtZero	Flag indicating whether maximum value can
	*							be less than 0.
	*	@param	setMinAsZero	Whether to set the lower limit as 0 or a greater
	*							appropriate value (when dealing with positive numbers)
	*/
	private function getYAxisLimits (maxValue : Number, minValue : Number, stopMaxAtZero : Boolean, setMinAsZero : Boolean) : Void
	{
		//First check if both maxValue and minValue are proper numbers.
		//Else, set defaults as 90,0
		maxValue = (isNaN (maxValue) == true || maxValue == undefined) ? 0.1 : maxValue;
		minValue = (isNaN (minValue) == true || minValue == undefined) ? 0 : minValue;
		//Or, if only 0 data is supplied
		if ((maxValue == minValue) && (maxValue == 0))
		{
			maxValue = 90;
		}
		//Defaults for stopMaxAtZero and setMinAsZero
		stopMaxAtZero = Utils.getFirstValue (stopMaxAtZero, false);
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
			}
		}
		//MaxValue cannot be less than 0 if stopMaxAtZero is set to true
		if (stopMaxAtZero && maxValue <= 0)
		{
			y_topBound = 0;
		}
		//Now, we need to make a check as to whether the user has provided an upper limit
		//and lower limit.
		if (this.params.yAxisMaxValue == null || this.params.yAxisMaxValue == undefined || this.params.yAxisMaxValue == "")
		{
			this.config.yMaxGiven = false;
		} else
		{
			this.config.yMaxGiven = true;
		}
		if (this.params.yAxisMinValue == null || this.params.yAxisMinValue == undefined || this.params.yAxisMinValue == "" || Number (this.params.yAxisMinValue) == NaN)
		{
			this.config.yMinGiven = false;
		} else
		{
			this.config.yMinGiven = true;
		}
		//If he has provided it and it is valid, we leave it as the upper limit
		//Else, we enforced the value calculate by us as the upper limit.
		if (this.config.yMaxGiven == false || (this.config.yMaxGiven == true && Number (this.params.yAxisMaxValue) < maxValue))
		{
			this.config.yMax = y_topBound;
		} else
		{
			this.config.yMax = Number (this.params.yAxisMaxValue);
		}
		//Now, we do the same for y-axis lower limit
		if (this.config.yMinGiven == false || (this.config.yMinGiven == true && Number (this.params.yAxisMinValue) > minValue))
		{
			this.config.yMin = y_lowerBound;
		} else
		{
			this.config.yMin = Number (this.params.yAxisMinValue);
		}
		//Store axis range
		this.config.range = Math.abs (this.config.yMax - this.config.yMin);
		//Store interval
		this.config.interval = y_interval;
	}
	/**
	* calcDivs method calculates the best div line interval for the given/calculated
	* yMin, yMax, specified numDivLines and adjustDiv.
	* We re-set the y axis min and max value, if both were calculated by our
	* us, so that we get a best value according to numDivLines. The idea is to have equal
	* intervals on the axis, based on numDivLines specified. We do so, only if both yMin and
	* yMax have been calculated as per our values. Else, we adjust the numDiv Lines.
	*/
	private function calcDivs () : Void
	{
		/**
		* There can be four cases of yMin, yMax.
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
		if (this.config.yMinGiven == false && this.config.yMaxGiven == false && this.params.adjustDiv == true)
		{
			//Means neither chart max value nor min value has been specified and adjustDiv is true
			//Set flag that we do not have to format div (y-axis values) decimals
			this.config.formatDivDecimals = false;
			//Now, if it's case 1.3 (yMax > 0 & yMin <0)
			if (this.config.yMax > 0 && this.config.yMin < 0)
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
				var adjInterval = (this.config.interval > 10) ? (this.config.interval / 10) : this.config.interval;
				//Get the first divisible range for the given yMin, yMax, numDivLines and interval.
				//We do not intercept and adjust interval for this calculation here.
				var range : Number = getDivisibleRange (this.config.yMin, this.config.yMax, this.params.numDivLines, adjInterval, false);
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
						deltaRange = nextRange - this.config.range;
						//Range division
						rangeDiv = nextRange / (this.params.numDivLines + 1);
						//Get the smaller arm of axis
						smallArm = Math.min (Math.abs (this.config.yMin) , this.config.yMax);
						//Bigger arm of axis.
						bigArm = this.config.range - smallArm;
						//Get the multiplication factor (if smaller arm is negative, set -1);
						mf = (smallArm == Math.abs (this.config.yMin)) ? - 1 : 1;
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
										this.config.range = nextRange;
										this.config.yMax = (mf == - 1) ? extBigArm : extSmallArm;
										this.config.yMin = (mf == - 1) ? ( - extSmallArm) : ( - extBigArm);
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
				var adjRange : Number = getDivisibleRange (this.config.yMin, this.config.yMax, this.params.numDivLines, this.config.interval, true);
				//Get delta (Calculated range minus original range)
				var deltaRange : Number = adjRange - this.config.range;
				//Update global range storage
				this.config.range = adjRange;
				//Now, add the change in range to yMax, if yMax > 0, else deduct from yMin
				if (this.config.yMax > 0)
				{
					this.config.yMax = this.config.yMax + deltaRange;
				} else
				{
					this.config.yMin = this.config.yMin - deltaRange;
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
						if (isRangeDivisible (this.config.range, numDivLines, this.config.interval))
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
					this.config.formatDivDecimals = false;
				}
			} else
			{
				//We need to set flag that div lines intevals need to formatted
				//to the given precision.
				//Set flag that we have to format div (y-axis values) decimals
				this.config.formatDivDecimals = true;
			}
		}
		//Set flags pertinent to zero plane
		if (this.config.yMax > 0 && this.config.yMin < 0)
		{
			this.config.zeroPRequired = true;
		} else
		{
			this.config.zeroPRequired = false;
		}
		//Div interval
		this.config.divInterval = (this.config.yMax - this.config.yMin) / (this.params.numDivLines + 1);
		//Flag to keep a track whether zero plane is included
		this.config.zeroPIncluded = false;
		//We now need to store all the div line segments in the array this.divLines
		//We include yMin and yMax too in div lines to render in a single loop
		var divLineValue : Number = this.config.yMin - this.config.divInterval;
		//Keeping a count of div lines
		var count : Number = 0;
		while (count <= (this.params.numDivLines + 1))
		{
			//Converting to string and back to number to avoid Flash's rounding problems.
			divLineValue = Number (String (divLineValue + this.config.divInterval));
			//Check whether zero plane is included
			this.config.zeroPIncluded = (divLineValue == 0) ? true : this.config.zeroPIncluded;
			//Add the div line to this.divLines
			this.divLines [count] = this.returnDataAsDivLine (divLineValue);
			//Based on yAxisValueStep, we need to hide required div line values
			if (count % this.params.yAxisValuesStep == 0)
			{
				this.divLines [count].showValue = true;
			} else
			{
				this.divLines [count].showValue = false;
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
			this.divLines.push (this.returnDataAsDivLine (0));
			//Now, sort on value so that 0 automatically appears at right place
			this.divLines.sortOn ("value", Array.NUMERIC);
		}
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
	* returnDataAsDivLine method returns the data provided to the method
	* as a div line object.
	*	@param	value	Value of div line
	*	@return		An object with the parameters of div line
	*/
	private function returnDataAsDivLine (value : Number) : Object
	{
		//Create a new object
		var divLineObject = new Object ();
		divLineObject.value = value;
		//Display value
		//Now, if numbers are to be restricted to decimal places,
		if (this.config.formatDivDecimals)
		{
			//Round off the div line value to this.params.yAxisValueDecimals precision
			divLineObject.displayValue = this.formatNumber (value, this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
		} else
		{
			//Set decimal places as 10, so that none of the decimals get stripped off
			divLineObject.displayValue = this.formatNumber (value, this.params.formatNumber, 10, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix);
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
	*	@param	valueOnRight	Whether to put the trend value on right side of canvas
	*	@return				An object encapsulating these values.
	*/
	private function returnDataAsTrendObj (startValue : Number, endValue : Number, displayValue : String, toolText: String, color : String, thickness : Number, alpha : Number, isTrendZone : Boolean, showOnTop : Boolean, isDashed : Boolean, dashLen : Number, dashGap : Number, valueOnRight : Boolean) : Object
	{
		//Create an object that will be returned.
		var rtnObj : Object = new Array ();
		//Store parameters as object properties
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
		rtnObj.valueOnRight = valueOnRight;
		//Flag whether trend line is proper
		rtnObj.isValid = true;
		//Return
		return rtnObj;
	}
	/**
	* parseHTrendLineXML method parses the XML node containing horizontal trend line nodes
	* and then stores it in local objects.
	*	@param		arrTrendLineNodes		Array containing Trend LINE nodes.
	*	@return							Nothing.
	*/
	private function parseHTrendLineXML (arrTrendLineNodes : Array) : Void
	{
		//Define variables for local use
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
				valueOnRight = toBoolean (getFN (lineAttr ["valueonright"] , 0));
				//Create trend line object
				this.trendLines [numTrendLines] = returnDataAsTrendObj (startValue, endValue, displayValue, toolText, color, thickness, alpha, isTrendZone, showOnTop, isDashed, dashLen, dashGap, valueOnRight);
				//Update numTrendLinesBelow
				numTrendLinesBelow = (showOnTop == false) ? ( ++ numTrendLinesBelow) : numTrendLinesBelow;
			}
		}
	}
	/**
	* parseVTrendLineXML method parses the XML node containing vertical trend line nodes
	* and then stores it in local objects.
	*	@param		arrTrendLineNodes		Array containing Trend LINE nodes.
	*	@return							Nothing.
	*/
	private function parseVTrendLineXML (arrTrendLineNodes : Array) : Void
	{
		//Define variables for local use
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
				numVTrendLines ++;
				//Store the node reference
				var lineNode : XMLNode = arrTrendLineNodes [i];
				//Get attributes array
				var lineAttr : Array = this.getAttributesArray (lineNode);
				//Extract and store attributes
				startValue = getFN (this.getSetValue(lineAttr ["startvalue"]) , this.getSetValue(lineAttr ["value"]));
				endValue = getFN (this.getSetValue(lineAttr ["endvalue"]) , startValue);
				displayValue = lineAttr ["displayvalue"];
				toolText = getFV(lineAttr["tooltext"], "");
				color = String (formatColor (getFV (lineAttr ["color"] , "333333")));
				thickness = getFN (lineAttr ["thickness"] , 1);
				isTrendZone = toBoolean (Number (getFV (lineAttr ["istrendzone"] , 1)));
				alpha = getFN (lineAttr ["alpha"] , (isTrendZone == true) ? 40 : 99);
				showOnTop = false;
				isDashed = toBoolean (getFN (lineAttr ["dashed"] , 0));
				dashLen = getFN (lineAttr ["dashlen"] , 5);
				dashGap = getFN (lineAttr ["dashgap"] , 2);
				valueOnRight = false;
				//Create trend line object
				this.vTrendLines [numVTrendLines] = returnDataAsTrendObj (startValue, endValue, displayValue, toolText, color, thickness, alpha, isTrendZone, showOnTop, isDashed, dashLen, dashGap, valueOnRight);
			}
		}
	}
	/**
	* validateTrendLines method helps us validate the different trend line
	* points entered by user in XML. Some trend points may fall out of
	* chart range (yMin,yMax - xMin,xMax) and we need to invalidate them. Also, we
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
			if (isNaN (this.trendLines [i].startValue) || (this.trendLines [i].startValue < this.config.yMin) || (this.trendLines [i].startValue > this.config.yMax) || isNaN (this.trendLines [i].endValue) || (this.trendLines [i].endValue < this.config.yMin) || (this.trendLines [i].endValue > this.config.yMax))
			{
				//Invalidate it
				this.trendLines [i].isValid = false;
			} else
			{
				//We resolve displayValue conflict
				this.trendLines [i].displayValue = getFV (this.trendLines [i].displayValue, this.formatNumber (this.trendLines [i].startValue, this.params.formatNumber, this.params.yAxisValueDecimals, false, this.params.formatNumberScale, this.params.defaultNumberScale, this.config.nsv, this.config.nsu, this.params.numberPrefix, this.params.numberSuffix));
			}
		}
		//Do the same for vertical trend lines too
		for (i = 0; i <= this.numVTrendLines; i ++)
		{
			//If the trend line start/end value is NaN or out of range
			if (isNaN (this.vTrendLines [i].startValue) || (this.vTrendLines [i].startValue < this.config.xMin) || (this.vTrendLines [i].startValue > this.config.xMax) || isNaN (this.vTrendLines [i].endValue) || (this.vTrendLines [i].endValue < this.config.xMin) || (this.vTrendLines [i].endValue > this.config.xMax))
			{
				//Invalidate it
				this.vTrendLines [i].isValid = false;
			} else
			{
				//We resolve displayValue conflict
				this.vTrendLines [i].displayValue = getFV (this.vTrendLines [i].displayValue, "");
			}
		}
	}
	/**
	* calcCanvasCoords method calculates the co-ordinates of the canvas
	* taking into consideration everything that is to be drawn on the chart.
	* It finally stores the canvas as an object.
	*/
	private function calcCanvasCoords ()
	{
		//Loop variable
		var i : Number;
		//Based on label step, set showLabel of each data point as required.
		//Visible label count
		var visibleCount : Number = 0;
		var finalVisibleCount : Number = 0;
		for (i = 1; i <= this.numCat; i ++)
		{
			//Now, the label can be preset to be hidden (set via XML)
			if (this.categories [i].isValid && this.categories [i].showLabel)
			{
				visibleCount ++;
				//If label step is defined, we need to set showLabel of those
				//labels which fall on step as false.
				if ((i - 1) % this.params.labelStep == 0)
				{
					this.categories [i].showLabel = true;
				} else
				{
					this.categories [i].showLabel = false;
				}
			}
			//Update counter
			finalVisibleCount = (this.categories [i].showLabel) ? (finalVisibleCount + 1) : (finalVisibleCount);
		}
		//We now need to calculate the available Width on the canvas.
		//Available width = total Chart width minus the list below
		// - Left and Right Margin
		// - yAxisName (if to be shown)
		// - yAxisValues
		// - Trend line display values (both left side and right side).
		// - Legend (If to be shown at right)
		var canvasWidth : Number = this.width - (this.params.chartLeftMargin + this.params.chartRightMargin);
		//Set canvas startX
		var canvasStartX : Number = this.params.chartLeftMargin;
		//Now, if y-axis name is to be shown, simulate it and get the width
		if (this.params.yAxisName != "")
		{
			//Get style object
			var yAxisNameStyle : Object = this.styleM.getTextStyle (this.objects.YAXISNAME);
			if (this.params.rotateYAxisName)
			{
				//Create text field to get width
				var yAxisNameObj : Object = createText (true, this.params.yAxisName, this.tfTestMC, 1, testTFX, testTFY, 90, yAxisNameStyle, false, 0, 0);
				//Accomodate width and padding
				canvasStartX = canvasStartX + yAxisNameObj.width + this.params.yAxisNamePadding;
				canvasWidth = canvasWidth - yAxisNameObj.width - this.params.yAxisNamePadding;
				//Create element for yAxisName - to store width/height
				this.elements.yAxisName = returnDataAsElement (0, 0, yAxisNameObj.width, yAxisNameObj.height);
			} else
			{
				//If the y-axis name is not to be rotated
				//Calculate the width of the text if in full horizontal mode
				//Create text field to get width
				var yAxisNameObj : Object = createText (true, this.params.yAxisName, this.tfTestMC, 1, testTFX, testTFY, 0, yAxisNameStyle, false, 0, 0);
				//Get a value for this.params.yAxisNameWidth
				this.params.yAxisNameWidth = Number (getFV (this.params.yAxisNameWidth, yAxisNameObj.width));
				//Get the lesser of the width (to avoid un-necessary space)
				this.params.yAxisNameWidth = Math.min (this.params.yAxisNameWidth, yAxisNameObj.width);
				//Accomodate width and padding
				canvasStartX = canvasStartX + this.params.yAxisNameWidth + this.params.yAxisNamePadding;
				canvasWidth = canvasWidth - this.params.yAxisNameWidth - this.params.yAxisNamePadding;
				//Create element for yAxisName - to store width/height
				this.elements.yAxisName = returnDataAsElement (0, 0, this.params.yAxisNameWidth, yAxisNameObj.height);
			}
			delete yAxisNameStyle;
			delete yAxisNameObj;
		}
		//Accomodate width for y-axis values. Now, y-axis values conists of two parts
		//(for backward compatibility) - limits (upper and lower) and div line values.
		//So, we'll have to individually run through both of them.
		var yAxisValMaxWidth : Number = 0;
		var divLineObj : Object;
		var divStyle : Object = this.styleM.getTextStyle (this.objects.YAXISVALUES);
		//Iterate through all the div line values
		for (i = 1; i < this.divLines.length; i ++)
		{
			//If div line value is to be shown
			if (this.divLines [i].showValue)
			{
				//If it's the first or last div Line (limits), and it's to be shown
				if ((i == 1) || (i == this.divLines.length - 1))
				{
					if (this.params.showLimits)
					{
						//Get the width of the text
						divLineObj = createText (true, this.divLines [i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, divStyle, false, 0, 0);
						//Accomodate
						yAxisValMaxWidth = (divLineObj.width > yAxisValMaxWidth) ? (divLineObj.width) : (yAxisValMaxWidth);
					}
				} else
				{
					//It's a div interval - div line
					//So, check if we've to show div line values
					if (this.params.showDivLineValues)
					{
						//Get the width of the text
						divLineObj = createText (true, this.divLines [i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, divStyle, false, 0, 0);
						//Accomodate
						yAxisValMaxWidth = (divLineObj.width > yAxisValMaxWidth) ? (divLineObj.width) : (yAxisValMaxWidth);
					}
				}
			}
		}
		delete divLineObj;
		//Also iterate through all trend lines whose values are to be shown on
		//left side of the canvas.
		//Get style object
		var trendStyle : Object = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		var trendObj : Object;
		for (i = 1; i <= this.numTrendLines; i ++)
		{
			if (this.trendLines [i].isValid == true && this.trendLines [i].valueOnRight == false)
			{
				//If it's a valid trend line and value is to be shown on left
				//Get the width of the text
				trendObj = createText (true, this.trendLines [i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, trendStyle, false, 0, 0);
				//Accomodate
				yAxisValMaxWidth = (trendObj.width > yAxisValMaxWidth) ? (trendObj.width) : (yAxisValMaxWidth);
			}
		}
		//Accomodate for y-axis/left-trend line values text width
		if (yAxisValMaxWidth > 0)
		{
			canvasStartX = canvasStartX + yAxisValMaxWidth + this.params.yAxisValuesPadding;
			canvasWidth = canvasWidth - yAxisValMaxWidth - this.params.yAxisValuesPadding;
		}
		var trendRightWidth : Number = 0;
		//Now, also check for trend line values that fall on right
		for (i = 1; i <= this.numTrendLines; i ++)
		{
			if (this.trendLines [i].isValid == true && this.trendLines [i].valueOnRight == true)
			{
				//If it's a valid trend line and value is to be shown on right
				//Get the width of the text
				trendObj = createText (true, this.trendLines [i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, trendStyle, false, 0, 0);
				//Accomodate
				trendRightWidth = (trendObj.width > trendRightWidth) ? (trendObj.width) : (trendRightWidth);
			}
		}
		delete trendObj;
		//Accomodate trend right text width
		if (trendRightWidth > 0)
		{
			canvasWidth = canvasWidth - trendRightWidth - this.params.yAxisValuesPadding;
		}
		//Round them off finally to avoid distorted pixels
		canvasStartX = int (canvasStartX);
		canvasWidth = int (canvasWidth);
		//We finally have canvas Width and canvas Start X
		//-----------------------------------------------------------------------------------//
		//Now, we need to calculate the available Height on the canvas.
		//Available height = total Chart height minus the list below
		// - Chart Top and Bottom Margins
		// - Space for Caption, Sub Caption and caption padding
		// - Height of data labels
		// - xAxisName
		// - Vertical trend line values
		// - Legend (If to be shown at bottom position)
		//Initialize canvasHeight to total height minus margins
		var canvasHeight : Number = this.height - (this.params.chartTopMargin + this.params.chartBottomMargin);
		//Set canvasStartY
		var canvasStartY : Number = this.params.chartTopMargin;
		//Now, if we've to show caption
		if (this.params.caption != "")
		{
			//Create text field to get height
			var captionObj : Object = createText (true, this.params.caption, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle (this.objects.CAPTION) , true, canvasWidth, canvasHeight/4);
			//Store the height
			canvasStartY = canvasStartY + captionObj.height;
			canvasHeight = canvasHeight - captionObj.height;
			//Create element for caption - to store width & height
			this.elements.caption = returnDataAsElement (0, 0, captionObj.width, captionObj.height);
			delete captionObj;
		}
		//Now, if we've to show sub-caption
		if (this.params.subCaption != "")
		{
			//Create text field to get height
			var subCaptionObj : Object = createText (true, this.params.subCaption, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle (this.objects.SUBCAPTION) , true, canvasWidth, canvasHeight/4);
			//Store the height
			canvasStartY = canvasStartY + subCaptionObj.height;
			canvasHeight = canvasHeight - subCaptionObj.height;
			//Create element for sub caption - to store height
			this.elements.subCaption = returnDataAsElement (0, 0, subCaptionObj.width, subCaptionObj.height);
			delete subCaptionObj;
		}
		//Now, if either caption or sub-caption was shown, we also need to adjust caption padding
		if (this.params.caption != "" || this.params.subCaption != "")
		{
			//Account for padding
			canvasStartY = canvasStartY + this.params.captionPadding;
			canvasHeight = canvasHeight - this.params.captionPadding;
		}
		//Now, if data labels are to be shown, we need to account for their heights
		//Data labels can be rendered in 3 ways:
		//1. Normal - no staggering - no wrapping - no rotation
		//2. Wrapped - no staggering - no rotation
		//3. Staggered - no wrapping - no rotation
		//4. Rotated - no staggering - no wrapping
		//Placeholder to store max height
		this.config.maxLabelHeight = 0;
		this.config.labelAreaHeight = 0;
		var labelObj : Object;
		var labelStyleObj : Object = this.styleM.getTextStyle (this.objects.DATALABELS);
		if (this.params.labelDisplay == "ROTATE")
		{
			//Case 4: If the labels are rotated, we iterate through all the string labels
			//provided to us and get the height and store max.
			for (i = 1; i <= this.numCat; i ++)
			{
				//If the label is to be shown
				if (this.categories [i].isValid && this.categories [i].showLabel)
				{
					//Create text box and get height
					labelObj = createText (true, this.categories [i].label, this.tfTestMC, 1, testTFX, testTFY, this.config.labelAngle, labelStyleObj, false, 0, 0);
					//Store the larger
					this.config.maxLabelHeight = (labelObj.height > this.config.maxLabelHeight) ? (labelObj.height) : (this.config.maxLabelHeight);
				}
			}
			//Store max label height as label area height.
			this.config.labelAreaHeight = this.config.maxLabelHeight;
		} else if (this.params.labelDisplay == "WRAP")
		{
			//Case 2 (WRAP): Create all the labels on the chart. Set width as
			//totalAvailableWidth/finalVisibleCount.
			//Set max height as 50% of available canvas height at this point of time. Find all
			//and select the max one.
			var maxLabelWidth : Number = (canvasWidth / finalVisibleCount);
			var maxLabelHeight : Number = (canvasHeight / 2);
			//Store it in config for later usage
			this.config.wrapLabelWidth = maxLabelWidth;
			this.config.wrapLabelHeight = maxLabelHeight;
			for (i = 1; i <= this.numCat; i ++)
			{
				//If the label is to be shown
				if (this.categories [i].isValid && this.categories [i].showLabel)
				{
					//Create text box and get height
					labelObj = createText (true, this.categories [i].label, this.tfTestMC, 1, testTFX, testTFY, 0, labelStyleObj, true, maxLabelWidth, maxLabelHeight);
					//Store the larger
					this.config.maxLabelHeight = (labelObj.height > this.config.maxLabelHeight) ? (labelObj.height) : (this.config.maxLabelHeight);
				}
			}
			//Store max label height as label area height.
			this.config.labelAreaHeight = this.config.maxLabelHeight;
		} else
		{
			//Case 1,3: Normal or Staggered Label
			//We iterate through all the labels, and if any of them has &lt or < (HTML marker)
			//embedded in them, we add them to the array, as for them, we'll need to individually
			//create and see the text height. Also, the first element in the array - we set as
			//ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_=....
			//Create array to store labels.
			var strLabels : Array = new Array ();
			strLabels.push ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_=/*-+~`");
			//Now, iterate through all the labels and for those visible labels, whcih have < sign,
			//add it to array.
			for (i = 1; i <= this.numCat; i ++)
			{
				//If the label is to be shown
				if (this.categories [i].isValid && this.categories [i].showLabel)
				{
					if ((this.categories [i].label.indexOf ("&lt;") > - 1) || (this.categories [i].label.indexOf ("<") > - 1))
					{
						strLabels.push (this.categories [i].label);
					}
				}
			}
			//Now, we've the array for which we've to check height (for each element).
			for (i = 0; i < strLabels.length; i ++)
			{
				//Create text box and get height
				labelObj = createText (true, this.categories [i].label, this.tfTestMC, 1, testTFX, testTFY, 0, labelStyleObj, false, 0, 0);
				//Store the larger
				this.config.maxLabelHeight = (labelObj.height > this.config.maxLabelHeight) ? (labelObj.height) : (this.config.maxLabelHeight);
			}
			//We now have the max label height. If it's staggered, then store accordingly, else
			//simple mode
			if (this.params.labelDisplay == "STAGGER")
			{
				//Multiply max label height by stagger lines.
				this.config.labelAreaHeight = this.params.staggerLines * this.config.maxLabelHeight;
			} else
			{
				this.config.labelAreaHeight = this.config.maxLabelHeight;
			}
		}
		if (this.config.labelAreaHeight > 0)
		{
			//Deduct the calculated label height from canvas height
			canvasHeight = canvasHeight - this.config.labelAreaHeight - this.params.labelPadding;
		}
		//Delete objects
		delete labelObj;
		delete labelStyleObj;
		//If any vertical trend line values are to be shown
		var trendObj : Object;
		var trendStyle : Object = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		var trendHeight : Number = 0;
		//Now, also check for trend line values that fall on right
		this.config.vTrendHeight = 0;
		for (i = 1; i <= this.numVTrendLines; i ++)
		{
			if (this.vTrendLines [i].isValid == true)
			{
				//If it's a valid trend line
				//Get the height of the text
				trendObj = createText (true, this.vTrendLines [i].displayValue, this.tfTestMC, 1, testTFX, testTFY, 0, trendStyle, false, 0, 0);
				//Accomodate
				trendHeight = (trendObj.height > trendHeight) ? (trendObj.height) : (trendHeight);
			}
		}
		delete trendObj;
		//Accomodate
		if (trendHeight > 0)
		{
			canvasHeight = canvasHeight - trendHeight;
			//Store vertical trend line text height - will be used later to adjust x-axis name.
			this.config.vTrendHeight = trendHeight;
		}
		//Accomodate space for xAxisName (if to be shown);
		if (this.params.xAxisName != "")
		{
			//Create text field to get height
			var xAxisNameObj : Object = createText (true, this.params.xAxisName, this.tfTestMC, 1, testTFX, testTFY, 0, this.styleM.getTextStyle (this.objects.XAXISNAME) , false, 0, 0);
			//Store the height
			canvasHeight = canvasHeight - xAxisNameObj.height - this.params.xAxisNamePadding;
			//Object to store width and height of xAxisName
			this.elements.xAxisName = returnDataAsElement (0, 0, xAxisNameObj.width, xAxisNameObj.height);
			delete xAxisNameObj;
		}
		//We have canvas start Y and canvas height
		//We now check whether the legend is to be drawn
		if (this.params.showLegend)
		{
			//Object to store dimensions
			var lgndDim:Object;
			//Create container movie clip for legend
			this.lgndMC = this.cMC.createEmptyMovieClip ("Legend", this.dm.getDepth ("LEGEND"));
			//Create instance of legend
			if (this.params.legendPosition == "BOTTOM")
			{
				//Maximum Height - 50% of stage
				lgnd = new Legend (lgndMC, this.styleM.getTextStyle (this.objects.LEGEND) , this.params.legendPosition, canvasStartX + canvasWidth / 2, this.height / 2, canvasWidth, (this.height - (this.params.chartTopMargin + this.params.chartBottomMargin)) * 0.5, this.params.legendAllowDrag, this.width, this.height, this.params.legendBgColor, this.params.legendBgAlpha, this.params.legendBorderColor, this.params.legendBorderThickness, this.params.legendBorderAlpha, this.params.legendScrollBgColor, this.params.legendScrollBarColor, this.params.legendScrollBtnColor);
			} 
			else
			{
				//Maximum Width - 40% of stage
				lgnd = new Legend (lgndMC, this.styleM.getTextStyle (this.objects.LEGEND) , this.params.legendPosition, this.width / 2, canvasStartY + canvasHeight / 2, (this.width - (this.params.chartLeftMargin + this.params.chartRightMargin)) * 0.4, canvasHeight, this.params.legendAllowDrag, this.width, this.height, this.params.legendBgColor, this.params.legendBgAlpha, this.params.legendBorderColor, this.params.legendBorderThickness, this.params.legendBorderAlpha, this.params.legendScrollBgColor, this.params.legendScrollBarColor, this.params.legendScrollBtnColor);
			}
			//Feed data set series Name for legend
			if (this.params.reverseLegend){
				for (i = this.numDS; i >=1; i --)
				{
					if (this.dataset [i].includeInLegend && this.dataset [i].seriesName != "")
					{
						lgnd.addItem (this.dataset [i].seriesName, this.dataset [i].color);
					}
				}
			}else{
				for (i = 1; i <= this.numDS; i ++)
				{
					if (this.dataset [i].includeInLegend && this.dataset [i].seriesName != "")
					{
						lgnd.addItem (this.dataset [i].seriesName, this.dataset [i].color);
					}
				}
			}
			//If user has defined a caption for the legend, set it
			if (this.params.legendCaption!=""){
				lgnd.setCaption(this.params.legendCaption);
			}
			//Whether to use circular marker
			lgnd.useCircleMarker(this.params.legendMarkerCircle);
			if (this.params.legendPosition == "BOTTOM")
			{
				lgndDim = lgnd.getDimensions ();
				//Now deduct the height from the calculated canvas height
				canvasHeight = canvasHeight - lgndDim.height - this.params.legendPadding;
				//Re-set the legend position
				this.lgnd.resetXY (canvasStartX + canvasWidth / 2, this.height - this.params.chartBottomMargin - lgndDim.height / 2);
			} 
			else
			{
				//Get dimensions
				lgndDim = lgnd.getDimensions ();
				//Now deduct the width from the calculated canvas width
				canvasWidth = canvasWidth - lgndDim.width - this.params.legendPadding;
				//Right position
				this.lgnd.resetXY (this.width - this.params.chartRightMargin - lgndDim.width / 2, canvasStartY + canvasHeight / 2);
			}
		}
		//----------- HANDLING CUSTOM CANVAS MARGINS --------------//
		//Before doing so, we take into consideration, user's forced canvas margins (if any defined)
		//If the user's forced values result in overlapping of chart items, we ignore.
		if (this.params.canvasLeftMargin!=-1 && this.params.canvasLeftMargin>canvasStartX){
			//Update width (deduct the difference)
			canvasWidth = canvasWidth - (this.params.canvasLeftMargin-canvasStartX);
			//Update left start position
			canvasStartX = this.params.canvasLeftMargin;		
		}
		if (this.params.canvasRightMargin!=-1 && (this.params.canvasRightMargin>(this.width - (canvasStartX+canvasWidth)))){
			//Update width (deduct the difference)
			canvasWidth = canvasWidth - (this.params.canvasRightMargin-(this.width - (canvasStartX+canvasWidth)));			
		}
		if (this.params.canvasTopMargin!=-1 && this.params.canvasTopMargin>canvasStartY){
			//Update height (deduct the difference)
			canvasHeight = canvasHeight - (this.params.canvasTopMargin-canvasStartY);
			//Update top start position
			canvasStartY = this.params.canvasTopMargin;		
		}
		if (this.params.canvasBottomMargin!=-1 && (this.params.canvasBottomMargin>(this.height - (canvasStartY+canvasHeight)))){
			//Update height(deduct the difference)
			canvasHeight = canvasHeight - (this.params.canvasBottomMargin-(this.height - (canvasStartY+canvasHeight)));
		}
		//------------ END OF CUSTOM CANVAS MARGIN HANDLING --------------------//
		//Create an element to represent the canvas now.
		this.elements.canvas = returnDataAsElement (canvasStartX, canvasStartY, canvasWidth, canvasHeight);
	}
	/**
	* calcTrendLinePos method helps us calculate the y-co ordinates for the
	* trend lines
	* NOTE: validateTrendLines and calcTrendLinePos could have been composed
	*			into a single method. However, in calcTrendLinePos, we need the
	*			canvas position, which is possible only after calculatePoints
	*			method has been called. But, in calculatePoints, we need the
	*			displayValue of each trend line, which is being set in
	*			validateTrendLines. So, validateTrendLines is invoked before
	*			calculatePoints method and calcTrendLinePos is invoked after.
	*	@return		Nothing
	*/
	private function calcTrendLinePos ()
	{
		//Loop variable
		var i : Number;
		//Run for horizontal trend lines
		for (i = 0; i <= this.numTrendLines; i ++)
		{
			//We proceed only if the trend line is valid
			if (this.trendLines [i].isValid == true)
			{
				//Calculate and store y-positions
				this.trendLines [i].y = this.getAxisPosition (this.trendLines [i].startValue, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//If end value is different from start value
				if (this.trendLines [i].startValue != this.trendLines [i].endValue)
				{
					//Calculate y for end value
					this.trendLines [i].toY = this.getAxisPosition (this.trendLines [i].endValue, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Now, if it's a trend zone, we need mid value
					if (this.trendLines [i].isTrendZone)
					{
						//For textbox y position, we need mid value.
						this.trendLines [i].tbY = Math.min (this.trendLines [i].y, this.trendLines [i].toY) + (Math.abs (this.trendLines [i].y - this.trendLines [i].toY) / 2);
					} else
					{
						//If the value is to be shown on left, then at left
						if (this.trendLines [i].valueOnRight)
						{
							this.trendLines [i].tbY = this.trendLines [i].toY;
						} else
						{
							this.trendLines [i].tbY = this.trendLines [i].y;
						}
					}
					//Height
					this.trendLines [i].h = (this.trendLines [i].toY - this.trendLines [i].y);
				} else
				{
					//Just copy
					this.trendLines [i].toY = this.trendLines [i].y;
					//Set same position for value tb
					this.trendLines [i].tbY = this.trendLines [i].y;
					//Height
					this.trendLines [i].h = 0;
				}
			}
		}
		//Run for vertical trend lines
		for (i = 0; i <= this.numVTrendLines; i ++)
		{
			//We proceed only if the trend line is valid
			if (this.vTrendLines [i].isValid == true)
			{
				//Calculate and store x-positions
				this.vTrendLines [i].x = this.getAxisPosition (this.vTrendLines [i].startValue, this.config.xMax, this.config.xMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
				//If end value is different from start value
				if (this.vTrendLines [i].startValue != this.vTrendLines [i].endValue)
				{
					//Calculate x for end value
					this.vTrendLines [i].toX = this.getAxisPosition (this.vTrendLines [i].endValue, this.config.xMax, this.config.xMin, this.elements.canvas.x, this.elements.canvas.toX, false, 0);
					//Now, if it's a trend zone, we need mid value
					if (this.vTrendLines [i].isTrendZone)
					{
						//For textbox x position, we need mid value.
						this.vTrendLines [i].tbX = Math.min (this.vTrendLines [i].x, this.vTrendLines [i].toX) + (Math.abs (this.vTrendLines [i].x - this.vTrendLines [i].toX) / 2);
					} else
					{
						this.vTrendLines [i].tbX = this.vTrendLines [i].x;
					}
					//Width
					this.vTrendLines [i].w = (this.vTrendLines [i].toX - this.vTrendLines [i].x);
				} else
				{
					//Just copy
					this.vTrendLines [i].toX = this.vTrendLines [i].x;
					//Set same position for value tb
					this.vTrendLines [i].tbX = this.vTrendLines [i].x;
					//Width
					this.vTrendLines [i].w = 0;
				}
			}
		}
	}
	/**
	* feedMacros method feeds macros and their respective values
	* to the macro instance. This method is to be called after
	* calculatePoints, as we set the canvas and chart co-ordinates
	* in this method, which is known to us only after calculatePoints.
	*	@return	Nothing
	*/
	private function feedMacros () : Void
	{
		//Feed macros one by one
		//Chart dimension macros
		this.macro.addMacro ("$chartStartX", this.x);
		this.macro.addMacro ("$chartStartY", this.y);
		this.macro.addMacro ("$chartWidth", this.width);
		this.macro.addMacro ("$chartHeight", this.height);
		this.macro.addMacro ("$chartEndX", this.width);
		this.macro.addMacro ("$chartEndY", this.height);
		this.macro.addMacro ("$chartCenterX", this.width / 2);
		this.macro.addMacro ("$chartCenterY", this.height / 2);
		//Canvas dimension macros
		this.macro.addMacro ("$canvasStartX", this.elements.canvas.x);
		this.macro.addMacro ("$canvasStartY", this.elements.canvas.y);
		this.macro.addMacro ("$canvasWidth", this.elements.canvas.w);
		this.macro.addMacro ("$canvasHeight", this.elements.canvas.h);
		this.macro.addMacro ("$canvasEndX", this.elements.canvas.toX);
		this.macro.addMacro ("$canvasEndY", this.elements.canvas.toY);
		this.macro.addMacro ("$canvasCenterX", this.elements.canvas.x + (this.elements.canvas.w / 2));
		this.macro.addMacro ("$canvasCenterY", this.elements.canvas.y + (this.elements.canvas.h / 2));
	}
	// ----------------- VISUAL RENDERING METHODS ---------------- //
	/**
	* drawCanvas method renders the chart canvas.
	*	@return	Nothing
	*/
	private function drawCanvas () : Void
	{
		//Create a new movie clip container for canvas
		var canvasMC = this.cMC.createEmptyMovieClip ("Canvas", this.dm.getDepth ("CANVAS"));
		//Parse the color, alpha and ratio array
		var canvasColor : Array = ColorExt.parseColorList (this.params.canvasBgColor);
		var canvasAlpha : Array = ColorExt.parseAlphaList (this.params.canvasBgAlpha, canvasColor.length);
		var canvasRatio : Array = ColorExt.parseRatioList (this.params.canvasBgRatio, canvasColor.length);
		//Set border properties - not visible
		//canvasMC.lineStyle(this.params.canvasBorderThickness, parseInt(this.params.canvasBorderColor, 16), this.params.canvasBorderAlpha);
		canvasMC.lineStyle ();
		//Move to (-w/2, 0);
		canvasMC.moveTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
		//Create matrix object
		var matrix : Object = {
			matrixType : "box", w : this.elements.canvas.w, h : this.elements.canvas.h, x : - (this.elements.canvas.w / 2) , y : - (this.elements.canvas.h / 2) , r : MathExt.toRadians (this.params.canvasBgAngle)
		};
		//Start the fill.
		canvasMC.beginGradientFill ("linear", canvasColor, canvasAlpha, canvasRatio, matrix);
		//Draw the rectangle with center registration point
		canvasMC.lineTo (this.elements.canvas.w / 2, - (this.elements.canvas.h / 2));
		canvasMC.lineTo (this.elements.canvas.w / 2, this.elements.canvas.h / 2);
		canvasMC.lineTo ( - (this.elements.canvas.w / 2) , this.elements.canvas.h / 2);
		canvasMC.lineTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
		//Set the x and y position
		canvasMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
		canvasMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
		//End Fill
		canvasMC.endFill ();
		// --------------------------- DRAW CANVAS BORDER --------------------------//
		//Canvas Border
		if (this.params.canvasBorderAlpha > 0)
		{
			//Create a new movie clip container for canvas
			var canvasBorderMC = this.cMC.createEmptyMovieClip ("CanvasBorder", this.dm.getDepth ("CANVASBORDER"));
			//Set border properties
			canvasBorderMC.lineStyle (this.params.canvasBorderThickness, parseInt (this.params.canvasBorderColor, 16) , this.params.canvasBorderAlpha);
			//Move to (-w/2, 0);
			canvasBorderMC.moveTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
			//Draw the rectangle with center registration point
			canvasBorderMC.lineTo (this.elements.canvas.w / 2, - (this.elements.canvas.h / 2));
			canvasBorderMC.lineTo (this.elements.canvas.w / 2, this.elements.canvas.h / 2);
			canvasBorderMC.lineTo ( - (this.elements.canvas.w / 2) , this.elements.canvas.h / 2);
			canvasBorderMC.lineTo ( - (this.elements.canvas.w / 2) , - (this.elements.canvas.h / 2));
			//Set the x and y position
			canvasBorderMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
			canvasBorderMC._y = this.elements.canvas.y + this.elements.canvas.h / 2;
		}
		//Apply animation
		if (this.params.animation)
		{
			this.styleM.applyAnimation (canvasBorderMC, this.objects.CANVAS, this.macro, canvasBorderMC._x, - this.elements.canvas.w / 2, canvasBorderMC._y, - this.elements.canvas.h / 2, 100, 100, 100, null);
			this.styleM.applyAnimation (canvasMC, this.objects.CANVAS, this.macro, canvasMC._x, - this.elements.canvas.w / 2, canvasMC._y, - this.elements.canvas.h / 2, 100, 100, 100, null);
		}
		//Apply filters
		this.styleM.applyFilters (canvasMC, this.objects.CANVAS);
		clearInterval (this.config.intervals.canvas);
	}
	/**
	* drawTrendLines method draws the vertical trend lines on the chart
	* with their respective values.
	*/
	private function drawTrendLines () : Void
	{
		var trendFontObj : Object;
		var trendValueObj : Object;
		var lineBelowDepth : Number = this.dm.getDepth ("TRENDLINESBELOW");
		var valueBelowDepth : Number = this.dm.getDepth ("TRENDVALUESBELOW");
		var lineAboveDepth : Number = this.dm.getDepth ("TRENDLINESABOVE");
		var valueAboveDepth : Number = this.dm.getDepth ("TRENDVALUESABOVE");
		var lineDepth : Number;
		var valueDepth : Number;
		var tbAnimX : Number = 0;
		//Movie clip container
		var trendLineMC : MovieClip;
		//Get font
		trendFontObj = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		//Set vertical alignment
		trendFontObj.vAlign = "middle";
		//Delegate handler function
		var fnRollOver:Function;
		//Loop variable
		var i : Number;
		//Iterate through all the trend lines
		for (i = 1; i <= this.numTrendLines; i ++)
		{
			if (this.trendLines [i].isValid == true)
			{
				//If it's a valid trend line
				//Get the depth and update counters
				if (this.trendLines [i].showOnTop)
				{
					//If the trend line is to be shown on top.
					lineDepth = lineAboveDepth;
					valueDepth = valueAboveDepth;
					lineAboveDepth ++;
					valueAboveDepth ++;
				} else
				{
					//If it's to be shown below columns.
					lineDepth = lineBelowDepth;
					valueDepth = valueBelowDepth;
					lineBelowDepth ++;
					valueBelowDepth ++;
				}
				trendLineMC = this.cMC.createEmptyMovieClip ("TrendLine_" + i, lineDepth);
				//Now, draw the line or trend zone
				if (this.trendLines [i].isTrendZone)
				{
					//Create rectangle
					trendLineMC.lineStyle ();
					//Absolute height value
					this.trendLines [i].h = Math.abs (this.trendLines [i].h);
					//We need to align rectangle at L,M
					trendLineMC.moveTo (0, 0);
					//Begin fill
					trendLineMC.beginFill (parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Draw rectangle
					trendLineMC.lineTo (0, - (this.trendLines [i].h / 2));
					trendLineMC.lineTo (this.elements.canvas.w, - (this.trendLines [i].h / 2));
					trendLineMC.lineTo (this.elements.canvas.w, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, (this.trendLines [i].h / 2));
					trendLineMC.lineTo (0, 0);
					//Re-position
					trendLineMC._x = this.elements.canvas.x;
					trendLineMC._y = this.trendLines [i].tbY;
				} else
				{
					//If the tooltext is to be shown for this trend line and the thickness is less than 3 pixels
					//we increase the hit area to 4 pixels with 0 alpha.
					if (this.params.showToolTip && (this.trendLines[i].toolText != "") && (this.trendLines [i].thickness < 4)) {
						//Set line style with alpha 0
						trendLineMC.lineStyle (4, parseInt (this.trendLines [i].color, 16) , 0);
						//Draw the hit area
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.elements.canvas.w, this.trendLines [i].h);
					}					
					//Just draw line
					trendLineMC.lineStyle (this.trendLines [i].thickness, parseInt (this.trendLines [i].color, 16) , this.trendLines [i].alpha);
					//Now, if dashed line is to be drawn
					if ( ! this.trendLines [i].isDashed)
					{
						//Draw normal line line keeping 0,0 as registration point
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.elements.canvas.w, this.trendLines [i].h);
					} else
					{
						//Dashed Line line
						DrawingExt.dashTo (trendLineMC, 0, 0, this.elements.canvas.w, this.trendLines [i].h, this.trendLines [i].dashLen, this.trendLines [i].dashGap);
					}
					//Re-position line
					trendLineMC._x = this.elements.canvas.x;
					trendLineMC._y = this.trendLines [i].y;
				}
				//Set the trend line tool-text
				if (this.params.showToolTip && this.trendLines[i].toolText != "") {
					//Do not use hand cursor
					trendLineMC.useHandCursor = false;
					//Create Delegate for roll over function showToolTip
					fnRollOver = Delegate.create (this, showToolTip);
					//Set the tool text
					fnRollOver.toolText = this.trendLines[i].toolText;
					//Assing the delegates to movie clip handler
					trendLineMC.onRollOver = fnRollOver;
					//Set roll out and mouse move too.
					trendLineMC.onRollOut = trendLineMC.onReleaseOutside = Delegate.create (this, hideToolTip);
					trendLineMC.onMouseMove = Delegate.create (this, repositionToolTip);
				}
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendLineMC, this.objects.TRENDLINES, this.macro, null, 0, trendLineMC._y, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendLineMC, this.objects.TRENDLINES);
				//---------------------------------------------------------------------------//
				//Set color
				trendFontObj.color = this.trendLines [i].color;
				//Now, render the trend line value, based on its position
				if (this.trendLines [i].valueOnRight == false)
				{
					//Value to be placed on right
					trendFontObj.align = "right";
					//Create text
					trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.elements.canvas.x - this.params.yAxisValuesPadding, this.trendLines [i].tbY, 0, trendFontObj, false, 0, 0);
					//X-position for text box animation
					tbAnimX = this.elements.canvas.x - this.params.yAxisValuesPadding - trendValueObj.width;
				} else
				{
					//Left side
					trendFontObj.align = "left";
					//Create text
					trendValueObj = createText (false, this.trendLines [i].displayValue, this.cMC, valueDepth, this.elements.canvas.toX + this.params.yAxisValuesPadding, this.trendLines [i].tbY, 0, trendFontObj, false, 0, 0);
					//X-position for text box animation
					tbAnimX = this.elements.canvas.toX + this.params.yAxisValuesPadding;
				}
				//Animation and filter effect
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendValueObj.tf, this.objects.TRENDVALUES, this.macro, tbAnimX, 0, this.trendLines [i].tbY - (trendValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendValueObj.tf, this.objects.TRENDVALUES);
			}
		}
		delete trendLineMC;
		delete trendValueObj;
		delete trendFontObj;
		//Clear interval
		clearInterval (this.config.intervals.trend);
	}
	/**
	* drawVTrendLines method draws the vertical trend lines on the chart
	* with their respective values.
	*/
	private function drawVTrendLines () : Void
	{
		var trendFontObj : Object;
		var trendValueObj : Object;
		var lineDepth : Number = this.dm.getDepth ("VTRENDLINES");
		var valueDepth : Number = this.dm.getDepth ("VTRENDVALUES");
		var tbAnimY : Number = 0;
		//Movie clip container
		var trendLineMC : MovieClip;
		//Get font
		trendFontObj = this.styleM.getTextStyle (this.objects.TRENDVALUES);
		//Set vertical alignment
		trendFontObj.align = "center";
		trendFontObj.vAlign = "bottom";
		//Delegate handler function
		var fnRollOver:Function;
		//Loop variable
		var i : Number;
		//Iterate through all the trend lines
		for (i = 1; i <= this.numVTrendLines; i ++)
		{
			if (this.vTrendLines [i].isValid == true)
			{
				//If it's a valid trend line
				trendLineMC = this.cMC.createEmptyMovieClip ("VTrendLine_" + i, lineDepth);
				if (this.vTrendLines [i].isTrendZone)
				{
					//Create rectangle
					trendLineMC.lineStyle ();
					//Absolute width value
					this.vTrendLines [i].w = Math.abs (this.vTrendLines [i].w);
					//We need to align rectangle at C,B
					trendLineMC.moveTo (0, 0);
					//Begin fill
					trendLineMC.beginFill (parseInt (this.vTrendLines [i].color, 16) , this.vTrendLines [i].alpha);
					//Draw rectangle
					trendLineMC.lineTo ( - (this.vTrendLines [i].w / 2) , 0);
					trendLineMC.lineTo ( - (this.vTrendLines [i].w / 2) , this.elements.canvas.h);
					trendLineMC.lineTo (this.vTrendLines [i].w / 2, this.elements.canvas.h);
					trendLineMC.lineTo (this.vTrendLines [i].w / 2, 0);
					trendLineMC.lineTo ( - (this.vTrendLines [i].w / 2) , 0);
					//Re-position
					trendLineMC._x = this.vTrendLines [i].tbX;
					trendLineMC._y = this.elements.canvas.y;
				} else
				{
					//If the tooltext is to be shown for this trend line and the thickness is less than 3 pixels
					//we increase the hit area to 4 pixels with 0 alpha.
					if (this.params.showToolTip && (this.vTrendLines[i].toolText != "") && (this.vTrendLines [i].thickness < 4)) {
						//Set line style with alpha 0
						trendLineMC.lineStyle (4, parseInt (this.vTrendLines [i].color, 16) , 0);
						//Draw the hit area
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.vTrendLines [i].w, this.elements.canvas.h);
					}
					//Just draw line
					trendLineMC.lineStyle (this.vTrendLines [i].thickness, parseInt (this.vTrendLines [i].color, 16) , this.vTrendLines [i].alpha);
					//Now, if dashed line is to be drawn
					if ( ! this.vTrendLines [i].isDashed)
					{
						//Draw normal line line keeping 0,0 as registration point
						trendLineMC.moveTo (0, 0);
						trendLineMC.lineTo (this.vTrendLines [i].w, this.elements.canvas.h);
					} else
					{
						//Dashed Line line
						DrawingExt.dashTo (trendLineMC, 0, 0, this.vTrendLines [i].w, this.elements.canvas.h, this.vTrendLines [i].dashLen, this.vTrendLines [i].dashGap);
					}
					//Re-position line
					trendLineMC._x = this.vTrendLines [i].x;
					trendLineMC._y = this.elements.canvas.y;
				}
				//Set the trend line tool-text
				if (this.params.showToolTip && this.vTrendLines[i].toolText != "") {
					//Do not use hand cursor
					trendLineMC.useHandCursor = false;
					//Create Delegate for roll over function showToolTip
					fnRollOver = Delegate.create (this, showToolTip);
					//Set the tool text
					fnRollOver.toolText = this.vTrendLines[i].toolText;
					//Assing the delegates to movie clip handler
					trendLineMC.onRollOver = fnRollOver;
					//Set roll out and mouse move too.
					trendLineMC.onRollOut = trendLineMC.onReleaseOutside = Delegate.create (this, hideToolTip);
					trendLineMC.onMouseMove = Delegate.create (this, repositionToolTip);
				}
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (trendLineMC, this.objects.VTRENDLINES, this.macro, trendLineMC._x, 0, null, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (trendLineMC, this.objects.VTRENDLINES);
				//---------------------------------------------------------------------------//
				//If text is to be shown
				if (this.vTrendLines [i].displayValue != "")
				{
					//Set color
					trendFontObj.color = this.vTrendLines [i].color;
					//Now, render the trend line value
					trendFontObj.align = "center";
					//Create text
					trendValueObj = createText (false, this.vTrendLines [i].displayValue, this.cMC, valueDepth, this.vTrendLines [i].tbX, this.elements.canvas.toY + this.params.labelPadding + this.config.maxLabelHeight, 0, trendFontObj, false, 0, 0);
					//Animation and filter effect
					if (this.params.animation)
					{
						this.styleM.applyAnimation (trendValueObj.tf, this.objects.TRENDVALUES, this.macro, trendValueObj.tf._x, 0, trendValueObj.tf._y, 0, 100, null, null, null);
					}
					//Apply filters
					this.styleM.applyFilters (trendValueObj.tf, this.objects.TRENDVALUES);
				}
				//Increment depths
				lineDepth ++;
				valueDepth ++;
			}
		}
		delete trendLineMC;
		delete trendValueObj;
		delete trendFontObj;
		//Clear interval
		clearInterval (this.config.intervals.vTrend);
	}
	/**
	* drawVLines method draws the vertical axis lines on the chart
	*/
	private function drawVLines () : Void
	{
		var depth : Number = this.dm.getDepth ("VLINES");
		//Movie clip container
		var vLineMC : MovieClip;
		//Loop var
		var i : Number;
		//Iterate through all the v div lines
		for (i = 1; i <= this.numCat; i ++)
		{
			if (this.categories [i].isValid && this.categories [i].showLine == true)
			{
				//If we've to show the line, create a movie clip
				vLineMC = this.cMC.createEmptyMovieClip ("vLine_" + i, depth);
				//Just draw line
				vLineMC.lineStyle (this.params.catVerticalLineThickness, parseInt (this.params.catVerticalLineColor, 16) , this.params.catVerticalLineAlpha);
				//Now, if dashed line is to be drawn
				if ( ! this.categories [i].lineDashed)
				{
					//Draw normal line line keeping 0,0 as registration point
					vLineMC.moveTo (0, 0);
					vLineMC.lineTo (0, - this.elements.canvas.h);
				} else
				{
					//Dashed Line line
					DrawingExt.dashTo (vLineMC, 0, 0, 0, - this.elements.canvas.h, this.params.catVerticalLineDashLen, this.params.catVerticalLineDashGap);
				}
				//Re-position line
				vLineMC._x = this.categories [i].x;
				vLineMC._y = this.elements.canvas.toY;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (vLineMC, this.objects.VLINES, this.macro, vLineMC._x, 0, vLineMC._y, 0, 100, null, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (vLineMC, this.objects.VLINES);
				//Increase depth
				depth ++;
			}
		}
		delete vLineMC;
		//Clear interval
		clearInterval (this.config.intervals.vLine);
	}
	/**
	* drawDivLines method draws the div lines on the chart
	*/
	private function drawDivLines () : Void
	{
		var divLineValueObj : Object;
		var divLineFontObj : Object;
		var yPos : Number;
		var depth : Number = this.dm.getDepth ("DIVLINES") - 1;
		//Movie clip container
		var divLineMC : MovieClip;
		//Get div line font
		divLineFontObj = this.styleM.getTextStyle (this.objects.YAXISVALUES);
		//Set alignment
		divLineFontObj.align = "right";
		divLineFontObj.vAlign = "middle";
		//Iterate through all the div line values
		var i : Number;
		for (i = 0; i < this.divLines.length; i ++)
		{
			//If it's the first or last div Line (limits), and limits are to be shown
			if ((i == 0) || (i == this.divLines.length - 1))
			{
				if (this.params.showLimits && this.divLines [i].showValue)
				{
					depth ++;
					//Get y position for textbox
					yPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Create the limits text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			} else if (this.divLines [i].value == 0)
			{
				//It's a zero value div line - check if we've to show
				if (this.params.showZeroPlane)
				{
					//Depth for zero plane
					var zpDepth : Number = this.dm.getDepth ("ZEROPLANE");
					//Depth for zero plane value
					var zpVDepth : Number = zpDepth ++;
					//Get y position
					yPos = this.getAxisPosition (0, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
					//Render the line
					var zeroPlaneMC = this.cMC.createEmptyMovieClip ("ZeroPlane", zpDepth);
					//Draw the line
					zeroPlaneMC.lineStyle (this.params.zeroPlaneThickness, parseInt (this.params.zeroPlaneColor, 16) , this.params.zeroPlaneAlpha);
					if (this.params.divLineIsDashed)
					{
						//Dashed line
						DrawingExt.dashTo (zeroPlaneMC, - this.elements.canvas.w / 2, 0, this.elements.canvas.w / 2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
					} else
					{
						//Draw the line keeping 0,0 as registration point
						zeroPlaneMC.moveTo ( - this.elements.canvas.w / 2, 0);
						//Normal line
						zeroPlaneMC.lineTo (this.elements.canvas.w / 2, 0);
					}
					//Re-position the div line to required place
					zeroPlaneMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
					zeroPlaneMC._y = yPos - (this.params.zeroPlaneThickness / 2);
					//Apply animation and filter effects to div line
					//Apply animation
					if (this.params.animation)
					{
						this.styleM.applyAnimation (zeroPlaneMC, this.objects.DIVLINES, this.macro, null, 0, zeroPlaneMC._y, 0, 100, 100, null, null);
					}
					//Apply filters
					this.styleM.applyFilters (zeroPlaneMC, this.objects.DIVLINES);
					//So, check if we've to show div line values
					if (this.params.showDivLineValues && this.divLines [i].showValue)
					{
						//Create the text
						divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, zpVDepth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
					}
					//Apply animation and filter effects to div line (y-axis) values
					if (this.divLines [i].showValue)
					{
						if (this.params.animation)
						{
							this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x - this.params.yAxisValuesPadding - divLineValueObj.width, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
						}
						//Apply filters
						this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
					}
				}
			} else
			{
				//It's a div interval - div line
				//Get y position
				yPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				//Render the line
				depth ++;
				divLineMC = this.cMC.createEmptyMovieClip ("DivLine_" + i, depth);
				//Draw the line
				divLineMC.lineStyle (this.params.divLineThickness, parseInt (this.params.divLineColor, 16) , this.params.divLineAlpha);
				if (this.params.divLineIsDashed)
				{
					//Dashed line
					DrawingExt.dashTo (divLineMC, - this.elements.canvas.w / 2, 0, this.elements.canvas.w / 2, 0, this.params.divLineDashLen, this.params.divLineDashGap);
				} else
				{
					//Draw the line keeping 0,0 as registration point
					divLineMC.moveTo ( - this.elements.canvas.w / 2, 0);
					//Normal line
					divLineMC.lineTo (this.elements.canvas.w / 2, 0);
				}
				//Re-position the div line to required place
				divLineMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
				divLineMC._y = yPos - (this.params.divLineThickness / 2);
				//Apply animation and filter effects to div line
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineMC, this.objects.DIVLINES, this.macro, null, 0, divLineMC._y, 0, 100, 100, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineMC, this.objects.DIVLINES);
				//So, check if we've to show div line values
				if (this.params.showDivLineValues && this.divLines [i].showValue)
				{
					//Increase Depth
					depth ++;
					//Create the text
					divLineValueObj = createText (false, this.divLines [i].displayValue, this.cMC, depth, this.elements.canvas.x - this.params.yAxisValuesPadding, yPos, 0, divLineFontObj, false, 0, 0);
				}
			}
			//Apply animation and filter effects to div line (y-axis) values
			if (this.divLines [i].showValue)
			{
				if (this.params.animation)
				{
					this.styleM.applyAnimation (divLineValueObj.tf, this.objects.YAXISVALUES, this.macro, this.elements.canvas.x - this.params.yAxisValuesPadding - divLineValueObj.width, 0, yPos - (divLineValueObj.height / 2) , 0, 100, null, null, null);
				}
				//Apply filters
				this.styleM.applyFilters (divLineValueObj.tf, this.objects.YAXISVALUES);
			}
		}
		delete divLineValueObj;
		delete divLineFontObj;
		//Clear interval
		clearInterval (this.config.intervals.divLines);
	}
	/**
	* drawHGrid method draws the horizontal grid background color
	*/
	private function drawHGrid () : Void
	{
		//If we're required to draw horizontal grid color
		//and numDivLines > 3
		if (this.params.showAlternateHGridColor && this.divLines.length > 3)
		{
			//Movie clip container
			var gridMC : MovieClip;
			//Loop variable
			var i : Number;
			//Get depth
			var depth : Number = this.dm.getDepth ("HGRID");
			//Y Position
			var yPos : Number, yPosEnd : Number;
			var height : Number;
			for (i = 1; i < this.divLines.length - 1; i = i + 2)
			{
				//Get y position
				yPos = this.getAxisPosition (this.divLines [i].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				yPosEnd = this.getAxisPosition (this.divLines [i + 1].value, this.config.yMax, this.config.yMin, this.elements.canvas.y, this.elements.canvas.toY, true, 0);
				height = yPos - yPosEnd;
				//Create the movie clip
				gridMC = this.cMC.createEmptyMovieClip ("GridBg_" + i, depth);
				//Set line style to null
				gridMC.lineStyle ();
				//Set fill color
				gridMC.moveTo ( - (this.elements.canvas.w / 2) , - (height / 2));
				gridMC.beginFill (parseInt (this.params.alternateHGridColor, 16) , this.params.alternateHGridAlpha);
				//Draw rectangle
				gridMC.lineTo (this.elements.canvas.w / 2, - (height / 2));
				gridMC.lineTo (this.elements.canvas.w / 2, height / 2);
				gridMC.lineTo ( - (this.elements.canvas.w / 2) , height / 2);
				gridMC.lineTo ( - (this.elements.canvas.w / 2) , - (height / 2));
				//End Fill
				gridMC.endFill ();
				//Place it in right location
				gridMC._x = this.elements.canvas.x + this.elements.canvas.w / 2;
				gridMC._y = yPos - (height) / 2;
				//Apply animation
				if (this.params.animation)
				{
					this.styleM.applyAnimation (gridMC, this.objects.HGRID, this.macro, null, 0, gridMC._y, 0, 100, 100, 100, null);
				}
				//Apply filters
				this.styleM.applyFilters (gridMC, this.objects.HGRID);
				//Increase depth
				depth ++;
			}
		}
		//Clear interval
		clearInterval (this.config.intervals.hGrid);
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
		//Initialize the number of data elements present
		this.numDS = 0;
		this.num = 0;
		this.numCat = 0;
		//Re-set indexes to 0
		this.numTrendLines = 0;
		this.numTrendLinesBelow = 0;
		this.numVTrendLines = 0;
		//Re-create container arrays
		this.categories = new Array ();
		this.dataset = new Array ();
		this.divLines = new Array ();
		this.trendLines = new Array ();
		this.vTrendLines = new Array ();
		//Reset the legend
		this.lgnd.reset ();
	}
	/**
	* remove method removes the chart by clearing the chart movie clip
	* and removing any listeners.
	*/
	public function remove () : Void
	{
		super.remove ();
		//Remove legend.
		this.lgnd.destroy ();
		lgndMC.removeMovieClip ();
	}
}
