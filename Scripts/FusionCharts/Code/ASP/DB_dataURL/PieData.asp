<%@ Language=VBScript %>

<!-- #INCLUDE FILE="../Includes/DBConn.asp" -->
<%
	'This page generates the XML data for the Pie Chart contained in
	'Default.asp. 	
	
	'For the sake of ease, we've used an Access database which is present in
	'../DB/FactoryDB.mdb. It just contains two tables, which are linked to each
	'other. 
		
	'Database Objects - Initialization
	Dim oRs, oRs2, strQuery
	'strXML will be used to store the entire XML document generated
	Dim strXML
	
	'Default.asp has passed us a property animate. We request that.
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
		'Generate <set label='..' value='..'/>		
		strXML = strXML & "<set label='" & ors("FactoryName") & "' value='" & ors2("TotOutput") & "' />"
		'Close recordset
		Set oRs2 = Nothing
		oRs.MoveNext
	Wend
	'Finally, close <chart> element
	strXML = strXML & "</chart>"
	Set oRs = nothing
		
	'Set Proper output content-type
	Response.ContentType = "text/xml"
	
	'Just write out the XML data
	'NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
	Response.Write(strXML)
%>
