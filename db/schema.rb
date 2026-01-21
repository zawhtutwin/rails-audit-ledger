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

ActiveRecord::Schema[8.0].define(version: 2026_01_21_170142) do
  create_table "ledger_entries", force: :cascade do |t|
    t.integer "wallet_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "entry_type", null: false
    t.string "operation_id", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operation_id"], name: "index_ledger_entries_on_operation_id", unique: true
    t.index ["wallet_id"], name: "index_ledger_entries_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "owner_reference", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_reference"], name: "index_wallets_on_owner_reference", unique: true
  end

  add_foreign_key "ledger_entries", "wallets"
end
