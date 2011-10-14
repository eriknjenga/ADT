<?php
require_once('config/database.php');
 
// Configure Doctrine Cli
// Normally these are arguments to the cli tasks but if they are set here the arguments will be auto-filled
$config = array('data_fixtures_path'  =>  dirname(<strong>FILE</strong>) . DIRECTORY_SEPARATOR . '/fixtures',
                'models_path'         =>  dirname( <strong>FILE</strong> ) . DIRECTORY_SEPARATOR . '/models',
                'migrations_path'     =>  dirname( <strong>FILE</strong> ) . DIRECTORY_SEPARATOR . '/migrations',
                'sql_path'            =>  dirname( <strong>FILE</strong> ) . DIRECTORY_SEPARATOR . '/sql',
                'yaml_schema_path'    =>  dirname( <strong>FILE</strong> ) . DIRECTORY_SEPARATOR . '/schema',
                'generate_models_options' => array(
                        'generateBaseClasses' => true,
                        'baseClassPrefix' => 'Base_',
                        'baseClassesDirectory' => 'Base',
                        'classPrefixFiles' => false,
                        'classPrefix' => 'Model_',
                        'phpDocName' => '',
                        'phpDocEmail' => ''
                    ));
 
$cli = new Doctrine_Cli($config);
$cli->run($_SERVER['argv'])