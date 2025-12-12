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

ActiveRecord::Schema[8.0].define(version: 2025_12_11_231144) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_admin_users_on_username", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "full_name"
    t.string "role"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string "author_name"
    t.text "biography"
    t.string "nationality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 2, null: false
    t.decimal "tax_rate", precision: 5, scale: 2, default: "0.0"
    t.string "tax_name"
    t.string "currency_code", limit: 3, default: "CAD"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.string "discount_type"
    t.decimal "discount_value"
    t.boolean "active"
    t.datetime "expires_at"
    t.integer "usage_limit"
    t.integer "times_used"
    t.decimal "minimum_purchase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "discount_category"
    t.integer "applies_to_quantity"
    t.boolean "first_time_buyer_only"
    t.datetime "flash_sale_ends_at"
    t.string "name"
    t.text "tags"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "postal_code"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.bigint "province_id"
    t.string "stripe_customer_id"
    t.string "phone"
    t.bigint "country_id"
    t.boolean "is_canada", default: true
    t.index ["country_id"], name: "index_customers_on_country_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["province_id"], name: "index_customers_on_province_id"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_customers_on_stripe_customer_id"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "registered_at"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_event_registrations_on_customer_id"
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "event_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.string "location", null: false
    t.string "venue_name"
    t.integer "max_attendees"
    t.integer "current_attendees", default: 0
    t.datetime "registration_deadline"
    t.boolean "active", default: true
    t.boolean "featured", default: false
    t.text "organizer_info"
    t.decimal "ticket_price", precision: 10, scale: 2
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_events_on_active"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["featured"], name: "index_events_on_featured"
    t.index ["starts_at"], name: "index_events_on_starts_at"
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "location", null: false
    t.string "linkedin_url"
    t.string "portfolio_url"
    t.string "current_company"
    t.string "years_experience", null: false
    t.text "why_interested", null: false
    t.string "availability", null: false
    t.decimal "salary_expectation", precision: 10, scale: 2
    t.text "additional_notes"
    t.boolean "consent", default: false, null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_job_applications_on_created_at"
    t.index ["email"], name: "index_job_applications_on_email"
    t.index ["job_id", "email"], name: "index_job_applications_on_job_and_email", unique: true
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["status"], name: "index_job_applications_on_status"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.string "department", null: false
    t.string "job_type", null: false
    t.string "location", null: false
    t.string "experience_level", null: false
    t.text "description", null: false
    t.text "responsibilities", null: false
    t.text "requirements", null: false
    t.text "preferred_qualifications"
    t.text "benefits"
    t.decimal "salary_min", precision: 10, scale: 2
    t.decimal "salary_max", precision: 10, scale: 2
    t.datetime "application_deadline"
    t.string "contact_email", null: false
    t.boolean "active", default: true, null: false
    t.boolean "featured", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_jobs_on_active"
    t.index ["created_at"], name: "index_jobs_on_created_at"
    t.index ["department"], name: "index_jobs_on_department"
    t.index ["experience_level"], name: "index_jobs_on_experience_level"
    t.index ["featured"], name: "index_jobs_on_featured"
    t.index ["job_type"], name: "index_jobs_on_job_type"
    t.index ["location"], name: "index_jobs_on_location"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price_at_purchase"
    t.decimal "subtotal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.datetime "order_date"
    t.decimal "total_amount"
    t.string "order_status"
    t.string "payment_method"
    t.string "shipping_address"
    t.string "city"
    t.string "country"
    t.string "postal_code"
    t.datetime "shipped_date"
    t.datetime "delivered_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "gst_rate", precision: 5, scale: 2, default: "0.0"
    t.decimal "pst_rate", precision: 5, scale: 2, default: "0.0"
    t.decimal "hst_rate", precision: 5, scale: 2, default: "0.0"
    t.bigint "province_id"
    t.string "stripe_payment_id"
    t.string "stripe_customer_id"
    t.decimal "discount_amount"
    t.string "coupon_code"
    t.bigint "country_id"
    t.boolean "is_canada", default: true
    t.index ["country_id"], name: "index_orders_on_country_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["province_id"], name: "index_orders_on_province_id"
    t.index ["stripe_customer_id"], name: "index_orders_on_stripe_customer_id"
    t.index ["stripe_payment_id"], name: "index_orders_on_stripe_payment_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "product_authors", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_product_authors_on_author_id"
    t.index ["product_id"], name: "index_product_authors_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "isbn"
    t.text "description"
    t.decimal "current_price"
    t.integer "stock_quantity"
    t.bigint "category_id", null: false
    t.string "publisher"
    t.date "publication_date"
    t.integer "pages"
    t.string "language"
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "average_rating", precision: 3, scale: 2, default: "0.0"
    t.integer "ratings_count", default: 0
    t.boolean "on_sale", default: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.decimal "gst_rate"
    t.decimal "pst_rate"
    t.decimal "hst_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "customer_id", null: false
    t.integer "score", null: false
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_ratings_on_customer_id"
    t.index ["product_id", "customer_id"], name: "index_ratings_on_product_id_and_customer_id"
    t.index ["product_id"], name: "index_ratings_on_product_id"
  end

  create_table "site_contents", force: :cascade do |t|
    t.string "page_name"
    t.text "content"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_by_id"], name: "index_site_contents_on_updated_by_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "product_id"], name: "index_wishlists_on_customer_id_and_product_id", unique: true
    t.index ["customer_id"], name: "index_wishlists_on_customer_id"
    t.index ["product_id"], name: "index_wishlists_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customers", "countries"
  add_foreign_key "customers", "provinces"
  add_foreign_key "event_registrations", "customers"
  add_foreign_key "event_registrations", "events"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "countries"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "provinces"
  add_foreign_key "product_authors", "authors"
  add_foreign_key "product_authors", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "ratings", "customers"
  add_foreign_key "ratings", "products"
  add_foreign_key "site_contents", "admins", column: "updated_by_id"
  add_foreign_key "wishlists", "customers"
  add_foreign_key "wishlists", "products"
end
