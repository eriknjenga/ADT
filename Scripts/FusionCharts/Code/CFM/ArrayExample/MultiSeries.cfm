<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Array Example using Multi Series Column 3D Chart
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
<h4>Plotting multi-series chart from data contained in Array.</h4>
	<!---
	In this example, we plot a multi series chart from data contained
	in an array. The array will have three columns - first one for data label (product)
	and the next two for data values. The first data value column would store sales information
	for current year and the second one for previous year.
	--->
	
	<!---
	Let's store the sales data for 6 products in our array. We also store
	the name of products. 
	--->
	<cfset arrData = arrayNew(2)>
	<!--- Store Name of Products --->
	<cfset arrData[1][1] = "Product A">
	<cfset arrData[2][1] = "Product B">
	<cfset arrData[3][1] = "Product C">
	<cfset arrData[4][1] = "Product D">
	<cfset arrData[5][1] = "Product E">
	<cfset arrData[6][1] = "Product F">
	<!--- Store sales data --->
	<cfset arrData[1][2] = 567500>
	<cfset arrData[2][2] = 815300>
	<cfset arrData[3][2] = 556800>
	<cfset arrData[4][2] = 734500>
	<cfset arrData[5][2] = 676800>
	<cfset arrData[6][2] = 648500>
	<!--- 'Store sales data for previous year --->
	<cfset arrData[1][3] = 547300>
	<cfset arrData[2][3] = 584500>
	<cfset arrData[3][3] = 754000>
	<cfset arrData[4][3] = 456300>
	<cfset arrData[5][3] = 754500>
	<cfset arrData[6][3] = 437600>

	<!---
	Now, we need to convert this data into multi-series XML. 
	We convert using string concatenation.
	strXML - Stores the entire XML
	strCategories - Stores XML for the <categories> and child <category> elements
	strDataCurr - Stores XML for current year's sales
	strDataPrev - Stores XML for previous year's sales
	--->

	<cfset strXML = "<chart caption='Sales by Product' numberPrefix='$' formatNumberScale='1' rotateValues='1' placeValuesInside='1' decimals='0' >">
	
	<!--- Initialize <categories> element - necessary to generate a multi-series chart --->
	<cfset strCategories = "<categories>">
	
	<!--- Initiate <dataset> elements --->
	<cfset strDataCurr = "<dataset seriesName='Current Year'>">
	<cfset strDataPrev = "<dataset seriesName='Previous Year'>">
	
	<!--- Iterate through the data --->	
	<cfloop from="1" to="#arrayLen(arrData)#" index="i">
		<!--- Append <category name='...' /> to strCategories --->
		<cfset strCategories = strCategories & "<category name='" & arrData[i][1] & "' />">
		<!--- Add <set value='...' /> to both the datasets --->
		<cfset strDataCurr = strDataCurr & "<set value='" & arrData[i][2] & "' />">
		<cfset strDataPrev = strDataPrev & "<set value='" & arrData[i][3] & "' />">	
	</cfloop>
	
	<!--- Close <categories> element --->
	<cfset strCategories = strCategories & "</categories>">
	
	<!--- Close <dataset> elements --->
	<cfset strDataCurr = strDataCurr & "</dataset>">
	<cfset strDataPrev = strDataPrev & "</dataset>">
	
	<!--- Assemble the entire XML now --->
	<cfset strXML = strXML & strCategories & strDataCurr & strDataPrev & "</chart>">
	
	<!--- Create the chart - MS Column 3D Chart with data contained in strXML --->
	<cfoutput>#renderChart("../../FusionCharts/MSColumn3D.swf", "", strXML, "productSales", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>