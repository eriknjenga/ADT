<?php
class Patient_Appointment extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Patient', 'varchar', 25);
		$this -> hasColumn('Appointment', 'varchar', 25);
		$this -> hasColumn('Facility', 'varchar', 25);
		$this -> hasColumn('Current_Regimen', 'varchar', 10);
	}

	public function setUp() {
		$this -> setTableName('patient_appointment');
		$this -> hasOne('Patient as Patient_Object', array('local' => 'Patient', 'foreign' => 'id'));
	}

	public function getAllScheduled($timestamp) {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Appointment")->where("Appointment = '$timestamp'");
		$appointments = $query -> execute(); 
		return $appointments;
	}

}
