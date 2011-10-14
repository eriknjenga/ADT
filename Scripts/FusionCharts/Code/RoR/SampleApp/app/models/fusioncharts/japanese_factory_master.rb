#Model class to store data of factory id and name.
#As per Ruby On Rails conventions, we have the corresponding table 
#japanese_factory_masters in the database.
class Fusioncharts::JapaneseFactoryMaster < ActiveRecord::Base
  has_many :factory_output_quantities,
                :order => 'date_pro asc', 
                :foreign_key=>"factory_master_id"
end
