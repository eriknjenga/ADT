<?php
  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");

  # Create Bubble chart Object 
  $FC = new FusionCharts("bubble","450","350");
    
  # set the relative path of the swf file
  $FC->setSwfPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Monthly Sales;xAxisName=Number of Products;yAxisName=Revenue;numberPrefix=$";
  
  # Set chart attributes
  $FC->setChartParams($strParam);
  
  # Add Category, 1st parameter take label and 2nd parameter takes x axis value 
  # as parameter list  
  $FC->addCategory("0","x=0;showVerticalLine=1");
  $FC->addCategory("20","x=20;showVerticalLine=1");
  $FC->addCategory("40","x=40;showVerticalLine=1");
  $FC->addCategory("60","x=60;showVerticalLine=1");
  $FC->addCategory("80","x=80;showVerticalLine=1");
  $FC->addCategory("100","x=100;showVerticalLine=1");
  
  # Add a new dataset
  $FC->addDataSet("Previous Month");
  # Add chart data for the above dataset
  # where 1st parameter for X axis value
  # 2nd parameter take Y and Z axis as parameter list
  # e.g y=12200;z=10
  $FC->addChartData("20","y=72000;z=8");
  $FC->addChartData("43","y=42000;z=5");
  $FC->addChartData("70","y=90000;z=2");
  $FC->addChartData("90","y=75000;z=4");
  
  # Add another dataset
  $FC->addDataSet("Current Month");
  # Add chart data for the above dataset
  # where 1st parameter for X axis value
  # 2nd parameter take Y and Z axis as parameter list
  # e.g y=12200;z=10
  $FC->addChartData("18","y=22000;z=3");
  $FC->addChartData("35","y=62000;z=5");
  $FC->addChartData("50","y=55000;z=10");
  $FC->addChartData("70","y=25000;z=3");

?>
<html>
  <head>
    <title>Bubble Chart : Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>

