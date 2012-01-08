<?php
class Patient_Status extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 50);
		$this -> hasColumn('Active', 'varchar', 2);
	}

	public function setUp() {
		$this -> setTableName('patient_status');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Status") -> where("Active", "1");
		$statuses = $query -> execute();
		return $statuses;
	}

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Statuses") -> from("Patient_Status");
		$total = $query -> execute();
		return $total[0]['Total_Statuses'];
	}

	public function getPagedStatuses($offset, $items) {
		$query = Doctrine_Query::create() -> select("Name") -> from("Patient_Status") -> offset($offset) -> limit($items);
		$statuses = $query -> execute();
		return $statuses;
	}

}
?>