<?php
class Menu extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Menu_Text', 'varchar', 50);
		$this -> hasColumn('Menu_Url', 'varchar', 100);
		$this -> hasColumn('Description', 'text');		
	}

	public function setUp() {
		$this -> setTableName('menu'); 
	}
 

}
