<?php
if(!isset($quick_link)){
$quick_link = null;
}  
?>
<div id="sub_menu">
	<a href="<?php echo site_url("order_rationalization/submitted_orders/0");?>" class="top_menu_link sub_menu_link first_link <?php if($quick_link == "0"){echo "top_menu_active";}?>">Pending</a>
	<a href="<?php echo site_url("order_rationalization/submitted_orders/1");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "1"){echo "top_menu_active";}?>">Approved</a>
	<a href="<?php echo site_url("order_rationalization/submitted_orders/2");?>" class="top_menu_link sub_menu_link   <?php if($quick_link == "2"){echo "top_menu_active";}?>">Declined</a>
	<a href="<?php echo site_url("order_rationalization/submitted_orders/3");?>" class="top_menu_link sub_menu_link last_link  <?php if($quick_link == "3"){echo "top_menu_active";}?>">Dispatched</a>
</div>
