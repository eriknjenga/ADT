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
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen_Service_Type") -> where("Active", "1");
		$regimens = $query -> execute();
		return $regimens;
	}

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Types") -> from("Regimen_Service_Type");
		$total = $query -> execute();
		return $total[0]['Total_Types'];
	}

	public function getPagedTypes($offset, $items) {
		$query = Doctrine_Query::create() -> select("Name") -> from("Regimen_Service_Type") -> offset($offset) -> limit($items);
		$types = $query -> execute();
		return $types;
	}

}
?>