<?php
class Drug_Unit extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 25);
	}

	public function setUp() {
		$this -> setTableName('drug_unit');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("drug_unit");
		$drugunits = $query -> execute();
		return $drugunits;
	}

}
