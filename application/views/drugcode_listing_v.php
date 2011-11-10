<div id="view_content">
	<a class="action_button" id="new_genericname" href="<?php echo base_url()."drugcode_management/add"?>">New Drug Code</a>
<?php
echo $this -> table -> generate($drugcodes);
?>
	  
</div>