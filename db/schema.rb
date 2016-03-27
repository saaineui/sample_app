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

ActiveRecord::Schema.define(version: 20160327064537) do

  create_table "affinities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "affinities_users", id: false, force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "affinity_id", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "location"
    t.integer  "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookmarks", ["book_id"], name: "index_bookmarks_on_book_id"
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "author"
    t.string   "logo_url"
    t.text     "epigraph"
    t.text     "copyright"
    t.string   "background_image_url"
    t.string   "cover_image_url"
  end

  create_table "books_sections", id: false, force: :cascade do |t|
    t.integer "book_id",    null: false
    t.integer "section_id", null: false
  end

  add_index "books_sections", ["book_id"], name: "index_books_sections_on_book_id"
  add_index "books_sections", ["section_id"], name: "index_books_sections_on_section_id"

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.integer  "order"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "chapter"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
