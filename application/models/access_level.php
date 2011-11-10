<?php
class Access_Level extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Level_Name', 'varchar', 50);
		$this -> hasColumn('Description', 'text');		
	}

	public function setUp() {
		$this -> setTableName('access_level');
		$this -> hasMany('Users as Users', array(
		'local' => 'id',
		'foreign' => 'Access_Level'));
	}
 

}
