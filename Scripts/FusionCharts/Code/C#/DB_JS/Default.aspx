<%@ Page Language="C#" AutoEventWireup="false" CodeFile="Default.aspx.cs"
    Inherits="DB_JS_Default" %>

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
		//Here, we use a mix of server side script (ASP.NET) and JavaScript to
		//render our data for factory chart in JavaScript variables. We'll later
		//utilize this data to dynamically plot charts.
		
		//All our data is stored in the data array. From ASP.NET, we iterate through
		//each recordset of data and then store it as nested arrays in this data array.
		var data = new Array();
		//Write the data as JavaScript variables here
		<%=GetScript()%>
		
		
		//The data is now present as arrays in JavaScript. Local JavaScript functions
		//can access it and make use of it. We'll see how to make use of it.
		
		
		/** 
		 * updateChart method is invoked when the user clicks on a pie slice.
		 * In this method, we get the index of the factory, build the XML data
		 * for that that factory, using data stored in data array, and finally
		 * update the Column Chart.
		 *	@param	factoryIndex	Sequential Index of the factory.
		*/		
		function updateChart(factoryIndex){
			//Storage for XML data document
			var strXML = "<chart palette='2' caption='Factory " + factoryIndex  + " Output ' subcaption='(In Units)' xAxisName='Date (dd/MM)' showValues='1' labelStep='2' >";
			
			//Add <set> elements
			var i=0;
			for (i=0; i<data[factoryIndex].length; i++){
				strXML = strXML + "<set label='" + data[factoryIndex][i][0] + "' value='" + data[factoryIndex][i][1] + "' />";
			}
			
			//Closing Chart Element
			strXML = strXML + "</chart>";
						
			//Get reference to chart object using Dom ID "FactoryDetailed"
			var chartObj = getChartFromId("FactoryDetailed");
			//Update it's XML
			chartObj.setDataXML(strXML);
		}
    </script>

</head>
<body>
    <center>
        <form id='form1' name='form1' method='post' runat="server">
            <h2>
                FusionCharts Database + JavaScript Example</h2>
            <h4>
                Inter-connected charts - Click on any pie slice to
                see detailed chart below.</h4>
            <p>
                The charts in this page have been dynamically generated
                using data contained in a database. We've NOT hard-coded
                the data in JavaScript.</p>
            <%=GetFactorySummayChartHtml()%>
            <br>
            <%=GetFactoryDetailedChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see
                the chart above?</a>
        </form>
    </center>
</body>
</html>
