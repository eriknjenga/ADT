<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DB_JS_dataURL_Default" %>

<html>
<head>
    <title>FusionCharts - Database + JavaScript Example </title>
    <style type="text/css">
        <!--
        body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
        }
            .text{
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
        }
    -->
    </style>

    <script language="Javascript" src="../FusionCharts/FusionCharts.js">
		//You need to include the above JS file, if you intend to embed the chart using JavaScript.
		//Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
		//When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
    </script>

    <script language="JavaScript">
		
		/** 
		 * updateChart method is invoked when the user clicks on a pie slice.
		 * In this method, we get the index of the factory after which we request for XML data
		 * for that that factory from FactoryData.aspx, and finally
		 * update the Column Chart.
		 *	@param	factoryIndex	Sequential Index of the factory.
		*/		
		function updateChart(factoryIndex){		
			//DataURL for the chart
			var strURL = "FactoryData.aspx?factoryId=" + factoryIndex;
			
			//Sometimes, the above URL and XML data gets cached by the browser.
			//If you want your charts to get new XML data on each request,
			//you can add the following line:
			//strURL = strURL + "&currTime=" + getTimeForURL();
			//getTimeForURL method is defined below and needs to be included
			//This basically adds a ever-changing parameter which bluffs
			//the browser and forces it to re-load the XML data every time.
						
			//URLEncode it - NECESSARY.
			strURL = escape(strURL);
			
			var chartObj = new FusionCharts('../FusionCharts/Column2D.swf', 'FactoryDetailed', '600', '250', '0', '0');
			
			
			//Get reference to chart object using Dom ID "FactoryDetailed"
			var chartObj = getChartFromId("FactoryDetailed");
			
			//Send request for XML
			
			chartObj.setDataURL(strURL);
			
			
		}
		/**
		 * getTimeForURL method returns the current time 
		 * in a URL friendly format, so that it can be appended to
		 * dataURL for effective non-caching.
		*/
		function getTimeForURL(){
			var dt = new Date();
			var strOutput = "";
			strOutput = dt.getHours() + "_" + dt.getMinutes() + "_" + dt.getSeconds() + "_" + dt.getMilliseconds();
			return strOutput;
		}
    </script>

</head>
<body>
    <center>
        <form id='form1' name='form1' method='post' runat="server">
            <h2>
                FusionCharts Database + JavaScript (dataURL method) Example</h2>
            <h4>
                Inter-connected charts - Click on any pie slice to see detailed chart below.</h4>
            <p>
                The charts in this page have been dynamically generated using data contained in
                a database.</p>
            <%=GetFactorySummaryChartHtml()%>
            <br>
            <%=GetFactoryDetailedChartHtml()%>
            <br>
            <br>
            <h5>
            <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </form>
    </center>
</body>
</html>
