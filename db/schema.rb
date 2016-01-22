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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150615120821) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "api_keys", ["access_token"], :name => "index_api_keys_on_access_token"
  add_index "api_keys", ["user_id"], :name => "index_api_keys_on_user_id"

  create_table "conversations", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "conversations", ["recipient_id"], :name => "index_conversations_on_recipient_id"
  add_index "conversations", ["sender_id"], :name => "index_conversations_on_sender_id"

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "is_read",         :default => false
  end

  add_index "messages", ["conversation_id"], :name => "index_messages_on_conversation_id"
  add_index "messages", ["is_read"], :name => "index_messages_on_is_read"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "f_name"
    t.string   "l_name"
    t.datetime "birthday"
    t.string   "gender"
    t.integer  "phone"
    t.string   "occupation"
    t.boolean  "have_room"
    t.boolean  "is_activate"
    t.string   "hobbies"
    t.string   "uid"
    t.string   "provider"
    t.string   "image_url"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["have_room", "is_activate", "gender"], :name => "index_users_on_have_room_and_is_activate_and_gender"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
