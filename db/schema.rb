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

ActiveRecord::Schema.define(version: 20150730181756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id", using: :btree

  create_table "cover_letters", force: :cascade do |t|
    t.integer  "job_application_id"
    t.string   "content"
    t.date     "sent_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "cover_letters", ["job_application_id"], name: "index_cover_letters_on_job_application_id", using: :btree

  create_table "interactions", force: :cascade do |t|
    t.integer  "contact_id"
    t.string   "notes"
    t.date     "approx_date"
    t.string   "medium"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interactions", ["contact_id"], name: "index_interactions_on_contact_id", using: :btree

  create_table "job_applications", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
  end

  add_index "job_applications", ["company_id"], name: "index_job_applications_on_company_id", using: :btree

  create_table "postings", force: :cascade do |t|
    t.integer  "job_application_id"
    t.string   "content"
    t.date     "posting_date"
    t.string   "source"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "postings", ["job_application_id"], name: "index_postings_on_job_application_id", using: :btree

  add_foreign_key "contacts", "companies"
  add_foreign_key "cover_letters", "job_applications"
  add_foreign_key "interactions", "contacts"
  add_foreign_key "job_applications", "companies"
  add_foreign_key "postings", "job_applications"
end
