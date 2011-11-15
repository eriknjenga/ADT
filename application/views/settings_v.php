<?php
if(!isset($quick_link)){
$quick_link = null;
}  
?>
<div id="sub_menu">
	
	<a href="<?php echo site_url('genericname_management');?>" class="top_menu_link sub_menu_link first_link  <?php if($quick_link == "generic"){echo "top_menu_active";}?>">Generic Names</a>
<a href="<?php echo site_url("drugcode_management");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "drugcode"){echo "top_menu_active";}?>">Drug Codes</a>
<a href="<?php echo site_url("brandname_management");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "brand"){echo "top_menu_active";}?>">Brand Names</a>
<a href="<?php echo site_url("regimen_management");?>" class="top_menu_link sub_menu_link  <?php if($quick_link == "regimen"){echo "top_menu_active";}?>">Regimens</a> 
<a href="<?php echo site_url("regimen_drug_management");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "regimen_drug"){echo "top_menu_active";}?>">Regimen Drugs</a> 
<a href="<?php echo site_url("menu_management");?>" class="top_menu_link sub_menu_link last_link   <?php if($quick_link == "menus"){echo "top_menu_active";}?>">System Menus</a> 
</div>
<div id="main_content">
<?php
$this->load->view($settings_view);
?>
</div>
