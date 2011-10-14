<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
'We've included ../Includes/FusionCharts_Gen.asp, which contains
'FusionCharts ASP Class to help us easily embed charts 
'We've also used ../Includes/DBConn.asp to easily connect to a database
%>
<!--#include file="../Includes/DBConn.asp"-->
<!--#include file="../Includes/FusionCharts_Gen.asp"-->
<HTML>
<HEAD>
	<TITLE>
	FusionCharts V3 - Database and Drill-Down Example
	</TITLE>
	<%
	'You need to include the following JS file, if you intend to embed the chart using JavaScript.
	'Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	'When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	%>	
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
<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> - Database and Drill-Down Example</h2>
<h4>Detailed report for the factory</h4>
<%
    'This page is invoked from Default.asp. When the user clicks on a pie
    'slice in Default.asp, the factory Id is passed to this page. We need
    'to get that factory id, get information from database and then show
    'a detailed chart.

    'Request the factory Id from Querystring
    dim FactoryId
	FactoryId = Request("FactoryId")
	
	dim FC
	' Create FusionCharts ASP class object
 	set FC = new FusionCharts
	' Set chart type to Column 2D
	Call FC.setChartType("Column2D")
	' Set chart size 
	Call FC.setSize("600","300")

	' Set Relative Path of swf file.
 	Call FC.setSWFPath("../../FusionCharts/")
	
	dim strParam
	' Define chart attributes
	strParam="caption=Factory " & FactoryId & " Output;subcaption=(In Units);xAxisName=Date;rotateLabels=1;slantLabels=1"

 	' Set chart attributes
 	Call FC.setChartParams(strParam)
	   

    'Now, we get the data for that factory 
	'storing chart values in 'Quantity' column and category names in 'DDate'
	dim strQuery
    strQuery = "select Quantity, format(DatePro,'dd/MM/yyyy') as DDate from Factory_Output where FactoryId=" & FactoryId
    
	'For SQL Server 2000 Query
	'strQuery =  "select Quantity, convert(varchar,DatePro,103) as DDate from Factory_Output where FactoryId=" & FactoryId
	
	Dim oRs
	'Create the recordset to retrieve data
    Set oRs = Server.CreateObject("ADODB.Recordset")
	Set oRs = oConn.Execute(strQuery)
	    
    'Pass the SQL query result to the FusionCharts ASP Class' function 
    'that will extract data from database and add to the chart.
    if not oRs.bof then
       Call FC.addDataFromDatabase(oRs, "Quantity", "DDate","","")
    end if

    oRs.Close
	set oRs=Nothing
    'Create the chart
 	Call FC.renderChart(false)
%>
<BR>
<a href='Default.asp'>Back to Summary</a>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>