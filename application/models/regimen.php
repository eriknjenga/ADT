<?php
class Regimen extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Regimen_Code', 'varchar', 20);
		$this -> hasColumn('Regimen_Desc', 'varchar', 50);
		$this -> hasColumn('Category', 'varchar', 30);
		$this -> hasColumn('Line', 'varchar', 4);
		$this -> hasColumn('Type_Of_Service', 'varchar', 20);
		$this -> hasColumn('Remarks', 'varchar', 30);
		$this -> hasColumn('Enabled', 'varchar', 4);
	}

	public function setUp() {
		$this -> setTableName('regimen');
		$this -> hasOne('Regimen_Category as Regimen_Category', array('local' => 'Category', 'foreign' => 'id'));
		$this -> hasOne('Regimen_Service_Type as Regimen_Service_Type', array('local' => 'Type_Of_Service', 'foreign' => 'id'));
		$this -> hasMany('Regimen_Drug as Drugs', array('local' => 'id', 'foreign' => 'Regimen'));
	}

	public function getAll() {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen");
		$regimens = $query -> execute();
		return $regimens;
	}
		public function getAllHydrated() {
		$query = Doctrine_Query::create() -> select("r.Regimen_Code, r.Regimen_Desc,Line,Enabled,rc.Name as Regimen_Category, rst.Name as Regimen_Service_Type ") -> from("Regimen r")->leftJoin('r.Regimen_Category rc, r.Regimen_Service_Type rst');
		$regimens = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $regimens;
	}

}
?>