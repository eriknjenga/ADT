<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Array Example using Stacked Column 3D Chart
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
<h4>Plotting Stacked Chart from data contained in Array.</h4>
	<!---
	In this example, we plot a Stacked chart from data contained
	in an array. The array will have three columns - first one for Quarter Name
	and the next two for data values. The first data value column would store sales information
	for Product A and the second one for Product B.
	--->
	
	<cfset arrDaya = ArrayNew(2)>
		
	<!--- Store Name of Products --->
	<cfset arrData[1][1] = "Quarter 1">
	<cfset arrData[2][1] = "Quarter 2">
	<cfset arrData[3][1] = "Quarter 3">
	<cfset arrData[4][1] = "Quarter 4">
	<!--- Sales data for Product A --->
	<cfset arrData[1][2] = 567500>
	<cfset arrData[2][2] = 815300>
	<cfset arrData[3][2] = 556800>
	<cfset arrData[4][2] = 734500>
	<!--- Sales data for Product B --->
	<cfset arrData[1][3] = 547300>
	<cfset arrData[2][3] = 594500>
	<cfset arrData[3][3] = 754000>
	<cfset arrData[4][3] = 456300>

	<!---
	Now, we need to convert this data into multi-series XML. 
	We convert using string concatenation.
	strXML - Stores the entire XML
	strCategories - Stores XML for the <categories> and child <category> elements
	strDataProdA - Stores XML for current year's sales
	strDataProdB - Stores XML for previous year's sales
	--->
	
	<!--- Initialize <chart> element --->
	<cfset strXML = "<chart caption='Sales' numberPrefix='$' formatNumberScale='0'>">
	
	<!--- Initialize <categories> element - necessary to generate a stacked chart --->
	<cfset strCategories = "<categories>">
	
	<!--- Initiate <dataset> elements --->
	<cfset strDataProdA = "<dataset seriesName='Product A'>">
	<cfset strDataProdB = "<dataset seriesName='Product B'>">
	
	<!--- Iterate through the data --->	
	<cfloop from="1" to="#arrayLen(arrData)#" index="i">
		<!--- Append <category name='...' /> to strCategories --->
		<cfset strCategories = strCategories & "<category name='" & arrData[i][1] & "' />">
		<!--- Add <set value='...' /> to both the datasets --->
		<cfset strDataProdA = strDataProdA & "<set value='" & arrData[i][2] & "' />">
		<cfset strDataProdB = strDataProdB & "<set value='" & arrData[i][3] & "' />">	
	</cfloop>
	
	<!--- Close <categories> element --->
	<cfset strCategories = strCategories & "</categories>">
	
	<!--- Close <dataset> elements --->
	<cfset strDataProdA = strDataProdA & "</dataset>">
	<cfset strDataProdB = strDataProdB & "</dataset>">
	
	<!--- Assemble the entire XML now --->
	<cfset strXML = strXML & strCategories & strDataProdA & strDataProdB & "</chart>">
	
	<!--- Create the chart - Stacked Column 3D Chart with data contained in strXML --->
	<cfoutput>#renderChart("../../FusionCharts/StackedColumn3D.swf", "", strXML, "productSales", 500, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>