<?php
class Regimen_Drug extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Regimen', 'varchar', 5); 
		$this -> hasColumn('Drugcode', 'varchar', 5); 
	}

	public function setUp() {
		$this -> setTableName('regimen_drug');
		$this -> hasOne('Drugcode as Drug', array('local' => 'Drugcode', 'foreign' => 'id'));
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen_Drug");
		$regimen_drugs = $query -> execute();
		return $regimen_drugs;
	}

}
?>