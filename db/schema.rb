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

ActiveRecord::Schema.define(version: 20170620172028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deploy_environments", force: :cascade do |t|
    t.string "name"
    t.bigint "server_id"
    t.bigint "repository_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_deploy_environments_on_repository_id"
    t.index ["server_id"], name: "index_deploy_environments_on_server_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "organization"
    t.string "language"
    t.string "documentation_url"
    t.string "default_branch"
    t.string "slug"
    t.boolean "has_capistrano"
    t.boolean "has_travis"
    t.boolean "has_honeybadger"
    t.boolean "has_okcomputer"
    t.boolean "has_is_it_working"
    t.boolean "has_coveralls"
    t.boolean "is_private"
    t.boolean "is_gem"
    t.boolean "is_rails"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["has_capistrano"], name: "index_repositories_on_has_capistrano"
    t.index ["slug"], name: "index_repositories_on_slug", unique: true
  end

  create_table "servers", force: :cascade do |t|
    t.string "hostname"
    t.string "fqdn"
    t.inet "ip"
    t.string "dev_team"
    t.boolean "pupgraded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
