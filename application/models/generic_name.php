<?php
class Generic_Name extends Doctrine_Record{

public function setTableDefinition() {
$this->hasColumn('name', 'varchar', 25);
}

public function setUp() {
$this->setTableName('generic_name');
 
}
 

}