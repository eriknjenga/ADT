<!Doctype html>
<head>


<script type="text/javascript">
$(document).ready(function(){
var count='<?php echo @$this -> session -> userdata['upload_counter']?>';
	
	
	if(count == 2) {
    var message='Data Upload Success!<br/> ';
	var final_message=message;
	$(".passmessage").slideDown('slow', function() {

	});
	$(".passmessage").append(message);

	var fade_out = function() {
	$(".passmessage").fadeOut().empty();
	}
	setTimeout(fade_out, 5000);
     <?php $this -> session -> set_userdata('upload_counter', "0");?>

	}
	
	if(count == 1) {
	var message='Data Upload Failed! <br/> ';
	var final_message=message;

	$(".errormessage").slideDown('slow', function() {

	});
	$(".errormessage").append(final_message);

	var fade_out = function() {
	$(".errormessage").fadeOut().empty();
	}
	setTimeout(fade_out, 5000);
     <?php $this -> session -> set_userdata('upload_counter', "0");?>

	}
	
	

});

</script>
<style type="text/css">
.data_import{
	width:30%;
	border:1px solid #DDD;
	height:300px;
	margin-top:10px;
	margin-bottom:10px;
	margin-left:15%;
    float:left;
	padding:20px;
	text-align: left;
}


.import_title{
	text-align:left;
	font-weight:bold;
	margin-bottom:10px;
}	
.button {

		margin: 5px;
		height: 40px;
		width: 90px;
	}

	.passmessage {

		display: none;
		background: #00CC33;
		color: black;
		text-align: center;
		height: 20px;
		padding:5px;
		font: bold 1px;
		border-radius: 8px;
		width: 30%;
		margin-left: 30%;
		margin-right: 10%;
		font-size: 16px;
		font-weight: bold;
	}
	.errormessage {

		display: none;
		background: #C00000;
		color: black;
		text-align: center;
		height: 20px;
		padding:5px;
		font: bold 1px;
		border-radius: 8px;
		width: 30%;
		margin-left: 30%;
		margin-right: 10%;
		font-size: 16px;
		font-weight: bold;
	}
	
    
	

	
</style>
</head>
<body>
    <div class="passmessage"></div>
	<div class="errormessage"></div>
    
    
<div class="data_import">
	<h2 class="import_title">Data Upload</h2>	
	<hr/>
	<br/>
<form name="frm" method="post" enctype="multipart/form-data" id="frm" action="<?php echo base_url()."fcdrr_management/data_upload"?>">
	      
			<b><h3>File Chooser</h3></b>
			<p>
			<input type="file"  name="file" size="30" />
			<input name="btn_save" class="button" type="submit"  value="Save" />
			</p>
</form>	
</div>	


	
</body>

</html>
