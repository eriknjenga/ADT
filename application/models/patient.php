<?php
class Patient extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Medical_Record_Number', 'varchar', 10);
		$this -> hasColumn('Patient_Number_CCC', 'varchar', 10);
		$this -> hasColumn('First_Name', 'varchar', 50);
		$this -> hasColumn('Last_Name', 'varchar', 50);
		$this -> hasColumn('Other_Name', 'varchar', 50);
		$this -> hasColumn('Dob', 'varchar', 32);
		$this -> hasColumn('Pob', 'varchar', 100);
		$this -> hasColumn('Gender', 'varchar', 2);
		$this -> hasColumn('Pregnant', 'varchar', 2);
		$this -> hasColumn('Weight', 'varchar', 5);
		$this -> hasColumn('Height', 'varchar', 5);
		$this -> hasColumn('Sa', 'varchar', 5);
		$this -> hasColumn('Phone', 'varchar', 30);
		$this -> hasColumn('Physical', 'varchar', 100);
		$this -> hasColumn('Alternate', 'varchar', 50);
		$this -> hasColumn('Other_Illnesses', 'text');
		$this -> hasColumn('Other_Drugs', 'text');
		$this -> hasColumn('Adr', 'text');
		$this -> hasColumn('Tb', 'varchar', 2);
		$this -> hasColumn('Smoke', 'varchar', 2);
		$this -> hasColumn('Alcohol', 'varchar', 2);
		$this -> hasColumn('Date_Enrolled', 'varchar', 32);
		$this -> hasColumn('Source', 'varchar', 2);
		$this -> hasColumn('Supported_By', 'varchar', 2);
		$this -> hasColumn('Timestamp', 'varchar', 32);
		$this -> hasColumn('Facility_Code', 'varchar', 10);
		$this -> hasColumn('Service', 'varchar', 5);
		$this -> hasColumn('Start_Regimen', 'varchar', 5);
		$this -> hasColumn('Machine_Code', 'varchar', 10);

	}

	public function setUp() {
		$this -> setTableName('patient');
	}

	public function getPatientNumbers($facility) {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Patients") -> from("Patient") -> where("Facility_Code = '$facility'");
		$total = $query -> execute();
		return $total[0]['Total_Patients'];
	}

	public function getPagedPatients($offset, $items, $machine_code, $patient_ccc, $facility) {
		$query = Doctrine_Query::create() -> select("p.*") -> from("Patient p") -> leftJoin("Patient p2") -> where("p2.Patient_Number_CCC = '$patient_ccc' and p2.Machine_Code = '$machine_code' and p2.Facility_Code='$facility' and p.id>p2.id and p.Facility_Code='$facility'") -> offset($offset) -> limit($items);
		$patients = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $patients;
	}

	public function getPagedFacilityPatients($offset, $items, $facility) {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient") -> where("Facility_Code='$facility'") -> offset($offset) -> limit($items);
		$patients = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $patients;
	}

}
