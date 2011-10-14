class CreateGermanFactoryMasters < ActiveRecord::Migration
  def self.up
    create_table :german_factory_masters do |t|
      t.primary_key :id
      t.string :name
    end
  end

  def self.down
    drop_table :german_factory_masters
  end
end
