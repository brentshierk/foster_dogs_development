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

ActiveRecord::Schema.define(version: 20170601000916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "line_one"
    t.string   "line_two"
    t.string   "city"
    t.string   "zip"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.string   "name"
    t.text     "short_code"
    t.text     "image_url"
    t.datetime "archived_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.date     "birthday"
    t.boolean  "urgent",      default: false
    t.string   "breed"
    t.integer  "weight"
    t.index ["short_code"], name: "index_dogs_on_short_code", unique: true, using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "author_id"], name: "index_notes_on_user_id_and_author_id", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dog_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_statuses_on_dog_id", using: :btree
    t.index ["user_id"], name: "index_statuses_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.uuid     "uuid"
    t.string   "experience"
    t.string   "schedule"
    t.boolean  "fospice"
    t.datetime "accepted_terms_at"
    t.text     "other_pets"
    t.text     "kids"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree
  end

end
