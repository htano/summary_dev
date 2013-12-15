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

ActiveRecord::Schema.define(version: 20131203143214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contents_preview"
    t.decimal  "strength"
    t.datetime "last_added_at"
    t.string   "thumbnail"
    t.integer  "summaries_count",           default: 0
    t.integer  "user_articles_count",       default: 0
    t.integer  "cluster_id",                default: 0
    t.string   "auto_summary_error_status"
    t.text     "html"
  end

  add_index "articles", ["last_added_at", "strength"], name: "idx_strength", using: :btree
  add_index "articles", ["url"], name: "idx_articles_on_url", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "idx_categories_on_name", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "favorite_users", force: true do |t|
    t.integer  "user_id",          null: false
    t.integer  "favorite_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_users", ["user_id", "favorite_user_id"], name: "index_favorite_users_on_user_id_and_favorite_user_id", unique: true, using: :btree

  create_table "good_summaries", force: true do |t|
    t.integer  "user_id"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "good_summaries", ["user_id", "summary_id"], name: "idx_good_summaries_on_user_id_and_summary_id", unique: true, using: :btree

  create_table "summaries", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "good_summaries_count", default: 0
  end

  add_index "summaries", ["user_id", "article_id"], name: "index_summaries_on_user_id_and_article_id", unique: true, using: :btree

  create_table "user_article_tags", force: true do |t|
    t.integer  "user_article_id"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_article_tags", ["user_article_id", "tag"], name: "index_user_article_tags_on_user_article_id_and_tag", unique: true, using: :btree

  create_table "user_articles", force: true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.boolean  "read_flg",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorite_flg", default: false
  end

  add_index "user_articles", ["user_id", "article_id"], name: "index_user_articles_on_user_id_and_article_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "mail_addr"
    t.boolean  "yuko_flg"
    t.datetime "last_login"
    t.datetime "last_mypage_access"
    t.string   "open_id"
    t.string   "prof_image",           default: "no_image.png"
    t.integer  "mail_addr_status"
    t.string   "token_uuid"
    t.datetime "token_expire"
    t.string   "full_name",            default: ""
    t.text     "comment",              default: ""
    t.string   "site_url",             default: ""
    t.boolean  "public_flg",           default: false
    t.string   "keep_login_token"
    t.datetime "keep_login_expire"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keep_login_ip"
    t.text     "cluster_vector"
    t.integer  "summaries_count"
    t.integer  "favorite_users_count"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["name"], name: "idx_name", unique: true, using: :btree
  add_index "users", ["open_id"], name: "idx_openid", unique: true, using: :btree

end
