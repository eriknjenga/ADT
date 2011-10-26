<?php
class Regimen extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('regimen_code', 'varchar', 20);
		$this -> hasColumn('regimen_desc', 'varchar', 50);
		$this -> hasColumn('category', 'varchar', 30);
		$this -> hasColumn('line', 'varchar', 4);
		$this -> hasColumn('type_of_service', 'varchar', 20);
		$this -> hasColumn('remarks', 'varchar', 30);
		$this -> hasColumn('enabled', 'varchar', 4);
	}

	public function setUp() {
		$this -> setTableName('regimen');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen");
		$regimens = $query -> execute();
		return $regimens;
	}

}
?>