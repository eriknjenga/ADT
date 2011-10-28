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
		$query = Doctrine_Query::create() -> select("*") -> from("Patient_Source")->where("Active","1");
		$sources = $query -> execute();
		return $sources;
	}

}
?>