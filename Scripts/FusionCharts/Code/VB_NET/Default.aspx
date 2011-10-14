<%@ Page Language="VB" AutoEventWireup="false" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<title>FusionCharts v3 - ASP.NET 2.0 VB Code Examples</title>

		<style type="text/css">
		
			#layout { text-align : center ; padding : 0px ; }
				
			#content-body { padding : 1px 0 1px 0;  }
			
			#header , #footer {
				text-align : center;
				border : 1px solid #745C92;
				background-color : #9D7FBD;
				font-family : "Trebuchet MS",Georgia, "Times New Roman";
				font-size : 36px;
				line-height : 65px;
				color : #fff;
				width : 790px;
			}
			
			#footer {
				font-family : Verdana, Arial, Helvetica, sans-serif;
				font-size : 12px; 
				line-height : 20px;
			}
			
			#content { 
				text-align : left;
				border : 1px solid #B7ACBF; 
				background-color : #EFEBF2; 
				width : 790px;
			}
		
			#content ul, a { 
				font-family : Verdana, Arial, Helvetica, sans-serif;
				font-size : 10px; 
				line-height : 26px; 
				color : #422863; 
				text-decoration : none;
			}
			
			a:hover { text-decoration : underline; color : #422863; }
			
			
			#content ul li { font-weight : bold; list-style : none; }
			
			#content ul li ul li {font-weight: normal; line-height : 22px; list-style : disc; }
			
			
		
		</style>
	</head>

	<body>
	<div id="layout">
	    <div id="header">FusionCharts v3 - ASP.NET 2.0 VB Samples</div>

		<div id="content-body">
		  <div id="content">
	   
			  <ul>
				  <li>Basic Examples
					<ul>
						<li><a href="BasicExample/BasicChart.aspx">Simple Column 3D Chart using data from XML File (dataURL method)</a>&nbsp;</li>
						<li><a href="BasicExample/BasicDataXML.aspx">Simple Column 3D Chart with XML data hard-coded in ASP.NET page (dataXML method) </a>&nbsp;</li>
						<li><a href="BasicExample/SimpleChart.aspx">JavaScript embedding using dataURL method</a>&nbsp;</li>
						<li><a href="BasicExample/dataXML.aspx">JavaScript Embedding using dataXML Method</a>&nbsp;</li>
						<li><a href="BasicExample/MultiChart.aspx">Multiple Charts on a single page</a>&nbsp;</li>
					</ul>
					
				  <li>Plotting Chart from Data Contained in Arrays
					<ul>
						<li><a href="ArrayExample/SingleSeries.aspx">Single Series Chart Example</a>&nbsp;</li>
						<li><a href="ArrayExample/MultiSeries.aspx">Multi Series Chart Example</a></li>
						<li><a href="ArrayExample/Stacked.aspx">Stacked Chart Example</a>&nbsp;</li>
						<li><a href="ArrayExample/Combination.aspx">Combination Chart Example</a></li>
					</ul>
				  
				  </li>
				  
				 <li>Form Based Example
				  <ul>
					  <li><a href="FormBased/Default.aspx">Plotting Charts from Data in Forms</a></li>
				   </ul>
				 </li>
				 
				 <li>Database Examples
				  <ul>
					<li><a href="DBExample/BasicDBExample.aspx">Database Example Using dataXML Method</a></li>
					<li><a href="DB_dataURL/Default.aspx">Database Example Using dataURL Method</a></li>
					<li><a href="DB_DrillDown/Default.aspx">Database and Drill-Down Example</a>&nbsp;</li>
				   </ul>
				 </li>
				 
				 <li>Client Side Dynamic Chart Examples
				   <ul>
						<li><a href="DB_JS/Default.aspx">Database + JavaScript (datXML method) Examples</a></li>
						<li><a href="DB_JS_dataURL/Default.aspx">Database + JavaScript (dataURL method) Example</a></li>
				   </ul>
				  </li>
				 
				  <li>ASP.NET AJAX UpdatePanel Examples
					<ul>
						<li><a href="UpdatePanel/Sample1.aspx">Update Panel (Server Side ASP.NET.AJAX)</a></li>
						<li><a href="UpdatePanel/Sample2.aspx">Update Panel (Client Side +Server Side ASP.NET.AJAX)</a></li>
					</ul>
				 </li>
				 
				 <li>Master Page Example			 
					<ul>
						<li><a href="MasterPage_Example/Default.aspx">Simple MasterPage</a></li>
					</ul>
				 </li>
			  </ul>
		    </div>
		  </div>
		  <div id="footer">&copy; 2009 InfoSoft Global (P) Ltd. All Rights Reserved</div>
	
	  	</div>
	</body>
</html>


