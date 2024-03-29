# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_06_054151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "features", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.index ["service_id"], name: "index_features_on_service_id"
    t.index ["user_id"], name: "index_features_on_user_id"
  end

  create_table "mappings", force: :cascade do |t|
    t.string "user_column"
    t.string "ec_column"
    t.integer "data_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "version_id"
    t.index ["version_id"], name: "index_mappings_on_version_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_cols", force: :cascade do |t|
    t.bigint "service_format_id", null: false
    t.string "ec_column"
    t.integer "data_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_format_id"], name: "index_service_cols_on_service_format_id"
  end

  create_table "service_formats", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "version"
    t.boolean "active"
    t.boolean "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_formats_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "platform_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "icon"
    t.index ["platform_id"], name: "index_services_on_platform_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "user_name", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "company_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.datetime "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.bigint "feature_id", null: false
    t.boolean "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_format_id", null: false
    t.index ["feature_id"], name: "index_versions_on_feature_id"
    t.index ["service_format_id"], name: "index_versions_on_service_format_id"
  end

  add_foreign_key "features", "services"
  add_foreign_key "features", "users"
  add_foreign_key "mappings", "versions"
  add_foreign_key "service_cols", "service_formats"
  add_foreign_key "service_formats", "services"
  add_foreign_key "services", "platforms"
  add_foreign_key "versions", "features"
  add_foreign_key "versions", "service_formats"
end
