<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Form Based Data Charting Example
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
	.text{
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
</HEAD>
<!---
'We've included ../Includes/FusionCharts.cfm, which contains functions
'to help us easily embed the charts.
--->
<cfinclude template="../Includes/FusionCharts.cfm">
<BODY>

<CENTER>
<h2>FusionCharts Form-Based Data Example</h2>
<h4>Restaurant Sales Chart below</h4>
<p class='text'>Click on any pie slice to see slicing effect. Or, right click on chart and choose "Enable Rotation", and then drag and rotate the chart.</p>
<!--- We first request the data from the form (Default.cfm) --->
	
	<cfset intSoups = Val(Form.Soups)>
	<cfset intSalads = Val(Form.Salads)>
	<cfset intSandwiches = Val(Form.Sandwiches)>
	<cfset intBeverages = Val(Form.Beverages)>
	<cfset intDesserts   = Val(Form.Desserts)>
	
	<!---
	In this example, we're directly showing this data back on chart.
	In your apps, you can do the required processing and then show the 
	relevant data only.
	
	Now that we've the data in variables, we need to convert this into XML.
	The simplest method to convert data into XML is using string concatenation.	
	--->

	<!--- Initialize <chart> element --->
	<cfset strXML = "<chart caption='Sales by Product Category' subCaption='For this week' showPercentValues='1' pieSliceDepth='30' showBorder='1'>">

	<!--- Add all data --->
	<cfset strXML = strXML & "<set label='Soups' value='" & intSoups & "' />">
	<cfset strXML = strXML & "<set label='Salads' value='" & intSalads & "' />">
	<cfset strXML = strXML & "<set label='Sandwiches' value='" & intSandwiches & "' />">
	<cfset strXML = strXML & "<set label='Beverages' value='" & intBeverages & "' />">
	<cfset strXML = strXML & "<set label='Desserts' value='" & intDesserts & "' />">

	<!--- Close <chart> element --->
	<cfset strXML = strXML & "</chart>">
	
	<!--- Create the chart - Pie 3D Chart with data from strXML --->
	<cfoutput>#renderChart("../../FusionCharts/Pie3D.swf", "", strXML, "Sales", 500, 300, false, false)#</cfoutput>
<a href='javascript:history.go(-1);'>Enter data again</a>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>