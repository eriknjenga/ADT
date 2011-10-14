<?php 
class  MY_Model  extends  CI_Model {

    function __construct()
    {
        parent::__construct();
         //Instantiate a Doctrine Entity Manager
        $this->em = $this->doctrine->em;
    }
    } 