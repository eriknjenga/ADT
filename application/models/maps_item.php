<?php
class Maps_Item extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Total', 'varchar', 10);
		$this -> hasColumn('Regimen_Id', 'varchar', 10);
		//The maps id is the foreign key from the facility order table
		$this -> hasColumn('Maps_Id', 'varchar', 10);
	}//end setTableDefinition

	public function setUp() {
		$this -> setTableName('maps_item');
		$this -> hasOne('Regimen as Regimen_Object', array('local' => 'Regimen_Id', 'foreign' => 'id'));
	}//end setUp

	public static function getOrderItems($order) {
		$query = Doctrine_Query::create() -> select("*") -> from("Maps_Item") -> where("Maps_Id = '$order'");
		$items = $query -> execute();
		return $items;
	}

	public static function getItem($item) {
		$query = Doctrine_Query::create() -> select("*") -> from("Maps_Item") -> where("id = '$item'");
		$items = $query -> execute();
		return $items[0];
	}

}//end class
?>