# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_01_120958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.datetime "ended_at"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "hours"
    t.integer "type"
    t.bigint "invoice_id"
    t.string "external_id"
    t.bigint "project_id"
    t.boolean "exact", default: false, null: false
    t.date "day"
    t.index ["external_id", "project_id"], name: "index_entries_on_external_id_and_project_id", unique: true
    t.index ["invoice_id"], name: "index_entries_on_invoice_id"
    t.index ["project_id"], name: "index_entries_on_project_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "number"
    t.date "from"
    t.date "to"
    t.decimal "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "default_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "entries", "invoices"
  add_foreign_key "entries", "projects"
end
