<?php
class Supporter extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 25);
	}

	public function setUp() {
		$this -> setTableName('supporter');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("supporter");
		$supporters = $query -> execute();
		return $supporters;
	}

}
