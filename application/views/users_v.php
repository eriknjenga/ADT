<style type="text/css">
	#actions_panel {
		float:left;
		width:20px;
		border:1px solid black;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$(".table_row").hover(function() {
			var cloned_object = $(this).clone();
			cloned_object.attr("id", "actions_container");
			$.each(cloned_object.find("td"), function(i, v) {
				$(this).remove();
			});
			cloned_object.append($("#action_panel_parent").html());
			cloned_object.insertAfter($(this));
		}, function() {
			$("#actions_container").remove();
		});
	});

</script>

<div id="action_panel_parent" style="display:none">
<div id="actions_panel" >
	Edit hereasdasdadsa
</div>
</div>
<?php
echo $this -> table -> generate($users);
?>