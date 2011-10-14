<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Simple Column 3D Chart using dataXML method
	</TITLE>
	<!---
	You need to include the following JS file, if you intend to embed the chart using JavaScript.
	Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	--->	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
</HEAD>
<!---
We've included ../Includes/FusionCharts.cfm, which contains functions
to help us easily embed the charts.
--->
<cfinclude template="../Includes/FusionCharts.cfm">
<BODY>

<CENTER>
<h2>FusionCharts Examples</h2>
<h4>Basic example using dataXML method (with XML data hard-coded in CFM page itself)</h4>
<p>If you view the source of this page, you'll see that the XML data is present in this same page (inside HTML code). We're not calling any external XML (or script) files to serve XML data. dataXML method is ideal when you've to plot small amounts of data.</p>
<!---
	This page demonstrates the ease of generating charts using FusionCharts.
	For this chart, we've used a string variable to contain our entire XML data.
	
	Ideally, you would generate XML data documents at run-time, after interfacing with
	forms or databases etc.Such examples are also present.
	Here, we've kept this example very simple.
	
	Create an XML data document in a string variable
--->
	<cfset strXML = "">
	<cfset strXML = strXML & "<chart caption='Monthly Unit Sales' xAxisName='Month' yAxisName='Units' showValues='0' formatNumberScale='0' showBorder='1'>">
	<cfset strXML = strXML & "<set label='Jan' value='462' />">
	<cfset strXML = strXML & "<set label='Feb' value='857' />">
	<cfset strXML = strXML & "<set label='Mar' value='671' />">
	<cfset strXML = strXML & "<set label='Apr' value='494' />">
	<cfset strXML = strXML & "<set label='May' value='761' />">
	<cfset strXML = strXML & "<set label='Jun' value='960' />">
	<cfset strXML = strXML & "<set label='Jul' value='629' />">
	<cfset strXML = strXML & "<set label='Aug' value='622' />">
	<cfset strXML = strXML & "<set label='Sep' value='376' />">
	<cfset strXML = strXML & "<set label='Oct' value='494' />">
	<cfset strXML = strXML & "<set label='Nov' value='761' />">
	<cfset strXML = strXML & "<set label='Dec' value='960' />">
	<cfset strXML = strXML & "</chart>">
	
	<!--- Create the chart - Column 3D Chart with data from strXML variable using dataXML method --->
	<cfoutput>#renderChart("../../FusionCharts/Column3D.swf", "", strXML, "myNext", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>