require 'rails_helper'

RSpec.describe 'Places_system', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
  end

  describe 'Place新規登録', js: true do
    before do
      # モーダルを開く
      find_by_id('create').click
    end

    context 'フォームの入力値が正常の場合' do
      it 'Placeの新規作成が成功し新規作成した場所が表示されていること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        # 自動設定されたのを自分で上書き
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'memo', with: 'Hokkaido'
        select('others', from: 'place_category_id')
        click_button '登録を完了する'
        expect(page).to have_content 'sapporo-station'
        expect(page).to have_content 'others'
      end

      it 'nameを登録しなくてもmapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定され登録が成功していること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        fill_in 'memo', with: 'Hokkaido'
        select('others', from: 'place_category_id')
        click_button '登録を完了する'
        expect(page).to have_content 'Sapporo Station'
        expect(page).to have_content 'others'
      end
    end

    context 'mapで検索してない場合' do
      it 'latitude,longitudeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'memo', with: 'Hokkaido'
        select('others', from: 'place_category_id')
        click_button '登録を完了する'
        expect(page).to have_content 'mapで検索し位置を指定してください'
        expect(page).to have_content '登録したい位置にピンを刺してください'
      end
    end
  end
end
