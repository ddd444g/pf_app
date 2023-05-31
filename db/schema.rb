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

ActiveRecord::Schema.define(version: 2023_05_31_082127) do
  create_table "gone_places", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.string "review"
    t.integer "score"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "place_id"
    t.boolean "once_again", default: false, null: false
    t.integer "recommend_place_id"
    t.boolean "recommend", default: false, null: false
    t.index ["recommend_place_id"], name: "index_gone_places_on_recommend_place_id"
  end

  create_table "places", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "memo"
    t.integer "recommend_place_id"
    t.string "googlemap_name"
  end

  create_table "plan_places", charset: "utf8mb4", force: :cascade do |t|
    t.string "plan_place_name"
    t.string "memo"
    t.float "latitude"
    t.float "longitude"
    t.integer "user_id"
    t.integer "plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.integer "place_id"
    t.integer "gone_place_id"
  end

  create_table "plans", charset: "utf8mb4", force: :cascade do |t|
    t.string "plan_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "plan_color"
  end

  create_table "recommend_places", charset: "utf8mb4", force: :cascade do |t|
    t.string "recommend_place_name"
    t.string "recommend_comment"
    t.integer "user_id"
    t.integer "gone_place_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "password_digest"
    t.boolean "guest", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, length: 191
  end
end
