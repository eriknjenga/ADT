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
'We've included ../Includes/FusionCharts.cfm, which contains functions
'to help us easily embed the charts.
--->
<cfinclude template="../Includes/FusionCharts.cfm">
<BODY>

<CENTER>
<h2>FusionCharts Database and Drill-Down Example</h2>
<h4>Detailed report for the factory</h4>
<!---
	This page is invoked from Default.cfm. When the user clicks on a pie
	slice in Default.cfm, the factory Id is passed to this page. We need
	to get that factory id, get information from database and then show
	a detailed chart.
--->
	
	<cfset FactoryId = URL.FactoryId>
	
	<!--- Generate the chart element string --->
	<cfset strXML = "<chart palette='2' caption='Factory " & FactoryId &" Output ' subcaption='(In Units)' xAxisName='Date' showValues='1' labelStep='2' >">

	<!--- Now, we get the data for that factory --->
	<cfquery name="qry" datasource="dev">
		select * from Factory_Output where FactoryId=#FactoryId#
	</cfquery>

	<cfloop query="qry">
		<cfset strXML = strXML & "<set label='" & datePart("d",qry.DatePro) & "/" & datePart("m",qry.DatePro) & "' value='" & qry.Quantity & "'/>">
	</cfloop>	

	<!--- Finally, close <chart> element --->
	<cfset strXML = strXML & "</chart>">
		
	<!--- Create the chart - Column 2D Chart with data from strXML --->
	<cfoutput>#renderChart("../../FusionCharts/Column2D.swf", "", strXML, "FactoryDetailed", 600, 300, false, false)#</cfoutput>
<BR>
<a href='Default.cfm?animate=0'>Back to Summary</a>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>