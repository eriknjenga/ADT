<?php
if (!$this -> session -> userdata('user_id')) {
	redirect("User_Management");
}
if (!isset($link)) {
	$link = null;
}
$access_level = $this -> session -> userdata('access_level');
$user_is_administrator = false;
$user_is_nascop = false;
$user_is_pharmacist = false;
if ($access_level == 1) {
	$user_is_administrator = true;
}
if ($access_level == 2) {
	$user_is_nascop = true;
}
if ($access_level == 3) {
	$user_is_pharmacist = true;

}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title;?></title>
<link href="<?php echo base_url().'CSS/style.css'?>" type="text/css" rel="stylesheet"/> 
<script src="<?php echo base_url().'Scripts/jquery.js'?>" type="text/javascript"></script> 

<?php
if ($user_is_pharmacist) {
	echo "<script src=\"" . base_url() . "Scripts/offline_database.js\" type=\"text/javascript\"></script>";
}
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

</head>

<body>
<div id="wrapper">
	<div id="top-panel" style="margin:0px;">

		<div class="logo">
			<a class="logo" href="<?php echo base_url();?>" ></a> 
</div>
<div id="system_title">
<div class="banner_text" style="font-size: 44px; height:50px; width:auto;"><?php echo $banner_text;?></div>
</div>
 <div id="top_menu"> 
 	
<a href="<?php echo site_url();?>" class="first_link top_menu_link <?php
if ($link == "home") {echo "top_menu_active";
}
	?>">Home</a>

<?php 
//Check if user is admin and show relevant menus
if($user_is_administrator){?>
<a href="<?php echo site_url("settings_management");?>" class="top_menu_link <?php
if ($link == "settings") {echo "top_menu_active";
}
?>">Settings</a>
<a href="<?php echo site_url("user_management");?>" class="top_menu_link <?php
if ($link == "resources") {echo "top_menu_active";
}
?>">Users</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php
if ($link == "support") {echo "top_menu_active";
}
?>">Facilities</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php
if ($link == "clients") {echo "top_menu_active";
}
?>">Link 5</a>
<?php }

	else if($user_is_nascop){
	//Add the relevant menu links here
	}
	else if($user_is_pharmacist){
?>
	<a href="<?php echo site_url("patient_management");?>" class="top_menu_link <?php
	if ($link == "patients") {echo "top_menu_active";
	}
?>">Patients</a>
<a href="<?php echo site_url("dispensement_management");?>" class="top_menu_link <?php
if ($link == "dispensement") {echo "top_menu_active";
}
	?>">Dispenses</a>
<a href="<?php echo site_url("pharmacist_report_management");?>" class="top_menu_link <?php
if ($link == "report") {echo "top_menu_active";
}
?>">Reports</a> 
<?php }?>
<a ref="#" class="top_menu_link" id="my_profile_link"><?php echo $this -> session -> userdata('full_name');?></a>


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
