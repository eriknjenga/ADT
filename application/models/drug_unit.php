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

	public function getTotalNumber() {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Units") -> from("Drug_Unit");
		$total = $query -> execute();
		return $total[0]['Total_Units'];
	}

	public function getPagedDrugUnits($offset, $items) {
		$query = Doctrine_Query::create() -> select("*") -> from("Drug_Unit") -> offset($offset) -> limit($items);
		$drug_units = $query -> execute();
		return $drug_units;
	}

}
