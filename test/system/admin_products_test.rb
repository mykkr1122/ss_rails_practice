require 'application_system_test_case'

class AdminProductsTest < ApplicationSystemTestCase
  def create_product_with_sku(name:, code:)
    product = Product.new(name: name, status: :published)
    product.skus.build(code: code, price: 100, stock: 1)
    product.save!
    product
  end

  test '削除ボタンはブラウザ標準ではなく独自の確認モーダルを表示する' do
    product = create_product_with_sku(name: 'モーダル削除確認用', code: "MODAL-CANCEL-#{SecureRandom.hex(4)}")

    visit admin_product_path(product)
    click_button '削除'

    within '#confirmModal' do
      assert_text '削除しますか？'
      click_button 'キャンセル'
    end

    assert_selector 'h1', text: product.name
    assert Product.exists?(product.id)
  end

  test '確認モーダルでOKを押すと商品が削除される' do
    product = create_product_with_sku(name: 'モーダル削除実行用', code: "MODAL-OK-#{SecureRandom.hex(4)}")

    visit admin_product_path(product)
    click_button '削除'
    within('#confirmModal') { click_button 'OK' }

    assert_text '商品を削除しました'
    assert_not Product.exists?(product.id)
  end

  test '編集画面のSKU削除列は見出しに「削除」がありチェックボックスのみが並ぶ' do
    product = products(:one)

    visit edit_admin_product_path(product)

    within 'table thead tr' do
      assert_text '削除'
    end

    within first('table tbody tr') do
      assert_selector 'input[type="checkbox"]'
      assert_no_text '削除'
    end
  end
end
