<?php
class Dose extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 25);
	}

	public function setUp() {
		$this -> setTableName('dose');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("dose");
		$doses = $query -> execute();
		return $doses;
	}

}
