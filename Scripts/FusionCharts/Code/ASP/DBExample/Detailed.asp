<%@ Language=VBScript %>
<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Database and Drill-Down Example
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
	<%
	'We've included ../Includes/FusionCharts.asp, which contains functions
	'to help us easily embed the charts.
	%>
	<!-- #INCLUDE FILE="../Includes/FusionCharts.asp" -->
	<!-- #INCLUDE FILE="../Includes/DBConn.asp" -->
<BODY>

<CENTER>
<h2>FusionCharts Database and Drill-Down Example</h2>
<h4>Detailed report for the factory</h4>
<%
	'This page is invoked from Default.asp. When the user clicks on a pie
	'slice in Default.asp, the factory Id is passed to this page. We need
	'to get that factory id, get information from database and then show
	'a detailed chart.
	
	'First, get the factory Id
	Dim FactoryId
	'Request the factory Id from Querystring
	FactoryId = Request.QueryString("FactoryId")
	
	Dim oRs, strQuery
	'strXML will be used to store the entire XML document generated
	Dim strXML, intCounter	
	intCounter = 0
	
	Set oRs = Server.CreateObject("ADODB.Recordset")
	'Generate the chart element string
	strXML = "<chart palette='2' caption='Factory " & FactoryId &" Output ' subcaption='(In Units)' xAxisName='Date' showValues='1' labelStep='2' >"
	'Now, we get the data for that factory
	strQuery = "select * from Factory_Output where FactoryId=" & FactoryId
	Set oRs = oConn.Execute(strQuery)
	While Not oRs.Eof		
		'Here, we convert date into a more readable form for set label.
		strXML = strXML & "<set label='" & datePart("d",ors("DatePro")) & "/" & datePart("m",ors("DatePro")) & "' value='" & ors("Quantity") & "'/>"		
		Set oRs2 = Nothing
		oRs.MoveNext
	Wend
	'Close <chart> element
	strXML = strXML & "</chart>"
	Set oRs = nothing
	
	'Create the chart - Column 2D Chart with data from strXML
	Call renderChart("../../FusionCharts/Column2D.swf", "", strXML, "FactoryDetailed", 600, 300, false, false)
%>
<BR>
<a href='Default.asp?animate=0'>Back to Summary</a>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>