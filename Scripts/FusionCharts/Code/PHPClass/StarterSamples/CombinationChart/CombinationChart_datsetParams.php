<?php
  # Include FusionCharts PHP Class
   include("../Class/FusionCharts_Gen.php");
   
   # Create Column 3D + Line Dual Y-Axis Combination Chart
   $FC = new FusionCharts("MSColumn3DLineDY","450","350");

   # Set the relative path of the swf file
   $FC->setSWFPath("../FusionCharts/");

   # Store chart attributes in a variable 
   
   $strParam="caption=Weekly Sales;subcaption=Comparison;xAxisName=Week;pYAxisName=Revenue;sYAxisName=Total Quantity;numberPrefix=$;sNumberSuffix= U";

   # Set chart attributes
   $FC->setChartParams($strParam);

   # Add category names
   $FC->addCategory("Week 1");
   $FC->addCategory("Week 2");
   $FC->addCategory("Week 3");
   $FC->addCategory("Week 4");

   # Add a new dataset with dataset parameters 
   $FC->addDataset("This Month","showValues=0");
   # Add chart data for the above dataset
   $FC->addChartData("40800");
   $FC->addChartData("31400");
   $FC->addChartData("26700");
   $FC->addChartData("54400");

   # Add aother dataset with dataset parameters 
   $FC->addDataset("Previous Month","showValues=0");
   # Add chart data for the second dataset
   $FC->addChartData("38300");
   $FC->addChartData("28400");
   $FC->addChartData("15700");
   $FC->addChartData("48100");

   # Add third dataset for the secondary axis
   $FC->addDataset("Total Quantity","parentYAxis=S;parentYAxis=S;anchorSides=5;anchorradius=6;color=880000;anchorBgcolor=EE0000");
   # Add secondary axix's data values
   $FC->addChartData("64");
   $FC->addChartData("70");
   $FC->addChartData("52");
   $FC->addChartData("81");

?>


<html>
   <head>
      <title>Column 3D-Line Dual Y-Axis Combination Chart Using FusionCharts PHP Class</title>
      <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
   </head>
   <body>

      <?php
         # Render Chart
         $FC->renderChart();
      ?>

   </body>
</html>