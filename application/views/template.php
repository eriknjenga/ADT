<?php
if (!$this -> session -> userdata('user_id')) {
	redirect("User_Management/login");
}
if (!isset($link)) {
	$link = null;
}
$access_level = $this -> session -> userdata('user_indicator');
$user_is_administrator = false;
$user_is_nascop = false;
$user_is_pharmacist = false;

if ($access_level == "system_administrator") {
	$user_is_administrator = true;
}
if ($access_level == "pharmacist") {
	$user_is_pharmacist = true;

}
if ($access_level == "nascop_staff") {
	$user_is_nascop = true;
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title;?></title>
<link href="<?php echo base_url().'CSS/style.css'?>" type="text/css" rel="stylesheet"/> 
<link href="<?php echo base_url().'CSS/jquery-ui.css'?>" type="text/css" rel="stylesheet"/> 
<script src="<?php echo base_url().'Scripts/jquery.js'?>" type="text/javascript"></script> 
<script src="<?php echo base_url().'Scripts/jquery-ui.js'?>" type="text/javascript"></script> 

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
<?php
if (!$user_is_pharmacist) {?>
<script type="text/javascript">
	$(document).ready(function() {
		$("#my_profile_link_container").hover(function() {
			var html = "<a href='<?php echo site_url('user_management/change_password')?>' class='top_menu_link temp_link'>Change Password</a> <a href='<?php echo site_url('user_management/logout');?>' class='top_menu_link temp_link'>Logout</a> ";
			$("#my_profile_link").css('display','none'); 
			$(this).append(html);
		}, function() {
			$("#my_profile_link").css('display','block');
			$(this).find(".temp_link").remove();
		});
	});

</script>
<?php }?>
<style>
	#my_profile_link_container .generated_link{
		display: none;
	}
	#my_profile_link{ 
		width: 200px !important;
		margin:0px !important;
		padding:0px !important;
	}
	#my_profile_link_continer{
		min-width: 200px !important;
		background-color: red;
		height:100px;
	}
	.temp_link{
		font-size: 10px;
		width:100px !important;
		background-color: #B80000;  
		margin:0px;
	}
</style>
</head>

<body>
<div id="wrapper">
	<div id="top-panel" style="margin:0px;">

		<div class="logo">
			<a class="logo" href="<?php echo base_url();?>" ></a> 
</div>
<?php if ($user_is_pharmacist) {?>
	<div id="synchronize">
		<div id="loadingDiv"></div>
		<div id="dataDiv" style="display: none;">
		<span style="display: block; font-size: 12px; margin: 10px 5px;">Number of Local Patients: <span id="total_number_local"></span></span>
		<span style="display: block; font-size: 12px; margin: 10px 5px;">Number of Patients Registered: <span id="total_number_registered"></span></span>
		</div>
		<a class="action_button" id="synchronize_button" href="<?php echo base_url();?>synchronize_pharmacy">Synchronize Now</a>
	</div>
	<?php }?>

				<div id="system_title">
					<span style="display: block; font-weight: bold; font-size: 14px; margin:2px;">Ministry of Medical Services/Public Health and Sanitation</span>
					<span style="display: block; font-size: 12px;">ARV Drugs Supply Chain Management Tool</span>
					<?php
					if ($user_is_pharmacist) {?>
						<style>
							#facility_name {
								color: green;
								margin-top: 5px;
								font-weight: bold;
							}
							#synchronize_button{
								display: none;
								width: 200px;
								margin: 0;
								height: 40px;
								position: absolute;
								top:3.5px;
								left:30px;		
								line-height: 40px;
														
							}
							
						</style>
						<div id="facility_name">
							
							<span style="display: block; font-size: 14px;"><?php echo $this -> session -> userdata('facility_name');?></span>
						</div>
					<?php }?>
				</div>
				<div class="banner_text"><?php echo $banner_text;?></div>
 <div id="top_menu"> 

 	<?php
	//Code to loop through all the menus available to this user!
	//Fet the current domain
	$menus = $this -> session -> userdata('menu_items');
	$current = $this -> router -> class;
	$counter = 0;
?>
 	<a href="<?php echo site_url('home_controller');?>" class="top_menu_link  first_link <?php
	if ($current == "home_controller") {echo " top_menu_active ";
	}
?>">Home </a>
<?php
foreach($menus as $menu){?>
	<a href = "<?php echo site_url($menu['url']);?>" class="top_menu_link <?php
	if ($current == $menu['url'] || $menu['url'] == $link) {echo " top_menu_active ";
	}
?>"><?php echo $menu['text']; if($menu['offline'] == "1"){?>
	 <span class="alert red_alert">off</span></a>
	
<?php } else{?>
	 <span class="alert green_alert">on</span></a>
<?php }?>



<?php
$counter++;
}
	?>
<div id="my_profile_link_container" style="display: inline">
<a ref="#" class="top_menu_link" id="my_profile_link"><?php echo $this -> session -> userdata('full_name');?></a>
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
