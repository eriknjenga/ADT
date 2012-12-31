<?php
$this->load->view("orders_sub_menu");
 if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto">
	<?php echo $pagination;?>
</div>
<?php endif;?>
<table class="data-table">
	<thead>
		<tr>
			<th>Order Number</th>
			<th>Facility</th>
			<th>Period Begining</th>
			<th>Action</th>
		</tr>
	</thead>
	<tbody>
		<?php 
		foreach($orders as $order){?>
			<tr>
				<td><?php echo $order->id;?></td>
				<td><?php echo $order->Facility_Object->name;?></td>
				<td><?php echo $order->Period_Begin;?></td>
				<td><a href="<?php echo base_url()."order_rationalization/rationalize_order/".$order->id;?>" class="link">View</a></td>
				
			</tr>
		<?php }
		?>
	</tbody>
</table>
<?php if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto"> 
	<?php echo $pagination;?>
</div>
<?php endif;?>