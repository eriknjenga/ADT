<?php
class Drugcode extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Drug', 'varchar', 100);
		$this -> hasColumn('Unit', 'varchar', 30);
		$this -> hasColumn('Pack_Size', 'varchar', 100);
		$this -> hasColumn('Safety_Quantity', 'varchar', 4);
		$this -> hasColumn('Generic_Name', 'varchar', 100);
		$this -> hasColumn('Supported_By', 'varchar', 30);
		$this -> hasColumn('None_Arv', 'varchar', 1);
		$this -> hasColumn('Tb_Drug', 'varchar', 1);
		$this -> hasColumn('Drug_In_Use', 'varchar', 1);
		$this -> hasColumn('Comment', 'varchar', 50);
		$this -> hasColumn('Dose', 'varchar', 20);
		$this -> hasColumn('Duration', 'varchar', 4);
		$this -> hasColumn('Quantity', 'varchar', 4);
		$this -> hasColumn('Source', 'varchar', 10);
		$this -> hasColumn('Type', 'varchar', 1);
		$this -> hasColumn('Supplied', 'varchar', 1);
	}

	public function setUp() {
		$this -> setTableName('drugcode');
		$this -> hasOne('Generic_Name as Generic', array('local' => 'Generic_Name', 'foreign' => 'id'));
		$this -> hasOne('Drug_Unit as Drug_Unit', array('local' => 'Unit', 'foreign' => 'id'));
		$this -> hasOne('Supporter as Supporter', array('local' => 'Supported_By', 'foreign' => 'id'));
		$this -> hasMany('Brand as Brands', array('local' => 'id', 'foreign' => 'Drug_Id'));
		$this -> hasOne('Dose as Drug_Dose', array('local' => 'Dose', 'foreign' => 'id'));
		$this -> hasMany('Cdrr_Item as Cdrr_Objects', array('local' => 'id', 'foreign' => 'Drug_Id'));

	}

	public function getAll($source = 0) {
		$query = Doctrine_Query::create() -> select("Drug,Pack_Size,Safety_Quantity,Quantity,Duration") -> from("Drugcode") -> where('Source = "' . $source . '" or Source ="0"') -> orderBy("id asc");
		$drugsandcodes = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $drugsandcodes;
	}

	public function getARVs() {
		$query = Doctrine_Query::create() -> select("Drug,Pack_Size,Safety_Quantity,Quantity,Duration") -> from("Drugcode") -> where("None_Arv != '1'") -> orderBy("id asc");
		$drugsandcodes = $query -> execute(array(), Doctrine::HYDRATE_ARRAY);
		return $drugsandcodes;
	}

	public function getAllObjects($source = 0) {
		$query = Doctrine_Query::create() -> select("Drug,Pack_Size,Safety_Quantity,Quantity,Duration") -> from("Drugcode") -> where("Supplied = '1'") -> orderBy("id asc");
		$drugsandcodes = $query -> execute(array());
		return $drugsandcodes;
	}

	public function getBrands() {
		$query = Doctrine_Query::create() -> select("id,Drug") -> from("Drugcode");
		$drugsandcodes = $query -> execute();
		return $drugsandcodes;
	}

	public function getTotalNumber($source = 0) {
		$query = Doctrine_Query::create() -> select("count(*) as Total_Drugs") -> from("Drugcode") -> where('Source = "' . $source . '" or Source ="0"');
		$total = $query -> execute();
		return $total[0]['Total_Drugs'];
	}

	public function getPagedDrugs($offset, $items, $source = 0) {
		$query = Doctrine_Query::create() -> select("Drug,Unit,Pack_Size,Safety_Quantity,Generic_Name,Supported_By,Dose,Duration,Quantity,Source") -> from("Drugcode") -> where('Source = "' . $source . '" or Source ="0"') -> offset($offset) -> limit($items);
		$drugs = $query -> execute();
		return $drugs;
	}

}
?>
