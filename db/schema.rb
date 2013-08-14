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

ActiveRecord::Schema.define(version: 20130811052551) do

  create_table "articles", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "favorite_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "good_summaries", force: true do |t|
    t.integer  "user_id"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summaries", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_articles", force: true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.boolean  "read_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "mail_addr"
    t.boolean  "yuko_flg"
    t.datetime "last_login"
    t.string   "open_id"
    t.string   "prof_image", default: "no_image.png"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], name: "idx_name", unique: true
  add_index "users", ["open_id"], name: "idx_openid", unique: true

end
