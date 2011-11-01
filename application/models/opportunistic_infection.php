<?php
class Opportunistic_Infection extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 100); 
		$this -> hasColumn('Active', 'varchar', 2); 
	}

	public function setUp() {
		$this -> setTableName('opportunistic_infection');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Opportunistic_Infection")->where("Active","1");
		$infections = $query -> execute();
		return $infections;
	}

}
?>