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

ActiveRecord::Schema[7.1].define(version: 2025_05_01_095848) do
  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "city"
    t.string "state"
    t.string "booking_system"
    t.boolean "scraper_active", default: false
    t.boolean "has_antibot", default: false
    t.integer "blocked_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scrape_errors", force: :cascade do |t|
    t.integer "scrape_event_id", null: false
    t.string "error_type", null: false
    t.text "error_message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scrape_event_id"], name: "index_scrape_errors_on_scrape_event_id"
  end

  create_table "scrape_events", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "scrape_start", null: false
    t.datetime "scrape_end"
    t.integer "tee_time_count", default: 0
    t.boolean "has_error", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_scrape_events_on_course_id"
  end

  create_table "tee_times", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "scrape_event_id", null: false
    t.datetime "time", null: false
    t.integer "min_price_cents", default: 0
    t.integer "max_price_cents", default: 0
    t.boolean "is_hot_deal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_tee_times_on_course_id"
    t.index ["scrape_event_id"], name: "index_tee_times_on_scrape_event_id"
  end

  add_foreign_key "scrape_errors", "scrape_events"
  add_foreign_key "scrape_events", "courses"
  add_foreign_key "tee_times", "courses"
  add_foreign_key "tee_times", "scrape_events"
end
