<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title;?></title>
<link href="<?php echo base_url().'CSS/style.css'?>" type="text/css" rel="stylesheet"/> 
<link href="<?php echo base_url().'CSS/jquery-ui.css'?>" type="text/css" rel="stylesheet"/> 
<script src="<?php echo base_url().'Scripts/jquery.js'?>" type="text/javascript"></script> 
<script src="<?php echo base_url().'Scripts/jquery-ui.js'?>" type="text/javascript"></script> 

<?php 
if (isset($script_urls)) {
	foreach ($script_urls as $script_url) {
		echo "<script src=\"" . $script_url . "\" type=\"text/javascript\"></script>";
	}
}
?>

<?php
if (isset($scripts)) {
	foreach ($scripts as $script) {
		echo "<script src=\"" . base_url() . "Scripts/" . $script . "\" type=\"text/javascript\"></script>";
	}
}
?>


 
<?php
if (isset($styles)) {
	foreach ($styles as $style) {
		echo "<link href=\"" . base_url() . "CSS/" . $style . "\" type=\"text/css\" rel=\"stylesheet\"/>";
	}
}
?>  
<style> 
	#my_profile_link {
		width: 150px !important;
		margin: 0px !important;
		padding: 0px !important;
	}
	#inner_wrapper{
		top:115px;
	}
</style>
</head>

<body>
<div id="wrapper">
	<div id="top-panel" style="margin:0px;">

		<div class="logo">
			<a class="logo" href="<?php echo base_url();?>" ></a> 
</div>

				<div id="system_title">
					<span style="display: block; font-weight: bold; font-size: 14px; margin:2px;">Ministry of Medical Services/Public Health and Sanitation</span>
					<span style="display: block; font-size: 12px;">ARV Drugs Supply Chain Management Tool</span>
				</div>
				<div class="banner_text"><?php echo $banner_text;?></div>
 <div id="top_menu"> 
 	<a href="<?php echo site_url('home_controller');?>" class="top_menu_link  first_link <?php
	if ($current == "home_controller") {echo " top_menu_active ";
	}
?>">Home </a>
<a href="<?php echo site_url('patient_management/regimen_breakdown');?>" class="top_menu_link  <?php
	if ($current == "patient_management") {echo " top_menu_active ";
	}
?>">Patients</a>
<a href="<?php echo site_url('commodity_management/commodity_breakdown');?>" class="top_menu_link  <?php
	if ($current == "commodity_management") {echo " top_menu_active ";
	}
?>">Stocks</a>
<div id="my_profile_link_container" style="display: inline">
<a href="<?php echo site_url('user_management/login');?>" class="top_menu_link" id="my_profile_link">System Login </a>
</div>
 </div>

</div>

<div id="inner_wrapper"> 


<div id="main_wrapper"> 
 
<?php $this -> load -> view($content_view);?>
 
 
 
<!-- end inner wrapper --></div>
  <!--End Wrapper div--></div>
    <div id="bottom_ribbon">
        <div id="footer">
 <?php $this -> load -> view("footer_v");?>
    </div>
    </div>
</body>
</html>
