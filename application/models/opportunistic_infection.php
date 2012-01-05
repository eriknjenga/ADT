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
		$query = Doctrine_Query::create() -> select("*") -> from("Opportunistic_Infection") -> where("Active", "1");
		$infections = $query -> execute();
		return $infections;
	}

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_OIs") -> from("Opportunistic_Infection");
		$total = $query -> execute();
		return $total[0]['Total_OIs'];
	}

	public function getPagedOIs($offset, $items) {
		$query = Doctrine_Query::create() -> select("Name") -> from("Opportunistic_Infection") -> offset($offset) -> limit($items);
		$ois = $query -> execute();
		return $ois;
	}

}
?>