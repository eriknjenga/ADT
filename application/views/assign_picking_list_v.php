<form method="post" action="<?php echo site_url('picking_list_management/save_list')?>">
			<table class="data-table">
				<caption>Assign the following orders to:</caption>
			<tbody>
				<tr>
					<td>Orders:</td>
					<td colspan="2">
						<?php foreach($orders as $order){
							echo $order.",";?>
							<input type="hidden" name="orders[]" value="<?php echo $order; ?>" />
						<?php }?>
					</td>
				</tr>
				<tr>
					<td>New Picking List Name:</td>
					<td>
					<input name="picking_list_name" id="picking_list_name" type="text">
					</td> 
				</tr>
				<tr>
					<td>or Select an Open List:</td>
					<td>
					<select name="selected_picking_list">
						<option value="0">--Select One--</option>
						<?php foreach($picking_lists as $list){?>
							<option value="<?php echo $list->id; ?>"><?php echo $list->Name; ?></option> 
						<?php }?> 
					</select>
					</td> 
				</tr>
				<tr>
					<td colspan="2">
					<input name="generate" id="generate" class="button" value="Save" type="submit">
					</td>
				</tr>
			</tbody>
		</table>
</form>