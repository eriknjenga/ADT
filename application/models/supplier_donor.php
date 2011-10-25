<?php
class Supplier_Donor extends Doctrine_Record{
	
	public function setTableDefinition(){
		$this->hasColumn('supplier_donor','varchar',100);
	}
	
	public function setUp(){
		$this->setTableName('supplier_donor');
	}//end setUp
	
}
