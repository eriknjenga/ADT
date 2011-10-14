# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define() do

  create_table "factory_masters", :force => true do |t|
    t.string "name"
  end

  create_table "factory_output_quantities", :force => true do |t|
    t.integer  "factory_master_id", :null => false
    t.datetime "date_pro"
    t.float    "quantity"
  end

  add_index "factory_output_quantities", ["factory_master_id"], :name => "FK_output_master"

  create_table "french_factory_masters", :force => true do |t|
    t.string "name"
  end

  create_table "japanese_factory_masters", :force => true do |t|
    t.string "name"
  end

end
