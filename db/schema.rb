# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_09_233556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "title"
    t.string "naics_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "state_id", null: false
    t.string "street_address"
    t.string "city"
    t.string "zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_locations_on_organization_id"
    t.index ["state_id"], name: "index_locations_on_state_id"
  end

  create_table "occupation_standard_skills", force: :cascade do |t|
    t.bigint "occupation_standard_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sort_order", default: 0
    t.index ["occupation_standard_id"], name: "index_occupation_standard_skills_on_occupation_standard_id"
    t.index ["skill_id"], name: "index_occupation_standard_skills_on_skill_id"
  end

  create_table "occupation_standard_work_processes", force: :cascade do |t|
    t.bigint "occupation_standard_id", null: false
    t.bigint "work_process_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sort_order", default: 0
    t.index ["occupation_standard_id"], name: "occupation_standard_id_idx"
    t.index ["work_process_id"], name: "index_occupation_standard_work_processes_on_work_process_id"
  end

  create_table "occupation_standards", force: :cascade do |t|
    t.string "type"
    t.bigint "organization_id", null: false
    t.bigint "creator_id", null: false
    t.bigint "occupation_id", null: false
    t.boolean "data_trust_approval"
    t.bigint "parent_occupation_standard_id"
    t.bigint "industry_id"
    t.datetime "completed_at"
    t.datetime "published_at"
    t.string "pdf_file_url"
    t.string "excel_file_url"
    t.string "source_file_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_occupation_standards_on_creator_id"
    t.index ["industry_id"], name: "index_occupation_standards_on_industry_id"
    t.index ["occupation_id"], name: "index_occupation_standards_on_occupation_id"
    t.index ["organization_id"], name: "index_occupation_standards_on_organization_id"
    t.index ["parent_occupation_standard_id"], name: "index_occupation_standards_on_parent_occupation_standard_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "title"
    t.string "type"
    t.string "rapids_code"
    t.string "onet_code"
    t.string "onet_page_url"
    t.integer "term_length_min"
    t.integer "term_length_max"
    t.string "title_aliases", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rapids_code"], name: "index_occupations_on_rapids_code", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "type"
    t.string "title"
    t.string "logo_url"
    t.boolean "registers_standards"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.text "description"
    t.integer "usage_count"
    t.bigint "work_process_id", null: false
    t.bigint "parent_skill_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_skill_id"], name: "index_skills_on_parent_skill_id"
    t.index ["work_process_id"], name: "index_skills_on_work_process_id"
  end

  create_table "standards_registrations", force: :cascade do |t|
    t.bigint "occupation_standard_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "state_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["occupation_standard_id"], name: "index_standards_registrations_on_occupation_standard_id"
    t.index ["organization_id"], name: "index_standards_registrations_on_organization_id"
    t.index ["state_id"], name: "index_standards_registrations_on_state_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "short_name"
    t.string "long_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "task_records", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_processes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "locations", "organizations"
  add_foreign_key "locations", "states"
  add_foreign_key "occupation_standard_skills", "occupation_standards"
  add_foreign_key "occupation_standard_skills", "skills"
  add_foreign_key "occupation_standard_work_processes", "occupation_standards"
  add_foreign_key "occupation_standard_work_processes", "work_processes"
  add_foreign_key "occupation_standards", "industries"
  add_foreign_key "occupation_standards", "occupation_standards", column: "parent_occupation_standard_id"
  add_foreign_key "occupation_standards", "occupations"
  add_foreign_key "occupation_standards", "organizations"
  add_foreign_key "occupation_standards", "users", column: "creator_id"
  add_foreign_key "skills", "skills", column: "parent_skill_id"
  add_foreign_key "skills", "work_processes"
  add_foreign_key "standards_registrations", "occupation_standards"
  add_foreign_key "standards_registrations", "organizations"
  add_foreign_key "standards_registrations", "states"
end
