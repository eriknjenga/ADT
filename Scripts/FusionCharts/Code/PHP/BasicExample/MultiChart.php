<?php
//We've included ../Includes/FusionCharts.php, which contains functions
//to help us easily embed the charts.
include("../Includes/FusionCharts.php");
?>
<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Multiple Charts on one Page
	</TITLE>
	<?php
	//You need to include the following JS file, if you intend to embed the chart using JavaScript.
	//Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	//When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	?>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
</HEAD>
<BODY>

<CENTER>
<h2>FusionCharts Examples</h2>
<h4>Multiple Charts on the same page. Each chart has a unique ID.</h4>
<?php
	
	//This page demonstrates how you can show multiple charts on the same page.
	//For this example, all the charts use the pre-built Data.xml (contained in /Data/ folder)
	//However, you can very easily change the data source for any chart. 
	
	//IMPORTANT NOTE: Each chart necessarily needs to have a unique ID on the page.
	//If you do not provide a unique Id, only the last chart might be visible.
	//Here, we've used the ID chart1, chart2 and chart3 for the 3 charts on page.
	
	//Create the chart - Column 3D Chart with data from Data/Data.xml
	echo renderChart("../../FusionCharts/Column3D.swf", "Data/Data.xml", "", "chart1", 600, 300, false, false);
?>
	<BR><BR>
<?php	
	//Now, create a Column 2D Chart
	echo renderChart("../../FusionCharts/Column2D.swf", "Data/Data.xml", "", "chart2", 600, 300, false, false);
?>
	<BR><BR>
<?php	
	//Now, create a Line 2D Chart
	echo renderChart("../../FusionCharts/Line.swf", "Data/Data.xml", "", "chart3", 600, 300, false, false);
?>

<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the charts above?</a>
</CENTER>
</BODY>
</HTML>