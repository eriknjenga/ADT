<?php
class Dose extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 25);
		$this -> hasColumn('Value', 'varchar', 2);
		$this -> hasColumn('Frequency', 'varchar', 1);
	}

	public function setUp() {
		$this -> setTableName('dose');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("dose");
		$doses = $query -> execute();
		return $doses;
	}

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Doses") -> from("Dose");
		$total = $query -> execute();
		return $total[0]['Total_Doses'];
	}

	public function getPagedDoses($offset, $items) {
		$query = Doctrine_Query::create() -> select("*") -> from("Dose") -> offset($offset) -> limit($items);
		$doses = $query -> execute();
		return $doses;
	}

}
