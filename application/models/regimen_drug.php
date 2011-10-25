<?php
class Regimen_drug extends Doctrine_Record{

	public function setTableDefinition() {
		$this->hasColumn('regimen', 'varchar', 4);
		$this->hasColumn('combination', 'varchar', 40);	
	}	
	public function setUp() {
		$this->setTableName('regimen_drug');	 
	}
}
?>