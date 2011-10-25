<?php
class Drugcode extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('drug', 'varchar', 100);
		$this -> hasColumn('unit', 'varchar', 30);
		$this -> hasColumn('pack_size', 'int', 4);
		$this -> hasColumn('safety_quantity', 'int', 4);
		$this -> hasColumn('generic_name', 'varchar', 100);
		$this -> hasColumn('supported_by', 'varchar', 30);
		$this -> hasColumn('none_arv', 'int', 1);
		$this -> hasColumn('tb_drug', 'int', 1);
		$this -> hasColumn('drug_in_use', 'int', 1);
		$this -> hasColumn('comment', 'text');
		$this -> hasColumn('dose', 'varchar', 20);
		$this -> hasColumn('duration', 'int', 4);
		$this -> hasColumn('quantity', 'int', 4);
	}

	public function setUp() {
		$this -> setTableName('drugcode');
	}

	public function getDrugCodes() {
		$query = Doctrine_Query::create() -> select("id,drug") -> from("Drugcode");
		$drugsandcodes = $query -> execute();
		return $drugsandcodes;
	}

}
?>
