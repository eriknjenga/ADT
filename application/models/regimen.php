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
		$this -> hasColumn('Source', 'varchar', 10);
	}

	public function setUp() {
		$this -> setTableName('regimen');
		$this -> hasOne('Regimen_Category as Regimen_Category', array('local' => 'Category', 'foreign' => 'id'));
		$this -> hasOne('Regimen_Service_Type as Regimen_Service_Type', array('local' => 'Type_Of_Service', 'foreign' => 'id'));
		$this -> hasMany('Regimen_Drug as Drugs', array('local' => 'id', 'foreign' => 'Regimen'));
	}

	public function getAll($source = 0) {
		$query = Doctrine_Query::create() -> select("*") -> from("Regimen") -> where('Source = "' . $source . '" or Source ="0"') -> orderBy("Regimen_Desc asc");
		$regimens = $query -> execute();
		return $regimens;
	}

	public function getAllHydrated($source = 0) {
		$query = Doctrine_Query::create() -> select("r.Regimen_Code, r.Regimen_Desc,Line,rc.Name as Regimen_Category, rst.Name as Regimen_Service_Type ") -> from("Regimen r") -> leftJoin('r.Regimen_Category rc, r.Regimen_Service_Type rst') -> where('r.Source = "' . $source . '" or r.Source ="0"') -> orderBy("r.id desc");
		$regimens = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $regimens;
	}

	public function getTotalNumber($source = 0) {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Regimens") -> from("Regimen") -> where('Source = "' . $source . '" or Source ="0"');
		$total = $query -> execute();
		return $total[0]['Total_Regimens'];
	}

	public function getPagedRegimens($offset, $items, $source = 0) {
		$query = Doctrine_Query::create() -> select("Regimen_Code,Regimen_Desc,Category,Line,Type_Of_Service,Remarks,Enabled") -> from("Regimen") -> where('Source = "' . $source . '" or Source ="0"') -> offset($offset) -> limit($items);
		$regimens = $query -> execute();
		return $regimens;
	}

}
?>