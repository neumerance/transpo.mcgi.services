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

ActiveRecord::Schema[7.1].define(version: 2024_10_20_034649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "drivers_on_duties", force: :cascade do |t|
    t.bigint "driver_id"
    t.integer "seat_capacity"
    t.datetime "on_duty_since"
    t.datetime "on_duty_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_drivers_on_duties_on_driver_id"
  end

  create_table "ride_requests", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "passenger_id"
    t.integer "seats", default: 1
    t.string "origin"
    t.string "destination"
    t.integer "status", default: 0
    t.datetime "pickup_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id", "passenger_id"], name: "index_ride_requests_on_driver_id_and_passenger_id"
    t.index ["driver_id"], name: "index_ride_requests_on_driver_id"
    t.index ["passenger_id"], name: "index_ride_requests_on_passenger_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "phone"
    t.integer "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "drivers_on_duties", "users", column: "driver_id"
  add_foreign_key "ride_requests", "users", column: "driver_id"
  add_foreign_key "ride_requests", "users", column: "passenger_id"
end
