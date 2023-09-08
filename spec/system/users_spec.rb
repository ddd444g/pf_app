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

    context 'メールアドレスに不備がある場合登録出来ずにエラーメッセージが表示されるか' do
      it 'emailは必須なので登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      it '同じemailでは登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end

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

    context 'パスワードに不備がある場合、登録出来ずにエラーメッセージが表示されるか' do
      it 'パスワードが未入力の場合登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: nil
        fill_in '確認用パスワード', with: '123456'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'パスワードを入力してください'
      end

      it '確認用パスワードが未入力の場合登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: nil
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end

      it 'パスワードが5文字以下の場合登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: '12345'
        fill_in '確認用パスワード', with: '12345'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end

      it 'パスワードと確認用パスワードが異なる場合登録出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '654321'
        click_button '入力を完了する'
        expect(current_path).to eq users_path
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end
    end
  end

  describe '一般ユーザーログイン' do
    before do
      visit login_path
    end

    context 'フォームの入力値が正常の場合' do
      it 'ログインが成功し行きたい場所一覧ページに移動すること' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
        expect(current_path).to eq places_path
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'メールアドレスに不備がある場合' do
      it 'メールアドレスが未入力の場合ログイン出来ずにエラーメッセージが表示されること' do
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'
      end

      it '未登録のメールアドレスが入力された場合ログイン出来ずにエラーメッセージが表示されること' do
        fill_in 'メールアドレス', with: 'error@error.jp'
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'
      end
    end

    context 'パスワードに不備がある場合' do
      it 'パスワードが未入力の場合ログイン出来ずにエラーメッセージが表示されること' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: nil
        click_button 'ログインする'
        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'
      end

      it 'パスワードが間違っている場合ログイン出来ずにエラーメッセージが表示されること' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password + 'test'
        click_button 'ログインする'
        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'
      end
    end

    context '異なる人物のemailとパスワードの組み合わせの場合' do
      it 'ログイン出来ずにエラーメッセージが表示されること' do
        other_user = create(:user, email: 'login@test.jp', password: 'other_user')
        fill_in 'メールアドレス', with: other_user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
        expect(current_path).to eq login_path
        expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'
      end
    end
  end

  describe 'ユーザー編集' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'
      visit edit_user_path(user)
    end

    context 'フォームの入力値が正常の場合' do
      it 'ユーザーの編集が成功すること' do
        fill_in '名前', with: 'taro'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード(6文字以上)', with: 'testtest'
        fill_in '確認用パスワード', with: 'testtest'
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '編集が完了しました'
        expect(page).to have_content 'taro'
        expect(page).to have_content 'test@example.com'
      end
    end

    context '名前が未入力' do
      it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '名前', with: nil
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: user.password
        fill_in '確認用パスワード', with: user.password
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '名前を入力してください'
      end
    end

    context 'メールアドレスに不備がある場合' do
      it 'メールアドレスが未入力の場合編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード(6文字以上)', with: user.password
        fill_in '確認用パスワード', with: user.password
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      it '正規表現ではないので編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: '@.@.@.@'
        fill_in 'パスワード(6文字以上)', with: user.password
        fill_in '確認用パスワード', with: user.password
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'パスワードに不備がある場合、編集出来ずにエラーメッセージが表示されるか' do
      it 'パスワードが未入力の場合編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: nil
        fill_in '確認用パスワード', with: user.password
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'パスワードを入力してください'
      end

      it '確認用パスワードが未入力の場合編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: user.password
        fill_in '確認用パスワード', with: nil
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end

      it 'パスワードが5文字以下の場合編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: '12345'
        fill_in '確認用パスワード', with: '12345'
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end

      it 'パスワードと確認用パスワードが異なる場合編集出来ずにエラーメッセージが表示されること' do
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in '確認用パスワード', with: '654321'
        click_button '入力を完了する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end
    end
  end
end
