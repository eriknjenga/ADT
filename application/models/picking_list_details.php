<?php
class Picking_List_Details extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 50);
		$this -> hasColumn('Created_By', 'varchar', 10);
		$this -> hasColumn('Timestamp', 'varchar', 32);
		$this -> hasColumn('Status', 'varchar', 5);
	}//end setTableDefinition

	public function setUp() {
		$this -> setTableName('picking_list_details');
		$this -> hasOne('Users as User_Object', array('local' => 'Created_By', 'foreign' => 'id'));
		$this -> hasMany('Facility_Order as Order_Objects', array('local' => 'id', 'foreign' => 'Picking_List_Id'));
	}//end setUp

	public static function getTotalNumber($status) {
		$query = Doctrine_Query::create() -> select("COUNT(*) as Total_Lists") -> from("Picking_List_Details") -> where("Status = '$status'");
		$count = $query -> execute();
		return $count[0] -> Total_Lists;
	}

	public function getPagedLists($offset, $items, $status) {
		$query = Doctrine_Query::create() -> select("*") -> from("Picking_List_Details") -> orderBy("id desc") -> where("Status = '$status'") -> offset($offset) -> limit($items);
		$lists = $query -> execute();
		return $lists;
	}

	public static function getList($list) {
		$query = Doctrine_Query::create() -> select("*") -> from("Picking_List_Details") -> where("id = '$list'");
		$list_object = $query -> execute();
		return $list_object[0];
	}

	public static function getAllOpen() {
		$query = Doctrine_Query::create() -> select("*") -> from("Picking_List_Details") -> where("Status = '0'");
		$list_object = $query -> execute();
		return $list_object;
	}

}//end class
?>