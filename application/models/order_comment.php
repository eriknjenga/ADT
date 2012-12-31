<?php
class Order_Comment extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Order_Number', 'varchar', 10);
		$this -> hasColumn('Timestamp', 'varchar', 32);
		$this -> hasColumn('User', 'varchar', 10);
		$this -> hasColumn('Comment', 'text');
	}//end setTableDefinition

	public function setUp() {
		$this -> setTableName('order_comment');
		$this -> hasOne('Users as User_Object', array('local' => 'User', 'foreign' => 'id'));
	}//end setUp

	public static function getOrderComments($order) {
		$query = Doctrine_Query::create() -> select("*") -> from("Order_Comment") -> where("Order_Number = '$order'")->orderBy("Timestamp asc");
		$comments = $query -> execute();
		return $comments;
	}

}//end class
?>