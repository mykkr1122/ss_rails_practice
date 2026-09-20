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

ActiveRecord::Schema.define(version: 2026_09_18_084909) do

  create_table "cart_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sku_id", null: false
    t.index ["cart_id", "sku_id"], name: "index_cart_items_on_cart_id_and_sku_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["sku_id"], name: "index_cart_items_on_sku_id"
  end

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "sku_id", null: false
    t.integer "quantity", null: false
    t.integer "price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["sku_id"], name: "index_order_items_on_sku_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", null: false
    t.text "description"
    t.bigint "store_id"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "skus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "code", null: false
    t.integer "price", null: false
    t.integer "stock", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_skus_on_code", unique: true
    t.index ["product_id"], name: "index_skus_on_product_id"
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.integer "store_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_number"], name: "index_stores_on_store_number", unique: true
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "skus"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "skus"
  add_foreign_key "products", "stores"
  add_foreign_key "skus", "products"
end
