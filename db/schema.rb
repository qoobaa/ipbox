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

ActiveRecord::Schema.define(version: 2020_02_20_134531) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.datetime "committed_at"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "hours"
    t.integer "type"
    t.bigint "invoice_id"
    t.string "sha"
    t.bigint "repository_id"
    t.boolean "exact", default: false, null: false
    t.index ["invoice_id"], name: "index_entries_on_invoice_id"
    t.index ["repository_id"], name: "index_entries_on_repository_id"
    t.index ["sha", "repository_id"], name: "index_entries_on_sha_and_repository_id", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.string "number"
    t.date "from"
    t.date "to"
    t.decimal "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.integer "default_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "entries", "invoices"
  add_foreign_key "entries", "repositories"
end
