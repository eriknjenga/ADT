<?php $link = null;?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title;?></title>
<link href="<?php echo base_url().'CSS/style.css'?>" type="text/css" rel="stylesheet"/>
<link href="<?php echo base_url().'CSS/pagination.css'?>" type="text/css" rel="stylesheet"/>
<link href="<?php echo base_url().'CSS/validator.css'?>" type="text/css" rel="stylesheet"/>
<script src="<?php echo base_url().'Scripts/jquery.js'?>" type="text/javascript"></script>
<script src="<?php echo base_url().'Scripts/validationEngine-en.js'?>" type="text/javascript"></script>
<script src="<?php echo base_url().'Scripts/validator.js'?>" type="text/javascript"></script>

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
		echo "<link href=\"" . base_url() . "CSS/" . $style . "\" type=\"text/css\" rel=\"stylesheet\"></link>";
	}
}
?> 
<style type="text/css">
	#signup_form {
		background-color: whiteSmoke;
		border: 1px solid #E5E5E5;
		padding: 20px 25px 15px;
		width: 500px;
		margin: 0 auto;
	}
	#signup_form input[type="submit"] {
		margin: 0 1.5em 1.2em 0;
		height: 32px;
		font-size: 13px;
	}
	#signup_form label {
		display: block;
		margin: 0 auto 1.5em auto;
		width: 300px;
	}
	.label {
		font-weight: bold;
		margin: 0 0 .5em;
		display: block;
		-webkit-user-select: none;
		-moz-user-select: none;
		user-select: none;
	}
	.remember-label {
		font-weight: normal;
		color: #666;
		line-height: 0;
		padding: 0 0 0 .4em;
		-webkit-user-select: none;
		-moz-user-select: none;
		user-select: none;
	}
	#system_title {
		position: absolute;
		top: 30px;
		left: 110px;
		text-shadow: 0 1px rgba(0, 0, 0, 0.1);
		letter-spacing: 1px;
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
<div class="banner_text" style="font-size: 44px; height:auto; width:auto;"><?php echo $banner_text;?></div>
</div>
 <div id="top_menu"> 
<a href="<?php echo site_url();?>" class="first_link top_menu_link <?php if($link == "pricing"){echo "top_menu_active";}?>">Link 1</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php if($link == "features"){echo "top_menu_active";}?>">Link 2</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php if($link == "resources"){echo "top_menu_active";}?>">Link 3</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php if($link == "support"){echo "top_menu_active";}?>">Link 4</a>
<a href="<?php echo site_url("disbursement_management");?>" class="top_menu_link <?php if($link == "clients"){echo "top_menu_active";}?>">Link 5</a>
<a ref="#" class="top_menu_link" id="my_profile_link"><?php echo $this->session->userdata('full_name');?></a>
 
 </div>

</div>

<div id="inner_wrapper"> 


<div id="main_wrapper"> 

<div id="container">
  <div id="content">
<div id="center_content">
<?php $this -> load -> view($content_view);?>

</div>  
  <!-- end .content --></div>

  <!-- end .container --></div>
 
<!-- end inner wrapper --></div>
  <!--End Wrapper div--></div>
    <div id="bottom_ribbon">
        <div id="footer">
 <?php $this -> load -> view("footer_v");?>
    </div>
    </div>
</body>
</html>
