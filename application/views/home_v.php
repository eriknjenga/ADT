<?php
$access_level = $this -> session -> userdata('user_indicator');
$user_is_administrator = false;
$user_is_nascop = false;
$user_is_pharmacist = false;

if ($access_level == "system_administrator") {
	$user_is_administrator = true;
}
if ($access_level == "pharmacist") {
	$user_is_pharmacist = true;

}
if ($access_level == "nascop_staff") {
	$user_is_nascop = true;
}
?>

<?php
if ($user_is_pharmacist) {
?>

<script type="text/javascript">
	initDatabase();
	//Retrieve the Facility Code
	var facility_code = "<?php echo $this -> session -> userdata('facility');?>";
	var facility_name = "<?php echo $this -> session -> userdata('facility_name');?>";

	$(document).ready(function() {
		$("#environment_variables").dialog({
			height : 300,
			width : 300,
			modal : true,
			autoOpen : false
		});
		selectEnvironmentVariables(function(transaction, results) {
			var variables = null;
			var machine_code = "";
			var operator = "";
			try {
				variables = results.rows.item(0);
			} catch(err) {
				variables = false;
			}
			//If a row was returned, retrieve the variables
			if(variables != false) {
				//Update the facility details with the ones assigned to the logged in user.
				saveFacilityDetails(facility_code, facility_name);
				//Retrieve the other environment variables if they contain any values
				if(variables['machine_id'] != null) {
					machine_code = variables['machine_id'];
				}
				if(variables['operator'] != null) {
					operator = variables['operator'];
				}

			}
			//If a row was not returned, create one with the facility id attached to the logged in user
			else if(variables == false) {
				createEnvironmentVariables(facility_code, facility_name);
			}
			//Check whether the other two environment variables (machine_code and operator) have values. If not, prompt the user to enter them
			if(machine_code.length == 0 || operator.length == 0) {
				$("#environment_variables").dialog('open');
			} else if(machine_code.length > 0 || operator.length > 0) {
				checkSync();
			}
		});
		//Add Listener to the save button of the dialog box so as to save the entered environment variables
		$("#save_variables").click(function() {
			var machine_code = $("#machine_code").attr("value");
			var operator = $("#operator").attr("value");
			//Check if both variables contain values. If so, save these values
			if(machine_code.length > 0 && operator.length > 0) {
				saveEnvironmentVariables(machine_code, operator);
				$("#environment_variables").dialog('close');
				checkSync();
			} else {
				alert("Please enter values for both fields to continue");
			}
		});
		
		//Add a listener to the hover event of the synchronize div box. When the user hovers over the div, show the 'Synchronize now' Button
			$("#synchronize").hover(
			  function () {
			    $("#synchronize_button").show();
			  }, 
			  function () {
			     $("#synchronize_button").hide();
			  });
		});//End .ready opener
	function checkSync() {
		var url = "";
		var facility = "";
		var machine_code = "";
		//Retrieve the environment variables
		selectEnvironmentVariables(function(transaction, results){
			var variables = results.rows.item(0);
			machine_code = variables["machine_id"];
			facility = variables["facility"];
					//get my total_patients
		var total_patients = null;
		countPatientRecords(facility, function(transaction, results){
			var row = results.rows.item(0);
			total_patients = row['total']; 
			//Create the url to be used in the ajax call
			url = "synchronize_pharmacy/check_patient_numbers/"+facility;
			$.get(url, function(data) {
  				//alert(data);
  				$("#total_number_local").html(total_patients);
  				$("#total_number_registered").html(data);
  				var difference = data - total_patients;
  				if(difference != 0){
  					$("#synchronize").css("border-color","red");
  				}
		});
		});
		});

		$('#loadingDiv').ajaxStart(function() {
        	$(this).show('slow', function() {});
    	}).ajaxStop(function() {
        	$(this).hide();
        	  $('#dataDiv').show('slow', function() {});
    	});
	}
</script>
<style type="text/css">
	#environment_variables {
		width: 600px;
		margin: 0 auto;
	}
	#synchronize {
		text-align: left;
		font-size: 16px;
		text-shadow: 0 1px rgba(0, 0, 0, 0.1);
		letter-spacing: 1px;
		position: absolute;
		right: 15px;
		top: 60px;
		color: #036;
		border: 2px solid #DDDDDD;
		width: 300px;
		height:55px;
		padding: 2px;
		overflow: hidden;
	}
	#loadingDiv{
		width:100px;
		height: 55px;
		margin: 0 auto;
		background: url("Images/spinner.gif") no-repeat;
	}
</style>
<div id="environment_variables" title="System Initialization">
	<h1 class="banner_text" style="width:auto; font-size: 20px;">Environment Variables</h1>
	<div class="two_comlumns">
		<label style="width:250px; "> <strong class="label" >Machine Code</strong>
			<input style="width:250px;" type="text"name="machine_code" id="machine_code">
		</label>
		<label style="width:250px; "> <strong class="label">Operator Name</strong>
			<input style="width:250px" type="text"name="operator" id="operator">
		</label>
	</div>
	<input type="submit" class="submit-button" id="save_variables" value="Save" style="width:100px; margin: 10px auto;"/>
</div>

<?php }?>