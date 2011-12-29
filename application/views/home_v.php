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
<script type="text/javascript">
	$(document).ready(function() {
initDatabase();});</script>
<?php
if ($user_is_pharmacist) {
	echo "Pharmacist";
}
?>