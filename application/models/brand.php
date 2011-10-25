<?php
class Brand extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('drug_id', 'varchar', 25);
		$this -> hasColumn('brand', 'varchar', 25);		
	}

	public function setUp() {
		$this -> setTableName('brand');
		$this -> hasOne('Drugcode as Drugcode', array(
		'local' => 'drug_id',
		'foreign' => 'id'));
	}

}
