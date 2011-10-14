<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Database and Drill-Down Example
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
We've included ../Includes/FusionCharts.cfm, which contains functions
to help us easily embed the charts.
--->
<cfinclude template="../Includes/FusionCharts.cfm">
<BODY>

<CENTER>
<h2>FusionCharts Database and Drill-Down Example</h2>
<h4>Click on any pie slice to see detailed data.</h4>
<p class='text'>Or, right click on any pie to enable slicing or rotation mode. </p>
<!---
	In this example, we show how to connect FusionCharts to a database.
--->
		

	<!--- Default.cfm has passed us a property animate. We request that. --->
	<cfparam name="URL.animate" default="1">
	<cfset animateChart = URL.animate>
	
	<!--- Generate the chart element --->
	<cfset strXML = "<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation=' " & animateChart & "'>">
	
	<!--- Iterate through each factory --->
	<cfquery name="qry" datasource="dev">
		select * from Factory_Master
	</cfquery>
	
	<cfloop query="qry">
		<cfset factoryID = qry.FactoryId>
		<cfset factoryName = qry.FactoryName>
		<!--- Now get details for this factory --->
		<cfquery name="qryDetails" datasource="dev">
			select sum(Quantity) as TotOutput from Factory_Output where FactoryId=#factoryID#
		</cfquery>
		<!--- Generate <set label='..' value='..'/>	--->
		<cfset strXML = strXML & "<set label='#factoryName#' value='#qryDetails.totOutput#' link='" & URLEncodedFormat("Detailed.cfm?factoryID=#factoryID#") & "'/>">
	</cfloop>

	<!--- Finally, close <chart> element --->
	<cfset strXML = strXML & "</chart>">	
	
	<!--- Create the chart - Pie 3D Chart with data from strXML --->
	<cfoutput>#renderChart("../../FusionCharts/Pie3D.swf", "", strXML, "FactorySum", 600, 300, false, false)#</cfoutput>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>