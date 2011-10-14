<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Simple Column 3D Chart
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
<h4>Basic example using pre-built Data.xml</h4>
<!---
	This page demonstrates the ease of generating charts using FusionCharts.
	For this chart, we've used a pre-defined Data.xml (contained in /Data/ folder)
	Ideally, you would NOT use a physical data file. Instead you'll have 
	your own CFM scripts virtually relay the XML data document. Such examples are also present.
	For a head-start, we've kept this example very simple.
--->
	
	<!--- Create the chart - Column 3D Chart with data from Data/Data.xml --->
	<cfoutput>#renderChart("../../FusionCharts/Column3D.swf", "Data/Data.xml", "", "myFirst", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>