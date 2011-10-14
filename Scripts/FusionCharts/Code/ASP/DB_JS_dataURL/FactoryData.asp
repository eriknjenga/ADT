<%@ Language=VBScript %>
<!-- #INCLUDE FILE="../Includes/DBConn.asp" -->
<%
	'This page is invoked from Default.asp. When the user clicks on a pie
	'slice in Default.asp, the factory Id is passed to this page. We need
	'to get that factory id, get information from database and then write XML.
	
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
	
	'Just write out the XML data
	'NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
	Response.Write(strXML)	
%>