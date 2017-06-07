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

ActiveRecord::Schema.define(version: 20170526221301) do

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "organization"
    t.string "language"
    t.string "documentation_url"
    t.boolean "has_capistrano"
    t.boolean "has_travis"
    t.boolean "has_honeybadger"
    t.boolean "has_okcomputer"
    t.boolean "has_is_it_working"
    t.boolean "has_coveralls"
    t.boolean "is_gem"
    t.boolean "is_rails"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
