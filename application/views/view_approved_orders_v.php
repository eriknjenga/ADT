<?php
$this->load->view("orders_sub_menu");
 if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto">
	<?php echo $pagination;?>
</div>
<?php endif;?>
<form method="post" action="<?php echo site_url('picking_list_management/assign_orders')?>">
<table class="data-table">
	<thead>
		<tr>
			<th>Order Number</th>
			<th>Facility</th>
			<th>Period Begining</th>
			<th>Check</th>
		</tr>
	</thead>
	<tbody>
		<?php 
		foreach($orders as $order){?>
			<tr>
				<td><?php echo $order->id;?></td>
				<td><?php echo $order->Facility_Object->name;?></td>
				<td><?php echo $order->Period_Begin;?></td>
				<td><input name="order[]" type="checkbox" value="<?php echo $order->id;?>" /></td>
				
			</tr>
		<?php }
		?> 
	</tbody>
</table>
<div style="width:200px; margin:0 auto;"><input type="submit" value="Add Checked Orders to Picking List" class="button"/></div>
</form>

<?php if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto"> 
	<?php echo $pagination;?>
</div>
<?php endif;?>