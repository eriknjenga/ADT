<?php
$access_level=$this->session->userdata('access_level');
$user_is_administrator=false;
$user_is_nascop=false;
$user_is_pharmacist=false;
if($access_level==1) {
$user_is_administrator=true;
}
if($access_level==2) {
$user_is_nascop=true;
}
if($access_level==3) {
$user_is_pharmacist=true;
}
?>
<script type="text/javascript">
	$(document).ready(function() {
initDatabase();<?php
if($user_is_pharmacist){
foreach($regimens as $regimen){?>
Populate("insert into regimen values(<?php echo $regimen->id;?>,'<?php echo $regimen->Regimen_Code;?>','<?php echo $regimen->Regimen_Desc;?>','<?php echo $regimen->Category;?>','<?php echo $regimen->Line;?>','<?php echo $regimen->Type_Of_Service;?>','<?php echo $regimen->Remarks;?>','<?php echo $regimen->Enabled;?>')");<?php }
foreach($supporters as $supporter){
?>
Populate("insert into supporter values(<?php echo $supporter->id;?>,'<?php echo $supporter->Name;?>')");<?php }
foreach($service_types as $service_type){
?>
Populate("insert into regimen_service_type values(<?php echo $service_type->id;?>,'<?php echo $service_type->Name;?>')");<?php }
foreach($sources as $source){
?>
Populate("insert into patient_source values(<?php echo $source->id;?>,'<?php echo $source->Name;?>')");<?php }
foreach($drugs as $drug){
?>
Populate("insert into drugcode values(<?php echo $drug->id;?>,'<?php echo $drug->Drug;?>','<?php echo $drug->Drug_Unit->Name;?>','<?php echo $drug->Pack_Size;?>','<?php echo $drug->Safety_Quantity;?>','<?php echo $drug->Generic->Name;?>','<?php echo $drug->Supporter->Name;?>','<?php echo $drug->Drug_Dose->Name;?>','<?php echo $drug->Duration;?>','<?php echo $drug->Quantity;?>')");<?php }
foreach($regimen_change_purpose as $change_purpose){
?>
Populate("insert into regimen_change_purpose values(<?php echo $change_purpose->id;?>,'<?php echo $change_purpose->Name;?>')");<?php }
foreach($visit_purpose as $v_purpose){
?>
Populate("insert into visit_purpose values(<?php echo $v_purpose->id;?>,'<?php echo $v_purpose->Name;?>')");<?php }
foreach($opportunistic_infections as $oi){
?>
Populate("insert into opportunistic_infections values(<?php echo $oi->id;?>,'<?php echo $oi->Name;?>')");<?php }
}
?>});</script>
Welcome to 127.0.0.1!