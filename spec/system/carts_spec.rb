require 'rails_helper'

RSpec.describe "Carts", type: :system do
  def add_test_item_to_cart(name:, code:)
    product = Product.new(name: name, status: :published)
    sku = product.skus.build(code: code, price: 100, stock: 5)
    product.save!

    visit product_path(product)
    select sku.code_with_price, from: 'SKU'
    click_button 'カートに追加'

    product
  end

  it 'カート削除ボタンはブラウザ標準ではなく独自の確認モーダルを表示する' do
    product = add_test_item_to_cart(name: 'カート削除確認用', code: "CART-CANCEL-#{SecureRandom.hex(4)}")

    visit cart_path
    click_button '削除'

    within '#confirmModal' do
      expect(page).to have_text('削除しますか？')
      click_button 'キャンセル'
    end

    expect(page).to have_text(product.name)
  end

  it '確認モーダルでOKを押すとカートから商品が削除される' do
    product = add_test_item_to_cart(name: 'カート削除実行用', code: "CART-OK-#{SecureRandom.hex(4)}")

    visit cart_path
    click_button '削除'
    within('#confirmModal') { click_button 'OK' }

    expect(page).to have_text('カートから削除しました')
    expect(page).to have_no_text(product.name)
  end
end
