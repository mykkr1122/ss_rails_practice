require "rails_helper"

RSpec.describe "Sessions", type: :system do
  it "ログインしたままにするチェックボックスはラベルの中に入れ子になっている" do
    visit new_user_session_path

    expect(page).to have_selector('.checkbox label input#user_remember_me[type="checkbox"]')
  end

  it "ログインしたままにするをチェックしてログインできる" do
    user = User.create!(
      name: "システムテスト太郎",
      email: "system-test-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password123"
    check "user_remember_me"
    click_button "ログイン"

    expect(page).to have_selector("a", text: "ログアウト")
  end
end
