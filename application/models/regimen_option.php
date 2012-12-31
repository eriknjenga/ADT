<?php
class Regimen_Option extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Option_Name', 'varchar', 20);
		$this -> hasColumn('Regimen_Name', 'varchar', 20);
		$this -> hasColumn('Adult', 'varchar', 2);
	}

	public function setUp() {
		$this -> setTableName('regimen_option');
	}

	public function getOptions($age) {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen_Option")->where('Adult = "'.$age.'"');
		$regimen_options = $query -> execute();
		return $regimen_options;
	}
}
?>