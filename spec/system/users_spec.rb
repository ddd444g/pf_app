require 'rails_helper'

RSpec.describe 'Users_system', type: :system do
  let!(:user) { create(:user) }

  describe 'ユーザー新規登録' do
    before do
      visit new_user_path
    end

    context 'フォームの入力値が正常の場合' do
      it 'ユーザーの新規作成が成功し行きたい場所一覧ページに移動すること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: "test@test.com"
        fill_in 'パスワード(6文字以上)', with: "123456"
        fill_in '確認用パスワード', with: "123456"
        click_button '入力を完了する'
        expect(current_path).to eq places_path
      end
    end

    context '名前未入力' do
    end

    context 'メールアドレス未入力' do
    end

    context '登録済メールアドレス' do
    end
  end

  describe 'userの情報が表示されてるか' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'
    end

    it 'nameが表示されていること' do
      expect(page).to have_content user.name
    end
  end
end
