<?php
class Visit_Purpose extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 50); 
		$this -> hasColumn('Active', 'varchar', 2); 
	}

	public function setUp() {
		$this -> setTableName('visit_purpose');
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Visit_Purpose")->where("Active","1");
		$purposes = $query -> execute();
		return $purposes;
	}

}
?>