<?php
  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");

  # Create Scatter chart Object 
  $FC = new FusionCharts("Scatter","300","250");
    
  # set the relative path of the swf file
  $FC->setSwfPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Server Performance;yAxisName=Response Time (sec);xAxisName=Server Load (TPS)";
  
  # Set chart attributes
  $FC->setChartParams($strParam);
  
  # Add Category, 1st parameter take label and 2nd parameter takes x axis value 
  # as parameter list   
  $FC->addCategory("10","x=10;showVerticalLine=1");
  $FC->addCategory("20","x=20;showVerticalLine=1");
  $FC->addCategory("30","x=30;showVerticalLine=1");
  $FC->addCategory("40","x=40;showVerticalLine=1");
  $FC->addCategory("50","x=50");
  
  # Add a new dataset  
  $FC->addDataSet("Server 1","anchorRadius=6");
  # Add chart data for the above dataset
  # where 1st parameter for X axis value
  # 2nd parameter take Y axis as parameter list
  # e.g y=27
  $FC->addChartData("21","y=2.4");
  $FC->addChartData("32","y=3.5");
  $FC->addChartData("43","y=2.5");
  $FC->addChartData("48","y=4.1");
  
  # Add another dataset
  $FC->addDataSet("Server 2","anchorRadius=6");
  # Add chart data for the above dataset
  # where 1st parameter for X axis value
  # 2nd parameter take Y axis as parameter list
  # e.g y=30
  $FC->addChartData("23","y=1.4");
  $FC->addChartData("29","y=1.5");
  $FC->addChartData("33","y=1.5");
  $FC->addChartData("41","y=1.1");
  
?>
<html>
  <head>
    <title>Scatter Chart : FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>

