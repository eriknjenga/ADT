<?php
class Brand extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Drug_Id', 'varchar', 25);
		$this -> hasColumn('Brand', 'varchar', 25);		
	}

	public function setUp() {
		$this -> setTableName('brand');
		$this -> hasOne('Drugcode as Drugcode', array(
		'local' => 'drug_id',
		'foreign' => 'id'));
	}
	
		public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("brand")->orderBy("Drug_Id desc");
		$brands = $query -> execute();
		return $brands;
	}

}
