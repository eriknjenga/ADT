<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Array Example using Single Series Column 3D Chart
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
<h4>Plotting single series chart from data contained in Array.</h4>

<!---
 	In this example, we plot a single series chart from data contained
	in an array. The array will have two columns - first one for data label
	and the next one for data values.
 --->
	
<!--- 
	Let's store the sales data for 6 products in our array). We also store
	the name of products. 
 --->
 	<cfset arrData = ArrayNew(2)>
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

	<!--- Now, we need to convert this data into XML. We convert using string concatenation. --->
	<cfset strXML = "<chart caption='Sales by Product' numberPrefix='$' formatNumberScale='0'>">
	<!--- Convert data to XML and append --->
	<cfloop from="1" to="#arrayLen(arrData)#" index="i">
		<cfset strXML = strXML & "<set label='" & arrData[i][1] & "' value='" & arrData[i][2] & "' />">
	</cfloop>
	<!--- Close <chart> element --->
	<cfset strXML = strXML & "</chart>">
	
	<!--- Create the chart - Column 3D Chart with data contained in strXML --->
	<cfoutput>#renderChart("../../FusionCharts/Column3D.swf", "", strXML, "productSales", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>