<script type="text/javascript">
	$(function() {
		$(".commodity").change(function(){
			var consumption = $('.commodity option:selected').attr("consumption");
			var row_element = $(this).closest(".commodity_row");
			var consumption_box = row_element.find(".commodity_consumption");
			consumption_box.attr("value",consumption); 
		});
		$(".commodity").change(function(){
			
		});
	});
	function refresh_commodity_row(){
		
	}

</script>
<style>
	.option_container{
		width:900px; 
	}
	.commodity-table{
		float:right;
	}
	.regimen_container{
		float: left;
	}
	.commodity, .input_box{
		width:100px;
	}
</style>
<div style="margin-top: 20px;">
	<div class="option_container">
		<select id="paediatric_regimens" class="regimen_container">
			<?php
foreach($paediatric_options as $paediatric_option){
			?>
			<option value="<?php echo $paediatric_option -> id;?>"><?php echo $paediatric_option -> Option_Name . ": " . $paediatric_option -> Regimen_Name;?></option>
			<?php }?>
		</select> 
		<table class="data-table commodity_table">
			<thead>
				<tr><th>Commodity Name</th><th>Total Consumed</th><th>% for Regimen</th><th>Packs per Month</th><th>Action</th></tr>
			</thead>
			<tbody>
				<tr class="commodity_row"><td><select class="commodity">
					<option value="0">Choose One</option>
					<?php 
					foreach($commodities as $commodity){?>
						<option value="<?php echo $commodity['drug_id'];?>" consumption="<?php echo $commodity['quantity_dispensed'];?>"><?php echo $commodity['drug'];?></option>
					<?php }
					?>
				</select></td>
				<td><input class="commodity_consumption input_box" /></td>
				<td><input class="percentage input_box" /></td>
				<td><input class="packs input_box" /></td>
				<td><button class="button add_row">Add</button>
				<button class="button remove_row">Remove</button></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>