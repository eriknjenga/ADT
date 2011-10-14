<?php

  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");

  # Create Column 2D chart Object 
  $FC = new FusionCharts("Column2D","450","350");
    
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Set colon (:) as delimiter
  $FC->setParamDelimiter(":");

  # Define chart attributes  
  $strParam="caption=Weekly Sales:xAxisName=Week:yAxisName=Revenue:numberPrefix=$";
  
  # Set chart attributes
  $FC->setChartParams($strParam);

  # add chart values and category names
  $FC->addChartData("40800","label=Week 1:alpha=80");
  $FC->addChartData("31400","label=Week 2:alpha=60");
  $FC->addChartData("26700","label=Week 3");
  $FC->addChartData("54400","label=Week 4");
  
  # Set hash (#) as delimiter
  $FC->setParamDelimiter("#");
  # Add TrendLine
  $FC->addTrendLine("startValue=42000#color=ff0000#displayvalue=Target#showOnTop=1");
  
  # Set semicolon (;) as delimiter
  $FC->setParamDelimiter(";");
  
  # Add TrendLine
  $FC->addTrendLine("startValue=30000;color=008800;displayvalue=Average;showOnTop=1");
  
  
?>
<html>
  <head>
    <title>First Chart - Set Delimiter : Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>

