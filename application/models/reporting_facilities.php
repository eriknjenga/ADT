<?php
class Reporting_Facility extends Doctrine_Record {
	public function setTableDefinition() {
		$this -> hasColumn('facilitycode', 'varchar', 10); 
	}

	public function setUp() {
		$this -> setTableName('reporting_facility');
		$this -> hasOne('Facilities as Facility_Object', array('local' => 'facilitycode', 'foreign' => 'facilitycode'));
	}

	public static function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Reporting_Facility");
		$facilities = $query -> execute(array());
		return $facilities;
	}

}
