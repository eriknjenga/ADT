class CreateFrenchFactoryMasters < ActiveRecord::Migration
  def self.up
    create_table :french_factory_masters do |t|
      t.primary_key :id
      t.string :name
    end
  end

  def self.down
    drop_table :french_factory_masters
  end
end
