<?php
class Access_Type extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Type_Name', 'varchar', 50);
		$this -> hasColumn('Description', 'text');		
	}

	public function setUp() {
		$this -> setTableName('access_type'); 
	}
 

}
