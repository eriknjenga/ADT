<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<HTML>
	<HEAD>
		<META http-equiv="Content-Type" content="text/html;charset=UTF-8"/> 
		<TITLE>FusionCharts - UTF8 日本語 (Japanese) Example</TITLE>
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
			<h2>FusionCharts UTF8 日本語 (Japanese) Example</h2>
			<h4>Basic Example using data from pre-built JapaneseData.xml</h4>
			<%
				/*
				In this example, we show how to use UTF characters in charts created with FusionCharts 
				Here, the XML data for the chart is present in Data/JapaneseData.xml. 
				The xml file should be created and saved with an editor
				which places the UTF8 BOM. The first line of the xml should contain the
				xml declaration like this: <?xml version="1.0" encoding="UTF-8" ?>
				*/
				/*
				The pageEncoding and chartSet headers for the page have been set to UTF-8
				in the first line of this jsp file.
				*/
					
				//Variable to contain dataURL
				String strDataURL = "Data/JapaneseData.xml";
				
				//Create the chart - Pie 3D Chart with dataURL as strDataURL
			%> 
			<jsp:include page="../Includes/FusionChartsRenderer.jsp" flush="true"> 
							<jsp:param name="chartSWF" value="../../FusionCharts/Column3D.swf" /> 
							<jsp:param name="strURL" value="<%=strDataURL%>" /> 
							<jsp:param name="strXML" value="" /> 
							<jsp:param name="chartId" value="JapaneseChart" /> 
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