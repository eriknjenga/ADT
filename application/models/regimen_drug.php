<?php
class Regimen_Drug extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Regimen', 'varchar', 5);
		$this -> hasColumn('Drugcode', 'varchar', 5);
		$this -> hasColumn('Source', 'varchar', 10);
	}

	public function setUp() {
		$this -> setTableName('regimen_drug');
		$this -> hasOne('Drugcode as Drug', array('local' => 'Drugcode', 'foreign' => 'id'));
	}

	public function getAll($source = 0) {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen_Drug")->where('Source = "'.$source.'" or Source ="0"');
		$regimen_drugs = $query -> execute();
		return $regimen_drugs;
	}

	public function getTotalNumber($source = 0) {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Regimen_Drugs") -> from("Regimen_Drug")->where('Source = "'.$source.'" or Source ="0"');
		$total = $query -> execute();
		return $total[0]['Total_Regimen_Drugs'];
	}

	public function getPagedRegimenDrugs($offset, $items,$source = 0) {
		$query = Doctrine_Query::create() -> select("Regimen,Drugcode") -> from("Regimen_Drug")->where('Source = "'.$source.'" or Source ="0"') -> offset($offset) -> limit($items);
		$regimen_drugs = $query -> execute();
		return $regimen_drugs;
	}

}
?>