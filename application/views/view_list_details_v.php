<table class="data-table">
	<thead>
		<tr>
			<th>List Number</th>
			<th>Name</th>
			<th>Created By</th>
			<th>Created On</th>
			<th>Orders</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><?php echo $list -> id;?></td>
			<td><?php echo $list -> Name;?></td>
			<td><?php echo $list -> User_Object -> Name;?></td>
			<td><?php echo date('Y-m-d h:i:s', $list -> Timestamp);?></td>
			<td><?php echo count($list -> Order_Objects);?></td>
		</tr>
	</tbody>
</table> 
<?php
//First retrieve the orders
$orders = $list->Order_Objects;
//Loop through them to retrieve their particulars
foreach($orders as $order){
?>
<table class="data-table">
	<caption><?php echo "Order For ".$order->Facility_Object->name." number ".$order->id;?></caption>
	<thead>
		<tr>
			<th>Commodity</th>
			<th>Quantity for Resupply</th>
			<th>Packs/Bottles/Tins</th> 
		</tr>
	</thead>
	<tbody> 
		<?php
		//Retrieve the ordered commodities
		$commodities = $order->Commodity_Objects;
		//Loop through the commodities to display their particulars
		foreach($commodities as $commodity){?>
		<tr>
			<td><?php echo $commodity -> Drugcode_Object->Drug;?></td>
			<td><?php echo $commodity ->Resupply;?></td> 
			<td><?php if($commodity -> Drugcode_Object->Drug_Unit->Name == "Bottle"){echo "Bottle";} else{echo "Packs";};?></td> 
		</tr>
		<?php }
		?>
	</tbody>
</table>
<?php }?>