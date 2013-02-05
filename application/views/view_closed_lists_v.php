<?php
$this->load->view("picking_list_sub_menu");
 if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto">
	<?php echo $pagination;?>
</div>
<?php endif;?>
<table class="data-table">
	<thead>
		<tr>
			<th>List Number</th>
			<th>Name</th>
			<th>Created By</th>
			<th>Created On</th>
			<th>Orders</th>
			<th>Action</th>
		</tr>
	</thead>
	<tbody>
		<?php 
		foreach($lists as $list){?>
			<tr>
				<td><?php echo $list->id;?></td>
				<td><?php echo $list->Name;?></td>
				<td><?php echo $list->User_Object->Name;?></td>
				<td><?php echo date('Y-m-d h:i:s',$list->Timestamp);?></td>
				<td><?php echo count($list->Order_Objects);?></td>
				<td><a href="<?php echo base_url()."picking_list_management/view_orders/".$list->id;?>" class="link">View Orders</a> | <a href="<?php echo base_url()."picking_list_management/print_list/".$list->id;?>" class="link">Print List</a></td>
				
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