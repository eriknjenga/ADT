<?php
class User_Right extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Access_Level', 'varchar', 50);
		$this -> hasColumn('Menu', 'varchar', 100);
		$this -> hasColumn('Access_Type', 'text');		
	}

	public function setUp() {
		$this -> setTableName('user_right'); 
	}
 

}
