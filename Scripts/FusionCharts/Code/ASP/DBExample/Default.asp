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
<h4>Click on any pie slice to see detailed data.</h4>
<p class='text'>Or, right click on any pie to enable slicing or rotation mode. </p>
<%
	'In this example, we show how to connect FusionCharts to a database.
	'For the sake of ease, we've used an Access database which is present in
	'../DB/FactoryDB.mdb. It just contains two tables, which are linked to each
	'other. 
		
	'Database Objects - Initialization
	Dim oRs, oRs2, strQuery
	'strXML will be used to store the entire XML document generated
	Dim strXML
	
	'We also keep a flag to specify whether we've to animate the chart or not.
	'If the user is viewing the detailed chart and comes back to this page, he shouldn't
	'see the animation again.
	Dim animateChart
	animateChart = Request.QueryString("animate")
	'Set default value of 1
	if animateChart="" then
		animateChart = "1"
	end if
	
	'Create the recordset to retrieve data
	Set oRs = Server.CreateObject("ADODB.Recordset")

	'Generate the chart element
	strXML = "<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation=' " & animateChart & "'>"
	
	'Iterate through each factory
	strQuery = "select * from Factory_Master"
	Set oRs = oConn.Execute(strQuery)
	
	While Not oRs.Eof
		'Now create second recordset to get details for this factory
		Set oRs2 = Server.CreateObject("ADODB.Recordset")
		strQuery = "select sum(Quantity) as TotOutput from Factory_Output where FactoryId=" & ors("FactoryId")
		Set oRs2 = oConn.Execute(strQuery)				
		'Generate <set label='..' value='..' link='..' />
		'Note that we're setting link as Detailed.asp?FactoryId=<<FactoryId>>
		strXML = strXML & "<set label='" & ors("FactoryName") & "' value='" & ors2("TotOutput") & "' link='" & Server.URLEncode("Detailed.asp?FactoryId=" & ors("FactoryId")) & "'/>"
		'Close recordset
		Set oRs2 = Nothing
		oRs.MoveNext
	Wend
	'Finally, close <chart> element
	strXML = strXML & "</chart>"
	Set oRs = nothing
	
	'Create the chart - Pie 3D Chart with data from strXML
	Call renderChart("../../FusionCharts/Pie3D.swf", "", strXML, "FactorySum", 600, 300, false, false)	
%>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>