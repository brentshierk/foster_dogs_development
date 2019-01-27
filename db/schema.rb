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

ActiveRecord::Schema.define(version: 2019_01_27_221816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "dogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "short_code"
    t.text "image_url"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.boolean "urgent", default: false
    t.string "breed"
    t.integer "weight"
    t.index ["short_code"], name: "index_dogs_on_short_code", unique: true
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "note"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.uuid "uuid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.string "slug", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["uuid"], name: "index_organizations_on_uuid", unique: true
  end

  create_table "outreaches", force: :cascade do |t|
    t.uuid "uuid"
    t.text "subject"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject"], name: "index_outreaches_on_subject"
    t.index ["uuid"], name: "index_outreaches_on_uuid", unique: true
  end

  create_table "outreaches_users", id: :serial, force: :cascade do |t|
    t.bigint "outreach_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.uuid "uuid"
    t.string "slug", null: false
    t.string "description"
    t.text "question_text", null: false
    t.string "question_type", null: false
    t.text "question_subtext"
    t.text "question_choices", default: [], array: true
    t.boolean "queryable", default: false
    t.integer "survey_id", null: false
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required", default: false
    t.boolean "displayable", default: false
    t.index ["index", "survey_id"], name: "index_questions_on_index_and_survey_id", unique: true
    t.index ["slug", "survey_id"], name: "index_questions_on_slug_and_survey_id", unique: true
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "dog_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_statuses_on_dog_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "survey_responses", id: :serial, force: :cascade do |t|
    t.uuid "uuid", null: false
    t.integer "user_id", null: false
    t.integer "survey_id", null: false
    t.integer "organization_id", null: false
    t.jsonb "response", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["response"], name: "index_survey_responses_on_response", using: :gin
    t.index ["user_id", "survey_id", "organization_id"], name: "sr_index", unique: true
  end

  create_table "surveys", id: :serial, force: :cascade do |t|
    t.uuid "uuid"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_surveys_on_organization_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.uuid "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accepted_terms_at"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "date_of_birth"
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
