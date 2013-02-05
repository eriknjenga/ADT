<?php  
if($current == null){
	$current = "";
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><?php echo $title;?></title> 
<!--[if IE 9]>
    <link rel="stylesheet" media="screen" href="css/ie9.css"/>
<![endif]-->

<!--[if IE 8]>
    <link rel="stylesheet" media="screen" href="css/ie8.css"/>
<![endif]-->

<!--[if IE 7]>
    <link rel="stylesheet" media="screen" href="css/ie7.css"/>
<![endif]-->
<link href="<?php echo base_url().'css/style.default.css'?>" type="text/css" rel="stylesheet"/> 
<script src="<?php echo base_url().'Scripts/plugins/jquery-1.7.min.js'?>" type="text/javascript"></script>  
<script src="<?php echo base_url().'Scripts/plugins/jquery.dataTables.min.js'?>" type="text/javascript"></script>   
<script src="<?php echo base_url().'Scripts/plugins/jquery-ui-1.8.16.custom.min.js'?>" type="text/javascript"></script>  
<script src="<?php echo base_url().'Scripts/FusionCharts/FusionCharts.js'?>" type="text/javascript"></script> 


<script src="<?php echo base_url().'Scripts/custom/general.js'?>" type="text/javascript"></script> 
<script src="<?php echo base_url().'Scripts/custom/tables.js'?>" type="text/javascript"></script>   

<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->
<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="js/plugins/excanvas.min.js"></script><![endif]-->
</head>

<body class="loggedin">
    <!-- START OF MAIN CONTENT -->
    <div class="mainwrapper">
     	<div class="mainwrapperinner">
         	
        <div class="mainleft">
          	<div class="mainleftinner">
            
              	<div class="leftmenu">
            		<ul>
            			<li <?php if($current == 'home_controller'){echo "class='current'";}?>><a href="<?php echo site_url("home_controller");?>" class="dashboard"><span>Patient Enrollments</span></a></li>
                    	<li <?php if($current == 'refills'){echo "class='current'";}?>><a href="<?php echo site_url("patient_statistics/refills");?>" class="dashboard"><span>Number of Refill Patients</span></a></li>
                        <li <?php if($current == 'patients_per_regimen'){echo "class='current'";}?>><a href="<?php echo site_url("patient_statistics/patients_per_regimen");?>" class="dashboard"><span>Number of Patients per Regimen</span></a></li>
                        <li <?php if($current == 'service_breakdown'){echo "class='current'";}?>><a href="<?php echo site_url("patient_statistics/service_breakdown");?>" class="dashboard"><span>Breakdown of Patients</span></a></li>
                        <li <?php if($current == 'service_offering'){echo "class='current'";}?>><a href="<?php echo site_url("service_offering");?>" class="dashboard"><span>Service Offering</span></a></li>
                        <li <?php if($current == 'danger_signs'){echo "class='current'";}?>><a href="<?php echo site_url("danger_signs");?>" class="dashboard"><span>Danger Signs</span></a></li>
                        <li <?php if($current == 'main_symptoms'){echo "class='current'";}?>><a href="<?php echo site_url("main_symptoms");?>" class="dashboard"><span>Four Main Symptoms</span></a></li>
                        <li <?php if($current == 'checks'){echo "class='current'";}?>><a href="<?php echo site_url("checks");?>" class="dashboard"><span>Checks</span></a></li>
                        <li <?php if($current == 'assessment'){echo "class='current'";}?>><a href="<?php echo site_url("assessment");?>" class="dashboard"><span>Assessment &amp; Classification For Children</span></a></li>
                       <li <?php if($current == 'correct_assessment'){echo "class='current'";}?>><a href="<?php echo site_url("correct_assessment");?>" class="dashboard"><span>Is Assessment Correct?</span></a></li>
                        <li <?php if($current == 'treatment_options'){echo "class='current'";}?>><a href="<?php echo site_url("treatment_options");?>" class="dashboard"><span>Treatment Options</span></a></li>
                        <li <?php if($current == 'ort_corner'){echo "class='current'";}?>><a href="<?php echo site_url("ort_corner");?>" class="dashboard"><span>ORT Corner Assessment</span></a></li>
                        
                       
                    </ul>
                        
                </div><!--leftmenu-->
            	<div id="togglemenuleft"><a></a></div>
            </div><!--mainleftinner-->
        </div><!--mainleft-->
        
        <div class="maincontent">
        	<div class="maincontentinner">
           <?php $this -> load -> view($content_view);?>
            </div><!--maincontentinner-->
            
            <div class="footer">
            	<p>Government of Kenya &copy; <?php echo date('Y');?>. All Rights Reserved.</p>
            </div><!--footer-->
            
        </div><!--maincontent-->

                
     	</div><!--mainwrapperinner-->
    </div><!--mainwrapper-->
	<!-- END OF MAIN CONTENT -->
    

</body>
</html>
