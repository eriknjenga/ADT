<?php
if(!isset($quick_link)){
$quick_link = null;
}  
?>
<div id="sub_menu">
	
	<a href="<?php echo site_url('genericname_management');?>" class="top_menu_link sub_menu_link first_link  <?php if($quick_link == "generic"){echo "top_menu_active";}?>">Generic Names</a>
<a href="<?php echo site_url("settings_management");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "settings"){echo "top_menu_active";}?>">Drug Codes</a>
<a href="<?php echo site_url("user_management");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "resources"){echo "top_menu_active";}?>">Brand Names</a>
<a href="<?php echo site_url("regimen_management");?>" class="top_menu_link sub_menu_link last_link   <?php if($quick_link == "regimen"){echo "top_menu_active";}?>">Regimens</a> 
</div>
<div id="main_content">
<?php
$this->load->view($settings_view);
?>
</div>
