<div id="view_content">
	<a class="action_button" id="new_genericname" href="<?php echo base_url()."drugcode_management/add"?>">New Drug Code</a>
	<table border="0" class="data-table">
		<th class="subsection-title" colspan="7">Drug Codes</th>
		<tr>
			<th>Drug ID</th>
			<th>Unit</th>
			<th>Pack Size</th>
			<th>Safety Quantity</th>
			<th>Generic Name</th>
			<th>Supported By</th>
			<th>Action</th>
		</tr>
		<?php
foreach($drugcodes as $drugcode){
		?>
		<tr>
			<td><?php echo $drugcode -> Drug;?></td>
			<td><?php echo $drugcode -> Drug_Unit->Name;?></td>
			<td><?php echo $drugcode -> Pack_Size;?></td>
			<td><?php echo $drugcode -> Safety_Quantity;?></td>
			<td><?php echo $drugcode ->Generic->Name;?></td>
			<td><?php echo $drugcode -> Supporter->Name;?></td>
			<td><a href="#" class="link">Edit</a> | <a href="#" class="link">Details</a></td>
		</tr>
		<?php }?>
	</table>
	  
</div>