<?php
echo validation_errors('
<p class="error">','</p>
'); 
?>
<form action="<?php echo base_url().'user_management/save_new_password'?>" method="post" style="margin:0 auto; width:300px;">
	<label> <strong class="label">Old Password</strong>
		<input type="password" name="old_password" id="old_password">
	</label><label> <strong class="label">New Password</strong>
		<input type="password" name="new_password" id="new_password">
	</label><label> <strong class="label">Confirm New Password</strong>
		<input type="password" name="new_password_confirm" id="new_password_confirm">
	</label>
	<br/> 
	<br/> 
		<input type="submit" class="button" name="register" id="register" value="Change Password">
 
</form>