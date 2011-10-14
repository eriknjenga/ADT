/*
 * Created on Oct 25, 2006
 * 
 */
package com.infosoftglobal.fusioncharts;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * Contains methods to add no cache string to a url,creating the charts.<br>
 * This class can be used to create chart xml given the swf filename and other<br> 
 * parameters.<br>
 * In order to use this class in your jsps,import this class and<br> 
 * call the appropriate method directly as follows:<br>
 * FusionChartsCreator.createChart(...);<br>
 * 
 * @deprecated Please use classes from com.fusioncharts package
 * 
 * @author InfoSoft Global (P) Ltd.
 * 
 */
public class FusionChartsCreator {

    /**
     * Adds additional string to the url to and encodes the parameters,<br>
     * so as to disable caching of data.<br>  
     * @param strDataURL -
     *                dataURL to be fed to chart
     * @return cachedURL - URL with the additional string added
     */

    public static String addCacheToDataURL(String strDataURL) {
	String cachedURL = strDataURL;
	// Add the no-cache string if required

	// We add ?FCCurrTime=xxyyzz
	// If the dataURL already contains a ?, we add &FCCurrTime=xxyyzz
	// We replace : with _, as FusionCharts cannot handle : in URLs
	Calendar nowCal = Calendar.getInstance();
	Date now = nowCal.getTime();
	SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH_mm_ss a");
	String strNow = sdf.format(now);

	try {

	    if (strDataURL.indexOf("?") > 0) {
		cachedURL = strDataURL + "&FCCurrTime="
		+ URLEncoder.encode(strNow, "UTF-8");
	    } else {
		cachedURL = strDataURL + "?FCCurrTime="
		+ URLEncoder.encode(strNow, "UTF-8");
	    }

	} catch (UnsupportedEncodingException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	    cachedURL = strDataURL + "?FCCurrTime=" + strNow;
	}

	return cachedURL;
    }

    /**
     * Creates the JavaScript + HTML code required to embed a chart.<br>
     * Uses the javascript FusionCharts class to create the chart by supplying <br>
     * the required parameters to it.<br>
     * Note: Only one of the parameters strURL or strXML has to be not null for this<br>
     * method to work. If both the parameters are provided then strURL is used for further processing.<br>
     * 
     * @param chartSWF -
     *                SWF File Name (and Path) of the chart which you intend
     *                to plot
     * @param strURL -
     *                If you intend to use dataURL method for this chart,
     *                pass the URL as this parameter. Else, set it to "" (in
     *                case of dataXML method)
     * @param strXML -
     *                If you intend to use dataXML method for this chart,
     *                pass the XML data as this parameter. Else, set it to ""
     *                (in case of dataURL method)
     * @param chartId -
     *                Id for the chart, using which it will be recognized in
     *                the HTML page. Each chart on the page needs to have a
     *                unique Id.
     * @param chartWidth -
     *                Intended width for the chart (in pixels)
     * @param chartHeight -
     *                Intended height for the chart (in pixels)
     * @param debugMode -
     *                Whether to start the chart in debug mode
     * @param registerWithJS -
     *                Whether to ask chart to register itself with
     *                JavaScript
     */
    public static String createChart(String chartSWF, String strURL,
	    String strXML, String chartId, int chartWidth, int chartHeight,
	    boolean debugMode, boolean registerWithJS) {
	StringBuffer strBuf = new StringBuffer();
	// First we create a new DIV for each chart. We specify the name of DIV
	// as "chartId"Div.
	// DIV names are case-sensitive.

	strBuf.append("\t\t<!-- START Script Block for Chart-->\n");
	strBuf.append("\t\t<div id='" + chartId + "Div' align='center'>\n");
	strBuf.append("\t\t\t\tChart.\n");

	/*
	 * The above text "Chart" is shown to users before the chart has started
	 * loading (if there is a lag in relaying SWF from server). This text is
	 * also shown to users who do not have Flash Player installed. You can
	 * configure it as per your needs.
	 */

	strBuf.append("\t\t</div>\n");

	/*
	 * Now, we create the chart using FusionCharts js class. Each chart's
	 * instance (JavaScript) Id is named as chart_"chartId".
	 */

	strBuf.append("\t\t<script type='text/javascript'>\n");
	// Instantiate the Chart
	Boolean registerWithJSBool = new Boolean(registerWithJS);
	Boolean debugModeBool = new Boolean(debugMode);
	int regWithJSInt = boolToNum(registerWithJSBool);
	int debugModeInt = boolToNum(debugModeBool);

	strBuf.append("\t\t\t\tvar chart_" + chartId + " = new FusionCharts('"
		+ chartSWF + "', '" + chartId + "', '" + chartWidth + "', '"
		+ chartHeight + "', '" + debugModeInt + "', '" + regWithJSInt
		+ "');\n");
	// Check whether we've to provide data using dataXML method or dataURL
	// method
	if (strXML.equals("")) {
	    strBuf.append("\t\t\t\t// Set the dataURL of the chart\n");
	    strBuf.append("\t\t\t\tchart_" + chartId + ".setDataURL(\"" + strURL
		    + "\");\n");
	} else {
	    strBuf.append("\t\t\t\t// Provide entire XML data using dataXML method\n");
	    strBuf.append("\t\t\t\tchart_" + chartId + ".setDataXML(\"" + strXML
		    + "\");\n");
	}
	strBuf.append("\t\t\t\t// Finally, render the chart.\n");
	strBuf.append("\t\t\t\tchart_" + chartId + ".render(\"" + chartId + "Div\");\n");
	strBuf.append("\t\t</script>\n");
	strBuf.append("\t\t<!--END Script Block for Chart-->\n");
	return strBuf.substring(0);
    }

    /**
     * Creates the object tag required to embed a chart.
     * Generates the object tag to embed the swf directly into the html page.<br>
     * Note: Only one of the parameters strURL or strXML has to be not null for this<br>
     * method to work. If both the parameters are provided then strURL is used for further processing.<br>
     *  
     * @param chartSWF -
     *                SWF File Name (and Path) of the chart which you intend
     *                to plot
     * @param strURL -
     *                If you intend to use dataURL method for this chart,
     *                pass the URL as this parameter. Else, set it to "" (in
     *                case of dataXML method)
     * @param strXML -
     *                If you intend to use dataXML method for this chart,
     *                pass the XML data as this parameter. Else, set it to ""
     *                (in case of dataURL method)
     * @param chartId -
     *                Id for the chart, using which it will be recognized in
     *                the HTML page. Each chart on the page needs to have a
     *                unique Id.
     * @param chartWidth -
     *                Intended width for the chart (in pixels)
     * @param chartHeight -
     *                Intended height for the chart (in pixels)
     * @param debugMode -
     *                Whether to start the chart in debug mode
     */
    public static String createChartHTML(String chartSWF, String strURL,
	    String strXML, String chartId, int chartWidth, int chartHeight,
	    boolean debugMode) { /*
	     * Generate the FlashVars string based
	     * on whether dataURL has been provided
	     * or dataXML.
	     */
	String strFlashVars = "";
	Boolean debugModeBool = new Boolean(debugMode);

	if (strXML.equals("")) {
	    // DataURL Mode
	    strFlashVars = "chartWidth=" + chartWidth + "&chartHeight="
	    + chartHeight + "&debugMode=" + boolToNum(debugModeBool)
	    + "&dataURL=" + strURL + "";
	} else {
	    // DataXML Mode
	    strFlashVars = "chartWidth=" + chartWidth + "&chartHeight="
	    + chartHeight + "&debugMode=" + boolToNum(debugModeBool)
	    + "&dataXML=" + strXML + "";
	}
	StringBuffer strBuf = new StringBuffer();

	strBuf.append("\t\t<!--START Code Block for Chart-->\n");
	strBuf
	.append("\t\t<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0' width='"
		+ chartWidth
		+ "' height='"
		+ chartHeight
		+ "' id='"
		+ chartId + "'>\n");
	strBuf.append("\t\t\t\t<param name='allowScriptAccess' value='always' />\n");
	strBuf.append("\t\t\t\t<param name='movie' value='" + chartSWF + "'/>\n");
	strBuf.append("\t\t\t\t<param name='FlashVars' value=\"" + strFlashVars
		+ "\" />\n");
	strBuf.append("\t\t\t\t<param name='quality' value='high' />\n");
	strBuf
	.append("\t\t\t\t<embed src='"
		+ chartSWF
		+ "' FlashVars=\""
		+ strFlashVars
		+ "\" quality='high' width='"
		+ chartWidth
		+ "' height='"
		+ chartHeight
		+ "' name='"
		+ chartId
		+ "' allowScriptAccess='always' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer' />\n");
	strBuf.append("\t\t</object>\n");
	strBuf.append("\t\t<!--END Code Block for Chart-->\n");
	return strBuf.substring(0);
    }

    /**
     * Converts a Boolean value to int value<br>
     * 
     * @param bool Boolean value which needs to be converted to int value 
     * @return int value correspoding to the boolean : 1 for true and 0 for false
     */
   public static int boolToNum(Boolean bool) {
	int num = 0;
	if (bool.booleanValue()) {
	    num = 1;
	}
	return num;
    }
}
