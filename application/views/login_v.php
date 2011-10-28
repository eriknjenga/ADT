<?php ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title;?></title>
<link href="<?php echo base_url().'CSS/style.css'?>" type="text/css" rel="stylesheet"/>

<?php if(isset($script_urls)){
foreach ($script_urls as $script_url){
echo "<script src=\"".$script_url."\" type=\"text/javascript\"></script>";
}
}?>

<?php if(isset($scripts)){
foreach ($scripts as $script){
echo "<script src=\"".base_url()."Scripts/".$script."\" type=\"text/javascript\"></script>";
}
}?>


 
<?php if(isset($styles)){
foreach ($styles as $style){
echo "<link href=\"".base_url()."CSS/".$style."\" type=\"text/css\" rel=\"stylesheet\"></link>";
}
}?> 
<style type="text/css">
#signup_form{ 
background-color:whiteSmoke; 
border: 1px solid #E5E5E5;
padding: 20px 25px 15px;
width:500px;
margin:0 auto;
}
#signup_form input[type="submit"] {
margin: 0 1.5em 1.2em 0;
height: 32px;
font-size: 13px;
}
#signup_form label{
display: block;
margin: 0 auto 1.5em auto;
width:300px;
 
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
#system_title{ 
	position: absolute;
	top: 50px;
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
<span style="display: block; font-weight: bold; font-size: 14px; margin:2px;">Ministry of Medical Services/Public Health and Sanitation</span>
 <span style="display: block; font-size: 12px;">ARV Drugs Supply Chain Management Tool</span> 
</div>
 
</div>

<div id="inner_wrapper"> 


<div id="main_wrapper"> 

 
 

<div id="signup_form">
	 <div class="short_title" >
<h1 class="banner_text" >Sign in</h1>
</div>
<?php
echo validation_errors('
<p class="error">','</p>
'); 
if(isset($invalid)){
	echo "<p class='error'>Invalid Credentials. Please try again</p>";
}
else if(isset($inactive)){
	echo "<p class='error'>The Account is not active. Seek help from the Administrator</p>";
}
?>
<form action="<?php echo base_url().'user_management/authenticate'?>" method="post" >
<label>
<strong class="label">Username</strong>
<input type="text" name="username" id="username" value="">
</label>
<label>
<strong class="label">Password</strong>
<input type="password" name="password" id="password">
</label>
 <input type="submit" class="    button " name="register" id="register" value="Sign in" style="margin-left:100px;">
<label style="display:inline">
 <input type="checkbox" name="remember"> <strong class="remember-label">  Stay signed in  </strong>
</label>

</form>
</div>

</div>  
 
  <!--End Wrapper div--></div>
    <div id="bottom_ribbon">
        <div id="footer">
 <?php $this->load->view("footer_v");?>
    </div>
    </div>
</body>
</html>
