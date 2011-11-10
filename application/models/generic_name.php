<?php
class Generic_Name extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 25);
	}

	public function setUp() {
		$this -> setTableName('generic_name');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("Name") -> from("generic_name");
		$drugcodes = $query -> execute();
		return $drugcodes;
	}

	public function getAllHydrated() {
		$query = Doctrine_Query::create() -> select("Name") -> from("generic_name");
		$drugcodes = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $drugcodes;
	}

}
