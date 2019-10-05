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

ActiveRecord::Schema.define(version: 20191004092441) do

  create_table "attendance_logs", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rireki_num", default: 1, null: false
    t.integer "superior_id"
    t.string "superior_chk_kbn"
    t.string "process_kbn"
    t.date "approval_at"
    t.boolean "update_kbn"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.datetime "end_estimated_time"
    t.boolean "next_day_flag"
    t.string "job_content"
    t.index ["attendance_id"], name: "index_attendance_logs_on_attendance_id"
    t.index ["user_id"], name: "index_attendance_logs_on_user_id"
  end

  create_table "attendance_news", force: :cascade do |t|
    t.date "worked_on"
    t.integer "superior_id"
    t.string "superior_chk_kbn"
    t.string "process_kbn"
    t.date "approval_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "upd_flg", default: false
    t.boolean "del_flg", default: false
    t.integer "attendance_id"
    t.index ["attendance_id"], name: "index_attendance_news_on_attendance_id"
    t.index ["user_id"], name: "index_attendance_news_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rireki_num", default: 1, null: false
    t.integer "superior_id"
    t.string "superior_chk_kbn", default: "0"
    t.string "process_kbn"
    t.date "approval_at"
    t.boolean "update_kbn", default: false
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.datetime "end_estimated_time"
    t.boolean "next_day_flag"
    t.string "job_content"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "name"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2019-02-19 22:30:00"
    t.datetime "work_time", default: "2019-02-19 23:00:00"
    t.string "remember_digest"
    t.boolean "superior", default: false
    t.string "employee_number"
    t.string "uid"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
