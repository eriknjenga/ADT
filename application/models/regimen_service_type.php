<?php
class Regimen_Service_Type extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 50); 
		$this -> hasColumn('Active', 'varchar', 2); 
	}

	public function setUp() {
		$this -> setTableName('regimen_service_type');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen_Service_Type")->where("Active","1");
		$regimens = $query -> execute();
		return $regimens;
	}

}
?>