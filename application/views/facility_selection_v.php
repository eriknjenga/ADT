<?php
echo validation_errors('
<p class="error">','</p>
'); 
?>
<form action="<?php echo base_url().'order_management/new_satellite_order'?>" method="post" style="margin:0 auto; width:300px;">
	<label> <strong class="label">Select Satellite Facility</strong>
		<select name="facility">
			<option value="0">Select Facility</option>
			<?php 
				foreach($facilities as $facility){?>
					<option value="<?php echo $facility['id'];?>"><?php echo $facility['name'];?></option>
				<?php }
			?>
		</select> 
	<br/> 
	<br/> 
		<input type="submit" class="button" name="proceed" id="proceed" value="Proceed">
 
</form>