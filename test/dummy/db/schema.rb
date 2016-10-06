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

ActiveRecord::Schema.define(version: 20161006150040) do

  create_table "jera_push_devices", force: :cascade do |t|
    t.string   "token"
    t.string   "platform"
    t.integer  "resource_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "jera_push_devices", ["platform"], name: "index_jera_push_devices_on_platform"
  add_index "jera_push_devices", ["resource_id"], name: "index_jera_push_devices_on_resource_id"
  add_index "jera_push_devices", ["token", "platform"], name: "index_jera_push_devices_on_token_and_platform", unique: true
  add_index "jera_push_devices", ["token"], name: "index_jera_push_devices_on_token"

  create_table "jera_push_messages", force: :cascade do |t|
    t.text     "content"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jera_push_messages_devices", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "message_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "jera_push_messages_devices", ["device_id", "message_id"], name: "jera_push_index_messages_id_devices_id", unique: true
  add_index "jera_push_messages_devices", ["device_id"], name: "index_jera_push_messages_devices_on_device_id"
  add_index "jera_push_messages_devices", ["message_id"], name: "index_jera_push_messages_devices_on_message_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
