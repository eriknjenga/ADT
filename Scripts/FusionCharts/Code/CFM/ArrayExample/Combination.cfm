<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Array Example using Combination Column 3D Line Chart
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
<h4>Plotting Combination chart from data contained in Array.</h4>
	<!---
	In this example, we plot a Combination chart from data contained
	in an array. The array will have three columns - first one for Quarter Name
	second one for sales figure and third one for quantity. 
	--->
		
	<cfset arrData = ArrayNew(2)>
	<!--- Store Name of Products --->
	<cfset arrData[1][1] = "Quarter 1">
	<cfset arrData[2][1] = "Quarter 2">
	<cfset arrData[3][1] = "Quarter 3">
	<cfset arrData[4][1] = "Quarter 4">
	<!--- Sales data for Product A --->
	<cfset arrData[1][2] = 576000>
	<cfset arrData[2][2] = 448000>
	<cfset arrData[3][2] = 956000>
	<cfset arrData[4][2] = 734000>
	<!--- Sales data for Product B --->
	<cfset arrData[1][3] = 576>
	<cfset arrData[2][3] = 448>
	<cfset arrData[3][3] = 956>
	<cfset arrData[4][3] = 734>
	<!---
	Now, we need to convert this data into combination XML. 
	We convert using string concatenation.
	strXML - Stores the entire XML
	strCategories - Stores XML for the <categories> and child <category> elements
	strDataRev - Stores XML for current year's sales
	strDataQty - Stores XML for previous year's sales
	--->
	
	<!--- Initialize <chart> element --->
	<cfset strXML = "<chart palette='4' caption='Product A - Sales Details' PYAxisName='Revenue' SYAxisName='Quantity (in Units)' numberPrefix='$' formatNumberScale='0' showValues='0' decimals='0' >">
	
	<!--- Initialize <categories> element - necessary to generate a multi-series chart --->
	<cfset strCategories = "<categories>">
	<cfset strDataProdA = "">
	<cfset strDataProdB = "">	
	
	<!--- Initiate <dataset> elements --->
	<cfset strDataProdA = "<dataset seriesName='Revenue'>">
	<cfset strDataProdB = "<dataset seriesName='Quantity' parentYAxis='S'>">
	
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
	
	<!--- Create the chart - MS Column 3D Line Combination Chart with data contained in strXML --->
	<cfoutput>#renderChart("../../FusionCharts/MSColumn3DLineDY.swf", "", strXML, "productSales", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>