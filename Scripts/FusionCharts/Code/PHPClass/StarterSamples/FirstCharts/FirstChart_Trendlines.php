<?php
  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");

  # Create Column2D chart Object 
  $FC = new FusionCharts("column2D","300","250");
      
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Weekly Sales;xAxisName=Week;yAxisName=Revenue;numberPrefix=$";
  # Set chart attributes
  $FC->setChartParams($strParam);

  # add chart values and category names
  $FC->addChartData("40800","label=Week 1");
  $FC->addChartData("31400","label=Week 2");
  $FC->addChartData("26700","label=Week 3");
  $FC->addChartData("54400","label=Week 4");
  
  # Add First TrendLine
  $FC->addTrendLine("startValue=42000;color=ff0000");
  # Add Second TrendLine
  $FC->addTrendLine("startValue=30000;color=008800;displayvalue=Average;showOnTop=1");
  # Add  TrendZone
  $FC->addTrendLine("startValue=50000;endValue=60000;color=0000ff;alpha=20;displayvalue=Dream Sales;showOnTop=1;isTrendZone=1");
  
?>
<html>
  <head>
    <title>First Chart - Advanced - Add Trendlines : Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>

