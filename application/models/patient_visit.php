<?php
class Patient_Visit extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Patient_Id', 'varchar', 10);
		$this -> hasColumn('Visit_Purpose', 'varchar', 10);
		$this -> hasColumn('Current_Height', 'varchar', 10);
		$this -> hasColumn('Current_Weight', 'varchar', 10); 
		$this -> hasColumn('Regimen', 'varchar', 10);
		$this -> hasColumn('Regimen_Change_Reason', 'varchar', 10);
		$this -> hasColumn('Drug_Id', 'varchar', 10);
		$this -> hasColumn('Batch_Number', 'varchar', 10);
		$this -> hasColumn('Brand', 'varchar', 10);
		$this -> hasColumn('Indication', 'varchar', 10);
		$this -> hasColumn('Pill_Count', 'varchar', 10);
		$this -> hasColumn('Comment', 'text');
		$this -> hasColumn('Timestamp', 'varchar', 32);
		$this -> hasColumn('User', 'varchar', 10);
		$this -> hasColumn('Facility', 'varchar', 10);
		$this -> hasColumn('Dose', 'varchar', 20);
		$this -> hasColumn('Dispensing_Date', 'varchar', 20);
		$this -> hasColumn('Dispensing_Date_Timestamp', 'varchar', 32);
		$this -> hasColumn('Quantity', 'varchar', 100);
	}

	public function setUp() {
		$this -> setTableName('patient_visit');
	}

	public function getAllScheduled($timestamp) {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Visit")->where("Dispensing_Date_Timestamp >= '$timestamp'");
		$visits = $query -> execute();
		return $visits;
	}
	public function getAll() {
		$query = Doctrine_Query::create() -> select("Dispensing_Date,Dispensing_Date_Timestamp") -> from("Patient_Visit");
		$visits = $query -> execute();
		return $visits;
	}

}
