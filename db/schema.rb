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

ActiveRecord::Schema[7.2].define(version: 2024_12_10_113513) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "sign_up_start_date"
    t.string "title", null: false
    t.string "event_email"
    t.string "website"
    t.string "description", null: false
    t.string "country", null: false
    t.string "city", null: false
    t.text "dance_types", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.bigint "parent_event_id_id"
    t.index ["parent_event_id_id"], name: "index_events_on_parent_event_id_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", null: false
    t.string "email", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "events", column: "parent_event_id_id"
end
