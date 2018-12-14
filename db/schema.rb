# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_14_160315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.text "subject", null: false
    t.text "details", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "day", null: false
    t.bigint "time_range_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", null: false
    t.index ["time_range_id"], name: "index_availabilities_on_time_range_id"
    t.index ["user_id", "time_range_id", "day"], name: "index_availabilities_on_user_id_and_time_range_id_and_day", unique: true
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "duties", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "timeslot_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "request_user_id"
    t.boolean "free", default: false, null: false
    t.index ["date", "timeslot_id"], name: "index_duties_on_date_and_timeslot_id", unique: true
    t.index ["timeslot_id"], name: "index_duties_on_timeslot_id"
    t.index ["user_id"], name: "index_duties_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problem_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "computer_number", null: false
    t.text "description", null: false
    t.boolean "is_critical"
    t.boolean "is_fixed", default: false, null: false
    t.boolean "is_fixable", default: true, null: false
    t.text "remarks"
    t.integer "place_id"
    t.boolean "is_blocked", default: false, null: false
    t.integer "reporter_user_id"
    t.integer "last_update_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "mc_only", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_ranges", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeslots", force: :cascade do |t|
    t.boolean "mc_only"
    t.bigint "default_user_id"
    t.bigint "time_range_id"
    t.bigint "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day"
    t.index ["default_user_id"], name: "index_timeslots_on_default_user_id"
    t.index ["place_id"], name: "index_timeslots_on_place_id"
    t.index ["time_range_id"], name: "index_timeslots_on_time_range_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "matric_num"
    t.string "contact_num"
    t.integer "cell", null: false
    t.boolean "mc", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "availabilities", "time_ranges"
  add_foreign_key "availabilities", "users"
  add_foreign_key "duties", "timeslots"
  add_foreign_key "duties", "users"
  add_foreign_key "problem_reports", "places"
  add_foreign_key "problem_reports", "users", column: "last_update_user_id"
  add_foreign_key "problem_reports", "users", column: "reporter_user_id"
  add_foreign_key "timeslots", "places"
  add_foreign_key "timeslots", "time_ranges"
  add_foreign_key "timeslots", "users", column: "default_user_id"
end
