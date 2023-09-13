require 'rails_helper'

RSpec.describe 'GonePlaces_system', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
    click_link '訪問済み'
  end

  describe 'GonePlace新規登録', js: true do
    before do
      # モーダルを開く
      find_by_id('create').click
    end

    context 'フォームの入力値が正常の場合' do
      it 'GonePlaceの新規作成が成功し新規作成した場所が表示されていること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        # 自動設定されたのを自分で上書き
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
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
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
        click_button '登録を完了する'
        expect(page).to have_content 'Sapporo Station'
        expect(page).to have_content 'others'
      end
    end

    context 'mapで検索してない場合' do
      it 'latitude,longitudeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
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
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
        click_button '登録を完了する'
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
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '登録名を入力してください'
      end
    end

    context 'レビューがnilの場合' do
      it 'レビューのバリデーションでひっかりエラーメッセージが表示されること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'レビュー', with: nil
        fill_in 'myスコア (1~10点)', with: 10
        select('others', from: 'gone_place_category_id')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content 'レビューを入力してください'
      end
    end

    context 'myスコアがnilの場合' do
      it 'myスコアのバリデーションでひっかりエラーメッセージが表示されること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'sapporo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        fill_in '登録名', with: 'sapporo-station'
        fill_in 'レビュー', with: 'Hokkaido'
        fill_in 'myスコア (1~10点)', with: nil
        select('others', from: 'gone_place_category_id')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content 'myスコア (1~10点)を入力してください'
        expect(page).to have_content 'myスコア (1~10点)は数値で入力してください'
      end
    end
  end

  describe 'GonePlace編集', js: true do
    # sapporo-stationを作成し、編集ページまで移動
    before do
      sapporo_station_create_use_in_gone_place
      sleep(3)
      click_on 'sapporo-station'
      click_on '編集する'
    end

    it 'beforeで作られたテストデータが表示されていること' do
      expect(page).to have_field('登録名', with: 'sapporo-station')
      expect(page).to have_field('レビュー', with: 'Hokkaido')
    end

    context 'フォームの入力値が正常の場合' do
      it 'GonePlaceの編集が成功し編集が反映されていること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'tokyo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        # 自動設定されたのを自分で上書き
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'レビュー', with: 'Tokyo'
        fill_in 'myスコア (1~10点)', with: 1
        select('amusement-park', from: 'gone_place_category_id')
        click_button '編集を完了する'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'Tokyo'
        expect(page).to have_content 'amusement-park'
        expect(page).not_to have_content 'sapporo-station'
        expect(page).not_to have_content 'Hokkaido'
      end
    end

    context '何もせず完了ボタンを押した場合' do
      it 'GonePlaceの編集がされず元のままであること' do
        click_button '編集を完了する'
        expect(page).to have_content 'sapporo-station'
        expect(page).to have_content 'Hokkaido'
        expect(page).to have_content 'others'
      end
    end

    context 'nameがnilの場合' do
      it 'nameのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in '登録名', with: nil
        click_button '編集を完了する'
        expect(page).to have_content '登録名を入力してください'
      end
    end

    context 'レビューがnilの場合' do
      it 'レビューのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in 'レビュー', with: nil
        click_button '編集を完了する'
        expect(page).to have_content 'レビューを入力してください'
      end
    end

    context 'myスコアがnilの場合' do
      it 'myスコアのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in 'myスコア (1~10点)', with: nil
        click_button '編集を完了する'
        expect(page).to have_content 'myスコア (1~10点)を入力してください'
        expect(page).to have_content 'myスコア (1~10点)は数値で入力してください'
      end
    end

    context 'mapで検索しても場所が出てこない場合' do
      it 'nilで検索した場合、位置情報は更新されずに編集は完了すること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = ' '")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
        click_button '編集を完了する'
        expect(page).to have_content 'sapporo-station'
        expect(page).to have_content 'Hokkaido'
        expect(page).to have_content 'others'
      end

      it '存在しない場所が検索結果の場合、位置情報は更新されずに編集は完了すること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'test-test-hoge-hoge'")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
        click_button '編集を完了する'
        expect(page).to have_content 'sapporo-station'
        expect(page).to have_content 'Hokkaido'
        expect(page).to have_content 'others'
      end
    end
  end
end
