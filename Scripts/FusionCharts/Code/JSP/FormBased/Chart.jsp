<HTML>
	<HEAD>
	<TITLE>FusionCharts - Form Based Data Charting Example</TITLE>
	<%
		/*
		You need to include the following JS file, if you intend to embed the chart using JavaScript.
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
		<h2>FusionCharts Form-Based Data Example</h2>
		<h4>Restaurant Sales Chart below</h4>
		<p class='text'>Click on any pie slice to see slicing effect. Or,
		right click on chart and choose "Enable Rotation", and then drag and
		rotate the chart.</p>
		<%
			
			//We first request the data from the form (Default.jsp)
			String strSoups="",strSalads="",strSandwiches="",strBeverages="",strDesserts="";
			
			strSoups = request.getParameter("Soups");
			strSalads = request.getParameter("Salads");
			strSandwiches = request.getParameter("Sandwiches");
			strBeverages = request.getParameter("Beverages");
			strDesserts   = request.getParameter("Desserts");
			
			//In this example, we're directly showing this data back on chart.
			//In your apps, you can do the required processing and then show the 
			//relevant data only.
			
			//Now that we've the data in variables, we need to convert this into XML.
			//The simplest method to convert data into XML is using string concatenation.	
			String strXML="";
			//Initialize <chart> element
			strXML = "<chart caption='Sales by Product Category' subCaption='For this week' showPercentValues='1' pieSliceDepth='30' showBorder='1'>";
			//Add all data
			strXML = strXML + "<set label='Soups' value='" + strSoups + "' />";
			strXML = strXML + "<set label='Salads' value='" + strSalads + "' />";
			strXML = strXML + "<set label='Sandwiches' value='" + strSandwiches + "' />";
			strXML = strXML + "<set label='Beverages' value='" + strBeverages + "' />";
			strXML = strXML + "<set label='Desserts' value='" + strDesserts + "' />";
			//Close <chart> element
			strXML = strXML + "</chart>";
			
			//Create the chart - Pie 3D Chart with data from strXML
		%>
									<jsp:include page="../Includes/FusionChartsRenderer.jsp" flush="true"> 
										<jsp:param name="chartSWF" value="../../FusionCharts/Pie3D.swf" /> 
										<jsp:param name="strURL" value="" /> 
										<jsp:param name="strXML" value="<%=strXML%>" /> 
										<jsp:param name="chartId" value="Sales" /> 
										<jsp:param name="chartWidth" value="500" /> 
										<jsp:param name="chartHeight" value="300" /> 
										<jsp:param name="debugMode" value="false" /> 	
										<jsp:param name="registerWithJS" value="false" /> 								
									</jsp:include>
		<a href='javascript:history.go(-1);'>Enter data again</a> <BR>
		<BR>
		<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a><BR>
		<H5><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
		</CENTER>
	</BODY>
</HTML>
