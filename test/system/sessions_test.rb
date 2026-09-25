require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  test 'ログインしたままにするチェックボックスはラベルの中に入れ子になっている' do
    visit new_user_session_path

    assert_selector '.checkbox label input#user_remember_me[type="checkbox"]'
  end

  test 'ログインしたままにするをチェックしてログインできる' do
    user = User.create!(
      name: 'システムテスト太郎',
      email: "system-test-#{SecureRandom.hex(4)}@example.com",
      password: 'password123',
      password_confirmation: 'password123'
    )

    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password123'
    check 'user_remember_me'
    click_button 'ログイン'

    assert_selector 'a', text: 'ログアウト'
  end
end
