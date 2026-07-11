# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_07_04_031114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contract_amendments", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.date "amendment_start_date"
    t.date "amendment_end_date"
    t.decimal "amendment_rent_value"
    t.string "amendment_contract_period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_amendments_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "tenant_id", null: false
    t.bigint "owner_id", null: false
    t.decimal "rent_value"
    t.integer "contract_period"
    t.date "start_date"
    t.date "end_date"
    t.date "signature_date"
    t.decimal "interest_rate"
    t.decimal "fine_rate"
    t.string "guarantee"
    t.decimal "guarantee_value"
    t.date "guarantee_payment_date"
    t.integer "guarantee_installments"
    t.integer "payment_method"
    t.integer "payment_day"
    t.date "first_payment_date"
    t.decimal "first_payment_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["owner_id"], name: "index_contracts_on_owner_id"
    t.index ["property_id"], name: "index_contracts_on_property_id"
    t.index ["tenant_id"], name: "index_contracts_on_tenant_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.bigint "property_id", null: false
    t.string "inspection_type"
    t.date "inspection_date"
    t.text "checklist"
    t.text "observations"
    t.string "status"
    t.string "entry_type"
    t.date "landlord_signature_date"
    t.date "tenant_signature_date"
    t.string "landlord_name"
    t.string "tenant_name"
    t.string "landlord_document"
    t.string "tenant_document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inspector_name"
    t.index ["contract_id"], name: "index_inspections_on_contract_id"
    t.index ["property_id"], name: "index_inspections_on_property_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.string "rg"
    t.string "marital_status"
    t.string "nationality"
    t.string "phone"
    t.string "email"
    t.string "zip_code"
    t.string "street"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "complement"
    t.integer "status"
    t.integer "person_type"
    t.text "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "reference"
    t.string "zip_code"
    t.string "street"
    t.string "neighborhood"
    t.string "number"
    t.string "city"
    t.string "state"
    t.string "complement"
    t.decimal "rent_value"
    t.integer "property_type"
    t.integer "category"
    t.integer "status"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_properties_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "master", default: false, null: false
    t.boolean "must_change_password", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contract_amendments", "contracts"
  add_foreign_key "contracts", "people", column: "owner_id"
  add_foreign_key "contracts", "people", column: "tenant_id"
  add_foreign_key "contracts", "properties"
  add_foreign_key "inspections", "contracts"
  add_foreign_key "inspections", "properties"
  add_foreign_key "properties", "people", column: "owner_id"
end
