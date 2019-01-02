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

ActiveRecord::Schema.define(version: 20190102005455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

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
    t.text     "note"
    t.string   "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.uuid     "uuid"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
    t.datetime "published_at"
    t.string   "slug",         null: false
    t.index ["deleted_at"], name: "index_organizations_on_deleted_at", using: :btree
    t.index ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree
    t.index ["uuid"], name: "index_organizations_on_uuid", unique: true, using: :btree
  end

  create_table "outreaches", id: :bigserial, force: :cascade do |t|
    t.uuid     "uuid"
    t.text     "subject"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["subject"], name: "index_outreaches_on_subject", using: :btree
    t.index ["uuid"], name: "index_outreaches_on_uuid", unique: true, using: :btree
  end

  create_table "outreaches_users", id: false, force: :cascade do |t|
    t.bigint "outreach_id", null: false
    t.bigint "user_id",     null: false
  end

  create_table "questions", force: :cascade do |t|
    t.uuid     "uuid"
    t.string   "slug",                             null: false
    t.string   "description"
    t.text     "question_text",                    null: false
    t.string   "question_type",                    null: false
    t.text     "question_subtext"
    t.text     "question_choices", default: [],                 array: true
    t.boolean  "queryable",        default: false
    t.integer  "survey_id",                        null: false
    t.integer  "index"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "required",         default: false
    t.index ["index", "survey_id"], name: "index_questions_on_index_and_survey_id", unique: true, using: :btree
    t.index ["slug", "survey_id"], name: "index_questions_on_slug_and_survey_id", unique: true, using: :btree
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

  create_table "survey_responses", force: :cascade do |t|
    t.uuid     "uuid",                           null: false
    t.integer  "user_id",                        null: false
    t.integer  "survey_id",                      null: false
    t.integer  "organization_id",                null: false
    t.jsonb    "response",        default: "{}", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["response"], name: "index_survey_responses_on_response", using: :gin
    t.index ["user_id", "survey_id", "organization_id"], name: "sr_index", unique: true, using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.uuid     "uuid"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_surveys_on_organization_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.uuid     "uuid"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "fostered_before"
    t.boolean  "fospice"
    t.datetime "accepted_terms_at"
    t.boolean  "other_pets"
    t.boolean  "kids"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "date_of_birth"
    t.text     "fostered_for",      default: [],              array: true
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.boolean  "fosters_cats"
    t.boolean  "big_dogs"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree
  end

end
