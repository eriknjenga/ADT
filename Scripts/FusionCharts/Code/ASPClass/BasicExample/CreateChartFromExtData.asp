<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
  'We've included ../Includes/FusionCharts_Gen.asp, which contains FusionCharts ASP Class
  'to help us easily embed the charts.
%>
<!--#include file="../Includes/FusionCharts_Gen.asp"-->
<HTML>
<HEAD>
	<TITLE>
	FusionCharts V3 - Simple Column 3D Chart (with XML data hard-coded in ASP page itself)
	</TITLE>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
	<%
	'You need to include the following JS file, if you intend to embed the chart using JavaScript.
	'Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	'When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	%>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
</HEAD>
<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> Examples</h2>
<h4>Simple Column 3D Chart (with XML data hard-coded in ASP page itself)</h4>
<%
	
	'This page demonstrates the ease of generating charts using FusionCharts ASP Class.
	'For this chart, we've used a string variable to contain our entire XML data.
	
	'Ideally, you would generate XML data documents at run-time, after interfacing with
	'forms or databases etc.Such examples are also present.
	'Here, we've kept this example very simple.
	
	'Create an XML data document in a string variable
	dim strXML
	strXML = "<graph caption='Monthly Unit Sales' xAxisName='Month' yAxisName='Units' >"
	strXML = strXML &  "<set label='Jan' value='462' />"
	strXML = strXML &  "<set label='Feb' value='857' />"
	strXML = strXML &  "<set label='Mar' value='671' />"
	strXML = strXML &  "<set label='Apr' value='494' />"
	strXML = strXML &  "<set label='May' value='761' />"
	strXML = strXML &  "<set label='Jun' value='960' />"
	strXML = strXML &  "<set label='Jul' value='629' />"
	strXML = strXML &  "<set label='Aug' value='622' />"
	strXML = strXML &  "<set label='Sep' value='376' />"
	strXML = strXML &  "<set label='Oct' value='494' />"
	strXML = strXML &  "<set label='Nov' value='761' />"
	strXML = strXML &  "<set label='Dec' value='960' />"
	strXML = strXML &  "</graph>"

	
	dim FC
	' Create First FusionCharts ASP class object
	set FC = new FusionCharts
	' Set chart type to Column3D
	call FC.setChartType("Column3D")
	' Set chart size
	call FC.setSize("600","300")
	
	' Set Relative Path of swf file. default path is charts/
 	call FC.setSWFPath("../../FusionCharts/")
	' Create the chart - Column 3D Chart with data from strXML 
	' Create the Chart 
 	call FC.renderChartFromExtXML(strXML,false)
%>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>