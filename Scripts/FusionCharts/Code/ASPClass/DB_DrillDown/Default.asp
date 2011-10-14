<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
'We've included ../Includes/FusionCharts_Gen.asp, which contains
'FusionCharts ASP Class to help us easily embed charts 
'We've also used ../Includes/DBConn.asp to easily connect to a database
%>
<!--#include file="../Includes/DBConn.asp"-->
<!--#include file="../Includes/FusionCharts_Gen.asp"-->
<HTML>
<HEAD>
	<TITLE>
	FusionCharts V3 - Database and Drill-Down Example
	</TITLE>
	<%
	'You need to include the following JS file, if you intend to embed the chart using JavaScript.
	'Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	'When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	%>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
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
</HEAD>
<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> - Database and Drill-Down Example</h2>
<h4>Click on any pie slice to see detailed data.</h4>

<%
    'In this example, we show how to connect FusionCharts to a database.
    'For the sake of ease, we've used an MySQL databases containing two
    'tables.

	dim FC
	' Create FusionCharts ASP class object
	set FC = new FusionCharts
	' Set chart type to Pie 3D
	Call FC.setChartType("Pie3D")
	' Set chart size 
	Call FC.setSize("650","450")
	
	' Set Relative Path of swf file.
 	Call FC.setSWFPath("../../FusionCharts/")
	
	dim strParam
	' Define chart attributes
   	strParam="caption=Factory Output report;subCaption=By Quantity;pieSliceDepth=30;showBorder=1; showLabels=1;numberSuffix= Units"

 	' Set chart attributes
 	Call FC.setChartParams(strParam)
	
  	' Fetch all factory records creating SQL query
	dim strQuery
	strQuery = "select a.FactoryID, b.FactoryName, sum(a.Quantity) as total from Factory_output a, Factory_Master b where a.FactoryId=b.FactoryId group by a.FactoryId,b.FactoryName"
	
	Dim oRs
	'Create the recordset to retrieve data
    Set oRs = Server.CreateObject("ADODB.Recordset")
	Set oRs = oConn.Execute(strQuery)
    
	'Pass the SQL query result and Drill-Down link format to ASP Class Function
	' this function will automatically add chart data from database
	'
	 'The last parameter passed i.e. "Detailed.asp?FactoryId=##FactoryID##"
	 'drill down link from the current chart
	 'Here, the link redirects to another ASP file Detailed.asp 
	 'with a query string variable -FactoryId
	 'whose value would be taken from the Query result created above.
	 'Any thing placed between ## and ## will be regarded 
	 'as a field/column name in the SQL query result.
	 'value from that column will be assingned as the query variable's value
	 'Hence, for each dataplot in the chart the resultant query variable's value
	 'will be different
	'
	if Not oRs.Bof then
		Call FC.addDataFromDatabase(oRs, "total", "FactoryName","","Detailed.asp?FactoryId=##FactoryID##")
	End If

    oRs.Close
	set oRs=Nothing
    
    'Create the chart 
 	Call FC.renderChart(false)
%>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>