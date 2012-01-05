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

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Regimen_Drugs") -> from("Regimen_Drug");
		$total = $query -> execute();
		return $total[0]['Total_Regimen_Drugs'];
	}

	public function getPagedRegimenDrugs($offset, $items) {
		$query = Doctrine_Query::create() -> select("Regimen,Drugcode") -> from("Regimen_Drug") -> offset($offset) -> limit($items);
		$regimen_drugs = $query -> execute();
		return $regimen_drugs;
	}

}
?>