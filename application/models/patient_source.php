<?php
class Patient_Source extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 50);
		$this -> hasColumn('Active', 'varchar', 2);
	}

	public function setUp() {
		$this -> setTableName('patient_source');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Source") -> where("Active", "1");
		$sources = $query -> execute();
		return $sources;
	}

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Sources") -> from("Patient_Source");
		$total = $query -> execute();
		return $total[0]['Total_Sources'];
	}

	public function getPagedSources($offset, $items) {
		$query = Doctrine_Query::create() -> select("Name") -> from("Patient_Source") -> offset($offset) -> limit($items);
		$sources = $query -> execute();
		return $sources;
	}

}
?>