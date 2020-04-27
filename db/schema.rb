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

ActiveRecord::Schema.define(version: 2020_04_27_124111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.bigint "user_id", null: false
    t.index ["external_id", "user_id"], name: "index_entries_on_external_id_and_user_id", unique: true
    t.index ["invoice_id"], name: "index_entries_on_invoice_id"
    t.index ["project_id"], name: "index_entries_on_project_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "number"
    t.date "from"
    t.date "to"
    t.decimal "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "default_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["uuid"], name: "index_projects_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_name"
    t.string "address"
    t.string "postal_code"
    t.string "city"
    t.string "vatin"
    t.string "stripe_customer_id"
    t.string "stripe_payment_intent_id"
    t.boolean "tos_accepted"
    t.boolean "einvoice_accepted"
    t.string "payu_order_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "invoices"
  add_foreign_key "entries", "projects"
  add_foreign_key "entries", "users"
  add_foreign_key "invoices", "users"
  add_foreign_key "projects", "users"
end
