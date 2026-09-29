require "rails_helper"

RSpec.describe "Orders", type: :system do
  def add_item_and_visit_new_order
    product = Product.new(name: "テスト商品", status: :published)
    sku = product.skus.build(code: "TEST-01", price: 100, stock: 5)
    product.save!

    visit product_path(product)
    select "#{sku.code} (#{ActionController::Base.helpers.number_with_delimiter(sku.price)}円)", from: "SKU"
    click_button "カートに追加"
    expect(page).to have_content("カートに追加しました")

    visit new_order_path
    expect(page).to have_content("お届け先住所")
  end

  def fill_in_shipping_address(postal_code:, prefecture:, city:, address_line:)
    find(".js-shipping-field[data-field='postal_code']").set(postal_code)
    find(".js-shipping-field[data-field='prefecture']").set(prefecture)
    find(".js-shipping-field[data-field='city']").set(city)
    find(".js-shipping-field[data-field='address_line']").set(address_line)
  end

  it "「お届け先住所と同じ」にチェックすると請求先住所へ自動でコピーされ、編集不可になる" do
    add_item_and_visit_new_order

    fill_in_shipping_address(postal_code: "1000001", prefecture: "東京都", city: "千代田区", address_line: "1-1-1")
    check "お届け先住所と同じ"

    expect(find(".js-billing-field[data-field='postal_code']").value).to eq("1000001")
    expect(find(".js-billing-field[data-field='prefecture']").value).to eq("東京都")
    expect(find(".js-billing-field[data-field='city']").value).to eq("千代田区")
    expect(find(".js-billing-field[data-field='address_line']").value).to eq("1-1-1")
    expect(page).to have_css(".js-billing-field[readonly]", count: 4)
  end

  it "チェック済みの状態でお届け先住所を変更すると請求先住所も追従する" do
    add_item_and_visit_new_order

    fill_in_shipping_address(postal_code: "1000001", prefecture: "東京都", city: "千代田区", address_line: "1-1-1")
    check "お届け先住所と同じ"

    find(".js-shipping-field[data-field='postal_code']").set("9999999")

    expect(find(".js-billing-field[data-field='postal_code']").value).to eq("9999999")
  end

  it "チェックを外すと請求先住所は再び編集可能になる" do
    add_item_and_visit_new_order

    fill_in_shipping_address(postal_code: "1000001", prefecture: "東京都", city: "千代田区", address_line: "1-1-1")
    check "お届け先住所と同じ"
    uncheck "お届け先住所と同じ"

    expect(page).to have_no_css(".js-billing-field[readonly]")
  end
end
