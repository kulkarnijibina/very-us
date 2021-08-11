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

ActiveRecord::Schema.define(version: 2021_03_30_060034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "application_configs", force: :cascade do |t|
    t.string "admin_contact_email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "irrelevant_match_reasons"
    t.text "report_couple_reasons"
    t.integer "chat_inactivity_threshold_in_days"
    t.integer "complete_profile_notify_time_in_hours"
    t.integer "add_partner_notify_time_in_hours"
    t.integer "fill_feedback_notify_time1_in_hours"
    t.integer "fill_feedback_notify_time2_in_hours"
    t.integer "matchlist_scheduler_time_in_hours"
    t.integer "reward_karma_score_time_in_hours"
    t.integer "save_for_later_scheduler_time_in_hours"
    t.integer "refresh_free_save_for_later_time_in_hours"
    t.datetime "matchlist_job_run_time"
  end

  create_table "balance_logs", force: :cascade do |t|
    t.bigint "transaction_id"
    t.bigint "wallet_id"
    t.integer "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_balance_logs_on_transaction_id"
    t.index ["wallet_id"], name: "index_balance_logs_on_wallet_id"
  end

  create_table "banners", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buckets", force: :cascade do |t|
    t.float "threshold_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "percentage_for_day"
  end

  create_table "burn_coins_features", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "coins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "burn_ons", force: :cascade do |t|
    t.integer "refresh_match_list"
    t.integer "per_save_for_later"
    t.integer "change_preference"
    t.integer "change_geography"
    t.integer "incognito_mode"
    t.integer "spotlight_focus"
    t.integer "edit_tags_on_match_list"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "refresh_matches_count"
    t.integer "spotlight_duration_in_mins"
    t.integer "incognito_duration_in_mins"
    t.integer "per_save_for_later_duration_in_days"
    t.integer "daily_free_per_save_for_later"
    t.integer "near_by_location_in_km"
  end

  create_table "chats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_deleted", default: false
  end

  create_table "coin_packages", force: :cascade do |t|
    t.string "title"
    t.integer "amount"
    t.integer "coins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "couple_chats", force: :cascade do |t|
    t.bigint "couple_profile_id"
    t.bigint "chat_id"
    t.datetime "clear_chat"
    t.boolean "is_deleted"
  end

  create_table "couple_profiles", force: :cascade do |t|
    t.date "anniversary"
    t.string "orientation"
    t.boolean "have_children"
    t.boolean "have_pets"
    t.string "do_for_fun"
    t.string "goals"
    t.string "values_needed"
    t.string "meetup_dates"
    t.boolean "chat_availability"
    t.integer "primary_user_id"
    t.integer "secondary_user_id"
    t.string "partner_number", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "personality_traits", default: [], array: true
    t.string "activities", default: [], array: true
    t.jsonb "irrelevant_match_counter", default: {}
    t.boolean "profile_completed", default: false
    t.boolean "verified_profile", default: false
    t.jsonb "secondary_user_details", default: {}
    t.boolean "first_time_change_to_personality_trait", default: true
    t.datetime "spotlight_on_time"
    t.datetime "incognito_time"
    t.integer "free_save_for_later_count", default: 1
    t.string "partner_country_code"
    t.string "place"
    t.string "status", default: "active"
    t.string "onboarding_status"
    t.boolean "initial_response_status", default: false
    t.jsonb "earnon_records", default: {}
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "earn_ons", force: :cascade do |t|
    t.integer "onboarding"
    t.integer "partner_app_download"
    t.integer "per_accept_chat"
    t.integer "initial_response"
    t.integer "media_posts_per_photo"
    t.integer "verification_status"
    t.integer "feedback_fill_per_couple_meet"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reward_points_to_karma_score"
    t.integer "profile_completed_score"
    t.integer "social_media_connected"
    t.integer "do_for_fun"
    t.integer "goals"
    t.integer "values_needed"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.bigint "couple_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_profile_pic", default: false
    t.index ["couple_profile_id"], name: "index_images_on_couple_profile_id"
  end

  create_table "jwt_allow_lists", force: :cascade do |t|
    t.string "jti", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_jwt_allow_lists_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_configs", force: :cascade do |t|
    t.string "default_latitude"
    t.string "default_longitude"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.bigint "locationable_id"
    t.string "locationable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locationable_id", "locationable_type"], name: "index_locations_on_locationable_id_and_locationable_type"
  end

  create_table "master_bucket_configs", force: :cascade do |t|
    t.jsonb "match_count_for_day"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "target_couple_id"
    t.integer "source_couple_id"
    t.bigint "bucket_id"
    t.float "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["bucket_id"], name: "index_matches_on_bucket_id"
  end

  create_table "meetup_feedbacks", force: :cascade do |t|
    t.bigint "meetup_id"
    t.integer "source_couple_id"
    t.integer "target_couple_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_couple_same"
    t.boolean "meet_again"
    t.boolean "couple_behaviour"
    t.string "couple_badge"
    t.index ["meetup_id"], name: "index_meetup_feedbacks_on_meetup_id"
  end

  create_table "meetups", force: :cascade do |t|
    t.integer "source_couple_id"
    t.integer "target_couple_id"
    t.integer "status"
    t.string "location"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_mark_read", default: false
    t.datetime "date_time"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "couple_profile_id"
    t.bigint "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_mark_read", default: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["couple_profile_id"], name: "index_messages_on_couple_profile_id"
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.bigint "user_id"
    t.string "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.boolean "is_read", default: false
    t.string "notification_text"
    t.bigint "notificationable_id"
    t.string "notificationable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "user_id"
    t.string "stripe_charge_id"
    t.string "status"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personality_traits_icons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "source_couple_id"
    t.integer "target_couple_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "action_expiration"
    t.string "reason"
  end

  create_table "spend_free_time_icons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "splash_screen_images", force: :cascade do |t|
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.integer "height"
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_splash_screen_images_on_imageable_type_and_imageable_id"
  end

  create_table "splash_screens", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "text1"
    t.string "text2"
    t.string "text3"
    t.integer "priority"
    t.string "background_color"
  end

  create_table "suggest_activities", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_suggest_activities_on_user_id"
  end

  create_table "temp_matches", force: :cascade do |t|
    t.integer "source_couple_id"
    t.integer "target_couple_id"
    t.float "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todo_details", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "payment_id"
    t.string "description"
    t.integer "status"
    t.integer "amount"
    t.bigint "wallet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_type"
    t.string "transaction_purpose"
    t.index ["payment_id"], name: "index_transactions_on_payment_id"
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.string "contact", default: ""
    t.string "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.date "date_of_birth"
    t.string "country_code"
    t.boolean "linkedin_verified", default: false
    t.boolean "facebook_verified", default: false
    t.boolean "instagram_verified", default: false
    t.string "stripe_customer_id"
    t.string "stripe_card_id"
    t.boolean "is_card_details_exists", default: false
    t.string "language"
    t.string "orientation"
    t.string "smoke"
    t.string "drink"
    t.string "occupation"
    t.boolean "otp_verified", default: false
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "couple_profile_id"
    t.bigint "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["couple_profile_id"], name: "index_wallets_on_couple_profile_id"
    t.index ["currency_id"], name: "index_wallets_on_currency_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "balance_logs", "transactions"
  add_foreign_key "balance_logs", "wallets"
  add_foreign_key "images", "couple_profiles"
  add_foreign_key "jwt_allow_lists", "users", on_delete: :cascade
  add_foreign_key "matches", "buckets"
  add_foreign_key "meetup_feedbacks", "meetups"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "couple_profiles"
  add_foreign_key "mobile_devices", "users"
  add_foreign_key "suggest_activities", "users"
  add_foreign_key "transactions", "payments"
  add_foreign_key "transactions", "wallets"
  add_foreign_key "wallets", "couple_profiles"
  add_foreign_key "wallets", "currencies"
end
