<?php
class User_Right extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('Access_Level', 'varchar', 50);
		$this -> hasColumn('Menu', 'varchar', 100);
		$this -> hasColumn('Access_Type', 'text');
	}

	public function setUp() {
		$this -> setTableName('user_right');
		$this -> hasOne('Menu as Menu_Item', array('local' => 'Menu', 'foreign' => 'id'));
	}

	public static function getRights($access_level) {
		$query = Doctrine_Query::create() -> select("*") -> from("User_Right") -> where("Access_Level = '" . $access_level . "'");
		$rights = $query -> execute();
		return $rights;
	}

}
