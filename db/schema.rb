# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160224192109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "permalink"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "title"
    t.string   "phone_office"
    t.string   "phone_mobile"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "last_name"
    t.string   "permalink"
    t.integer  "user_id"
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id", using: :btree
  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "cover_letters", force: :cascade do |t|
    t.integer  "job_application_id"
    t.string   "content"
    t.date     "sent_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "cover_letters", ["job_application_id"], name: "index_cover_letters_on_job_application_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "job_applications", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
    t.integer  "user_id"
  end

  add_index "job_applications", ["company_id"], name: "index_job_applications_on_company_id", using: :btree
  add_index "job_applications", ["user_id"], name: "index_job_applications_on_user_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "notable_id",   null: false
    t.string   "notable_type", null: false
    t.text     "contents"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id",      null: false
  end

  add_index "notes", ["notable_id"], name: "index_notes_on_notable_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "postings", force: :cascade do |t|
    t.integer  "job_application_id"
    t.string   "content"
    t.date     "posting_date"
    t.string   "source"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "job_title"
  end

  add_index "postings", ["job_application_id"], name: "index_postings_on_job_application_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "contacts", "users"
  add_foreign_key "cover_letters", "job_applications"
  add_foreign_key "job_applications", "companies"
  add_foreign_key "job_applications", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "postings", "job_applications"
end
