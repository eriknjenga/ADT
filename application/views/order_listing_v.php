<style>
	.action_button {
		width: 200px;
		float: left;
	}	#menu_container {
		width: 80%;
		margin:0 auto; 
		overflow:hidden;
	}
</style>
<div id="menu_container">
	<a class="action_button" href="<?php echo base_url().'order_management/new_satellite_order'?>" style="margin-top:10px;">Satellite Facility Report</a>
	<a class="action_button" href="<?php echo base_url().'order_management/new_order'?>" style="margin-top:10px;">Central Facility Report</a>
	<a class="action_button" href="<?php echo base_url().'satellite_management/issue'?>" style="margin-top:10px;">Issue to Satellite</a>
</div>
<table class="data-table" id="orders_table">
	<tr>
		<th>Reporting Period</th>
		<th>Made By</th>
		<th>Order Status</th>
	</tr>
</table>