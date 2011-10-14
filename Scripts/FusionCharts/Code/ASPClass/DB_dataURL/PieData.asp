<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
    'We've included  ../Includes/DBConn.asp, which contains functions
    'to help us easily connect to a database.
%>
<!--#include file="../Includes/DBConn.asp"-->
<%
    'We've included ../Includes/FusionCharts_Gen.asp, which FusionCharts ASP Class
    'to help us easily embed the charts.
%>
<!--#include file="../Includes/FusionCharts_Gen.asp"-->
<%
    'This page generates the XML data for the Pie Chart contained in
    'Default.asp. 	
	
    'For the sake of ease, we've used an MySQL databases containing two
    'tables.. 
	    
	dim FC
	' Create FusionCharts ASP class object
 	set FC = new FusionCharts
	' Set chart type to Pie 3D
	Call FC.setChartType("Pie3D")
	
	' Set Relative Path of swf file.
 	Call FC.setSWFPath("../../FusionCharts/")
	
	dim strParam
	' Define chart attributes
  	strParam="caption=Factory Output report;subCaption=By Quantity;pieSliceDepth=30;showBorder=1;showLabels=1;numberSuffix= Units"
	
 	'Set chart attributes
 	Call FC.setChartParams(strParam)
	    
  	' Fetch all factory records usins SQL Query
	' Store chart data values in 'total' column/field and category names in 'FactoryName'
	dim strQuery
	strQuery = "select a.FactoryID, b.FactoryName, sum(a.Quantity) as total from Factory_output a, Factory_Master b where a.FactoryId=b.FactoryId group by a.FactoryId,b.FactoryName"
	
	Dim oRs
	'Create the recordset to retrieve data
    Set oRs = Server.CreateObject("ADODB.Recordset")
	Set oRs = oConn.Execute(strQuery)
    
	'Pass the SQL Query result to the FusionCharts ASP Class function 
	'along with field/column names that are storing chart values and corresponding category names
	'to set chart data from database
	If Not oRs.bof Then
		Call FC.addDataFromDatabase(oRs, "total", "FactoryName", "", "")
	End If
	oRs.Close
	set oRs=Nothing
   		
    'Set Proper output content-type
    Response.ContentType= "text/xml"
	
    'Just write out the XML data
    'NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
    Response.Write(FC.getXML())
%>
