<%@ page import ="com.fusioncharts.FusionChartsHelper"%>
<% // We have imported the above file for using encodeDataURL method
%>
<%@ include file="../Includes/DBConn.jsp"%>

<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Date"%>
<HTML>
<HEAD>
<TITLE>FusionCharts - Database and Drill-Down Example</TITLE>
<%
	/*You need to include the following JS file, if you intend to embed the chart using JavaScript.
	Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	*/
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
<h2>FusionCharts Database and Drill-Down Example</h2>
<h4>Click on any pie slice to see detailed data.</h4>
<p class='text'>Or, right click on any pie to enable slicing or
rotation mode.</p>
<%
	/*
	In this example, we show how to connect FusionCharts to a database.
	For the sake of ease, we've used an Access database which is present in
	../DB/FactoryDB.mdb. It just contains two tables, which are linked to each
	other. 
	*/
		
	//Database Objects - Initialization
	Statement st1=null,st2=null;
	ResultSet rs1=null,rs2=null;

	String strQuery="";

	//strXML will be used to store the entire XML document generated
	String strXML="";
	
	//We also keep a flag to specify whether we've to animate the chart or not.
	//If the user is viewing the detailed chart and comes back to this page, he shouldn't
	//see the animation again.
	String animateChart=null;
	animateChart = request.getParameter("animate");
	//Set default value of 1
	if(null==animateChart||animateChart.equals("")){
			animateChart = "1";
	}
	
	//Generate the chart element
	strXML = "<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation='" + animateChart + "'>";
	
	//Query to retrieve data
	strQuery = "select * from Factory_Master";
	st1=oConn.createStatement();
	rs1=st1.executeQuery(strQuery);
	
	String factoryId=null;
	String factoryName=null;
	String totalOutput="";
	String strDataURL="";
	
	while(rs1.next()) {
		factoryId=rs1.getString("FactoryId");
		factoryName=rs1.getString("FactoryName");
		strQuery = "select sum(Quantity) as TotOutput from Factory_Output where FactoryId=" + factoryId;
		st2=oConn.createStatement();

		rs2 = st2.executeQuery(strQuery);
		if(rs2.next()){
			totalOutput=rs2.getString("TotOutput");
		}
		// Encoding the URL since it has a parameter
		strDataURL = FusionChartsHelper.encodeDataURL("Detailed.jsp?FactoryId="+factoryId,"false",response);
		//Generate <set label='..' value='..'/>		
		strXML += "<set label='" + factoryName + "' value='" +totalOutput+ "' link='"+strDataURL+"' />";

		//Close recordset
		rs2=null;
		st2=null;
		}
		//Finally, close <chart> element
		strXML += "</chart>";
	
		//close resultset,statement,connection
	try {
		if(null!=rs1){
			rs1.close();
			rs1=null;
		}
	}catch(java.sql.SQLException e){
		 System.out.println("Could not close the resultset");
	}	
	try {
		if(null!=st1) {
			st1.close();
			st1=null;
		}
	}catch(java.sql.SQLException e){
		 System.out.println("Could not close the statement");
	}
	try {
		if(null!=oConn) {
		    oConn.close();
		    oConn=null;
		}
	}catch(java.sql.SQLException e){
		 System.out.println("Could not close the connection");
	}
	
	//Create the chart - Pie 3D Chart with data from strXML
%> 
							<jsp:include page="../Includes/FusionChartsRenderer.jsp" flush="true"> 
								<jsp:param name="chartSWF" value="../../FusionCharts/Pie3D.swf" /> 
								<jsp:param name="strURL" value="" /> 
								<jsp:param name="strXML" value="<%=strXML%>" /> 
								<jsp:param name="chartId" value="FactorySum" /> 
								<jsp:param name="chartWidth" value="600" /> 
								<jsp:param name="chartHeight" value="300" /> 
								<jsp:param name="debugMode" value="false" /> 	
								<jsp:param name="registerWithJS" value="false" /> 								
							</jsp:include>
<BR>
<BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a><BR>
<H5><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>