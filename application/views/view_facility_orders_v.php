<script type="text/javascript">
		var url = "";
	$(function() {
	$("#confirm_delete").dialog( {
	height: 150,
	width: 300,
	modal: true,
	autoOpen: false,
	buttons: {
	"Delete Record": function() {
	delete_record();
	},
	Cancel: function() {
	$( this ).dialog( "close" );
	}
	}

	} );

	$(".delete").click(function(){ 
	url = "<?php echo base_url().'order_management/delete_order/'?>
		" +$(this).attr("order");
		$("#confirm_delete").dialog('open');
		});
		});
		function delete_record(){
		window.location = url;
		}
</script>
<?php
$this->load->view("facility_orders_sub_menu");
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
				<td><a href="<?php echo base_url()."order_management/view_order/".$order->id;?>" class="link">View</a>
					<?php if($quick_link == 0){?>
					|<a order="<?php echo $order->id;?>" class="link delete">Delete</a></td>
					<?php }?>
					<?php if($quick_link == 2){?>
					|<a href="<?php echo base_url()."order_management/edit_order/".$order->id;?>" class="link">Edit</a></td>
					<?php }?>
			</tr>
		<?php }
		?>
	</tbody>
</table>
<div title="Confirm Delete!" id="confirm_delete" style="width: 300px; height: 150px; margin: 5px auto 5px auto;">
	Are you sure you want to delete this order?
</div>
<?php if (isset($pagination)):
?>
<div style="width:450px; margin:0 auto 40px auto"> 
	<?php echo $pagination;?>
</div>
<?php endif;?>