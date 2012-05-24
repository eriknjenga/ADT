<?php
class Patient_Visit extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Patient_Id', 'varchar', 10);
		$this -> hasColumn('Visit_Purpose', 'varchar', 10);
		$this -> hasColumn('Current_Height', 'varchar', 10);
		$this -> hasColumn('Current_Weight', 'varchar', 10);
		$this -> hasColumn('Regimen', 'varchar', 100);
		$this -> hasColumn('Last_Regimen', 'varchar', 100);
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
		$this -> hasColumn('Machine_Code', 'varchar', 100);
	}

	public function setUp() {
		$this -> setTableName('patient_visit');
	}

	public function getAllScheduled($timestamp) {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Visit") -> where("Dispensing_Date_Timestamp >= '$timestamp'");
		$visits = $query -> execute();
		return $visits;
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("Dispensing_Date,Dispensing_Date_Timestamp") -> from("Patient_Visit");
		$visits = $query -> execute();
		return $visits;
	}

	public function getTotalVisits($facility) {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Visits") -> from("Patient_Visit") -> where("Facility= '$facility'");
		$total = $query -> execute();
		return $total[0]['Total_Visits'];
	}

	public function getPagedPatientVisits($offset, $items, $machine_code, $patient_ccc, $facility, $date,$drug) {
		$query = Doctrine_Query::create() -> select("pv.*") -> from("Patient_Visit pv") -> leftJoin("Patient_Visit pv2") -> where("pv2.Patient_Id = '$patient_ccc' and pv2.Machine_Code = '$machine_code' and pv2.Dispensing_Date = '$date' and pv2.Facility='$facility' and pv2.Drug_Id = '$drug' and  pv.id>pv2.id and pv.Facility='$facility'") -> offset($offset) -> limit($items);
		//echo $query->getSQL();
		$patient_visits = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $patient_visits;
	}

	public function getPagedFacilityPatientVisits($offset, $items, $facility) {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Visit") -> where("Facility='$facility'") -> offset($offset) -> limit($items);
		$patient_visits = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $patient_visits;
	}

}