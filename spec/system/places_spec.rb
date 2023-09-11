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
        sleep(3)
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
        sleep(3)
        expect(page).to have_content 'mapで検索し位置を指定してください'
        expect(page).to have_content '登録したい位置にピンを刺してください'
      end
    end

    context 'mapで検索しても場所が出てこない場合' do
      it '空白で検索するとダイアログが出てくること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = ' '")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
      end

      it '存在しない場所を検索するとダイアログが出てくること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'test-test-hoge-hoge'")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
      end

      it '存在しない場所は登録できないこと' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'test-test-hoge-hoge'")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'memo', with: 'Hokkaido'
        select('others', from: 'place_category_id')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content 'mapで検索し位置を指定してください'
        expect(page).to have_content '登録したい位置にピンを刺してください'
      end
    end

    context 'nameがnilの場合' do
      it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        fill_in '登録名', with: nil
        fill_in 'memo', with: 'Hokkaido'
        select('others', from: 'place_category_id')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '登録名を入力してください'
      end
    end

    context 'カテゴリーを自分で選択しない場合' do
      it '自動でセレクトボックスの一番上のカテゴリーに設定され登録が成功すること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'memo', with: 'Hokkaido'
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content 'sapporo-station'
        expect(page).to have_content 'hotel'
      end
    end
  end

  describe 'Place編集', js: true do
    # hakata-stationを作成し、編集ページまで移動
    before do
      # モーダルを開く
      find_by_id('create').click
      page.execute_script("document.getElementById('address').value = 'sendai-station'")
      find_by_id('search-button').click
      # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
      sleep(3)
      fill_in '登録名', with: 'sendai-station'
      fill_in 'memo', with: 'Miyagi'
      select('others', from: 'place_category_id')
      click_button '登録を完了する'
      sleep(3)
      click_on 'sendai-station'
      click_on '編集する'
    end

    it 'beforeで作られたテストデータが表示されていること' do
      expect(page).to have_field('登録名', with: 'sendai-station')
      expect(page).to have_field('memo', with: 'Miyagi')
    end

    context 'フォームの入力値が正常の場合' do
      it 'Placeの編集が成功し編集が反映されていること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'tokyo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        # 自動設定されたのを自分で上書き
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'memo', with: 'Tokyo'
        select('amusement-park', from: 'place_category_id')
        click_button '編集を完了する'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'Tokyo'
        expect(page).to have_content 'amusement-park'
        expect(page).not_to have_content 'sendai-station'
        expect(page).not_to have_content 'Miyagi'
      end
    end
  end
end
