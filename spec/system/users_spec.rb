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
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq places_path
      end
    end

    context '名前が未入力' do
      it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '名前', with: nil
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content '名前を入力してください'
      end
    end

    context 'メールアドレスが未入力' do
      it 'emailは必須なので登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context '登録済メールアドレスを入力した場合' do
      it '同じemailでは登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end

    context '無効な値をemailフォームに入力した場合' do
      it '正規表現ではないので登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: '@.@.@.@'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
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
