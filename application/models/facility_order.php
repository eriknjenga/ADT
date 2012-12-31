<?php
class Facility_Order extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Status', 'varchar', 10);
		$this -> hasColumn('Created', 'varchar', 32);
		$this -> hasColumn('Updated', 'varchar', 32);
		$this -> hasColumn('Code', 'varchar', 10);
		$this -> hasColumn('Period_Begin', 'varchar', 10);
		$this -> hasColumn('Period_End', 'varchar', 10);
		$this -> hasColumn('Comments', 'text');
		$this -> hasColumn('Reports_Expected', 'varchar', 10);
		$this -> hasColumn('Reports_Actual', 'varchar', 10);
		$this -> hasColumn('Services', 'varchar', 10);
		$this -> hasColumn('Sponsors', 'varchar', 10);
		$this -> hasColumn('Delivery_Note', 'varchar', 10);
		$this -> hasColumn('Order_Id', 'varchar', 10);
		$this -> hasColumn('Facility_Id', 'varchar', 10);
	}//end setTableDefinition

	public function setUp() {
		$this -> setTableName('facility_order');
		$this -> hasOne('Facilities as Facility_Object', array('local' => 'Facility_Id', 'foreign' => 'id'));
	}//end setUp

	public static function getTotalNumber($status) {
		$query = Doctrine_Query::create() -> select("COUNT(*) as Total_Orders") -> from("Facility_Order") -> where("Status = '$status'");
		$count = $query -> execute();
		return $count[0] -> Total_Orders;
	}

	public function getPagedOrders($offset, $items, $status) {
		$query = Doctrine_Query::create() -> select("*") -> from("Facility_Order") -> orderBy("str_to_date(Period_Begin,'%Y-%m-%d') desc") -> where("Status = '$status'") -> offset($offset) -> limit($items);
		$orders = $query -> execute();
		return $orders;
	}

	public static function getTotalFacilityNumber($status,$facility) {
		$query = Doctrine_Query::create() -> select("COUNT(*) as Total_Orders") -> from("Facility_Order") -> where("Status = '$status' and Facility_Id = '$facility'");
		$count = $query -> execute();
		return $count[0] -> Total_Orders;
	}

	public function getPagedFacilityOrders($offset, $items, $status,$facility) {
		$query = Doctrine_Query::create() -> select("*") -> from("Facility_Order") -> orderBy("str_to_date(Period_Begin,'%Y-%m-%d') desc") -> where("Status = '$status' and Facility_Id = '$facility'") -> offset($offset) -> limit($items);
		$orders = $query -> execute();
		return $orders;
	}

	public static function getOrder($order) {
		$query = Doctrine_Query::create() -> select("*") -> from("Facility_Order") -> where("id = '$order'");
		$order_object = $query -> execute();
		return $order_object[0];
	}

}//end class
?>