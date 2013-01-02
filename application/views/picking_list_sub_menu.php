<?php
if(!isset($quick_link)){
$quick_link = null;
}  
?>
<div id="sub_menu">
	<a href="<?php echo site_url("picking_list_management/submitted_lists/0");?>" class="top_menu_link sub_menu_link first_link <?php if($quick_link == "0"){echo "top_menu_active";}?>">Open Lists</a>
	<a href="<?php echo site_url("picking_list_management/submitted_lists/1");?>" class="top_menu_link sub_menu_link last_link   <?php if($quick_link == "1"){echo "top_menu_active";}?>">Closed Lists</a> 
</div>
