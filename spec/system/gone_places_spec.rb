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

  describe 'GonePlace削除', js: true do
    before do
      tokyo_station_create_use_in_gone_place
      sleep(3)
    end

    it '作成したデータが存在すること' do
      expect(page).to have_content 'tokyo-station'
      expect(page).to have_content 'others'
    end

    context '削除する場合' do
      it '削除が成功し表示されていないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'tokyo-stationを削除しました'
        # 削除完了メッセージに'tokyo-station'が入っているためリロード
        visit current_path
        expect(page).not_to have_content 'tokyo-station'
        expect(page).not_to have_content 'others'
      end
    end

    context '削除しない場合' do
      it 'キャンセルして削除されていないこと' do
        click_link '削除'
        # 削除をキャンセル
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'others'
      end
    end
  end

  describe 'おすすめに公開', js: true do
    before do
      tokyo_station_create_use_in_gone_place
      click_link 'tokyo-station'
      click_button 'おすすめに公開する'
    end

    context 'フォームの入力値が正常の場合' do
      it 'GonePlaceをおすすめに公開が完了すること' do
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'おすすめコメント', with: 'good'
        click_button '登録を完了する'
        expect(page).to have_content 'おすすめ場所として公開しました'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'good'
      end
    end

    context 'すでにおすすめに公開している場合' do
      before do
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'おすすめコメント', with: 'good'
        click_button '登録を完了する'
        sleep(2)
      end

      it '登録ボタンが表示されずにおすすめに公開済みですのテキストが出ること' do
        click_link '訪問済み'
        click_link 'tokyo-station'
        expect(page).to have_content 'おすすめに公開済みです'
        # ボタンが存在しないことを確認
        expect(page).not_to have_button('おすすめに公開する')
      end

      it '登録したおすすめ場所を削除すればもう一度、おすすめに登録できること' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        click_link '訪問済み'
        click_link 'tokyo-station'
        click_button 'おすすめに公開する'
        sleep(3)
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'おすすめコメント', with: 'good'
        click_button '登録を完了する'
        expect(page).to have_content 'おすすめ場所として公開しました'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'good'
      end
    end

    context '登録名がnilの場合' do
      it '登録名のバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '登録名', with: nil
        fill_in 'おすすめコメント', with: 'good'
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '登録名を入力してください'
      end
    end

    context 'おすすめコメントがnilの場合' do
      it 'おすすめコメントのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'おすすめコメント', with: nil
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content 'おすすめコメントを入力してください'
      end
    end
  end

  describe 'GonePlace絞り込み検索', js: true do
    before do
      tokyo_station_create_use_in_gone_place
      tokyo_station2_create_use_in_gone_place
      sapporo_station_create_use_in_gone_place
      visit current_path
      sleep(3)
    end

    context 'キーワードがnilの場合' do
      it 'キーワードがnilの場合、全てのgone_placeが表示されていること' do
        fill_in 'search', with: nil
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'tokyo-station2'
        expect(page).to have_content 'sapporo-station'
      end
    end

    context 'nameで検索する場合' do
      it '一致する一件のみが表示されていること' do
        fill_in 'search', with: 'sapporo-station'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'sapporo-station'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
      end

      it '部分一致で一致する二件のみが表示されていること' do
        fill_in 'search', with: 'tokyo'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'tokyo-station2'
        expect(page).to_not have_content 'sapporo-station'
      end

      it '該当しない場合何も表示しないこと' do
        fill_in 'search', with: 'fukuoka'
        sleep(3)
        click_button '検索'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
        expect(page).to_not have_content 'sapporo-station'
      end
    end

    context 'reviewで検索する場合' do
      it '一致する一件のみが表示されていること' do
        fill_in 'search', with: 'Hokkaido'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'sapporo-station'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
      end

      it '部分一致で一致する二件のみが表示されていること' do
        fill_in 'search', with: 'Tok'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'tokyo-station2'
        expect(page).to_not have_content 'sapporo-station'
      end
    end

    context 'googlemap_nameで検索する場合' do
      it '一致する一件のみが表示されていること' do
        fill_in 'search', with: 'Sapporo'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'sapporo-station'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
      end
    end

    context 'addressで検索する場合' do
      it '一致する一件のみが表示されていること' do
        fill_in 'search', with: '3 Chome-4 Chome Kita 6 Jonishi, Kita Ward'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'sapporo-station'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
      end

      it '部分一致で一致する二件のみが表示されていること' do
        fill_in 'search', with: 'chiyoda'
        sleep(3)
        click_button '検索'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'tokyo-station2'
        expect(page).to_not have_content 'sapporo-station'
      end
    end

    context '全て表示ボタンをクリックした場合' do
      before do
        fill_in 'search', with: 'fukuoka'
        sleep(3)
        click_button '検索'
      end

      it '全て表示ボタンのテストの為、beforeで何も表示されていない状態が作られていること' do
        expect(page).to_not have_content 'sapporo-station'
        expect(page).to_not have_content 'tokyo-station'
        expect(page).to_not have_content 'tokyo-station2'
      end

      it '登録しているすべての場所が表示されること' do
        click_link '全て表示'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'tokyo-station2'
        expect(page).to have_content 'sapporo-station'
      end
    end
  end

  describe '並び替えが機能しているか', js: true do
    before do
      tokyo_station_create_use_in_gone_place
      sapporo_station_create_use_in_gone_place
      yokohama_station_create_use_in_gone_place
      sleep(3)
      visit current_path
      sleep(3)
    end

    context 'デフォルトの場合' do
      it '作成時期が古い順に並んでいること' do
        expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
      end
    end

    context '古い順に並び替える場合' do
      before do
        click_link '新しい順'
        sleep(3)
      end

      it 'デフォルトの状態では無く、新しい順に並んでいること' do
        expect(page.text).to match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
      end

      it '作成時期が古い順に並んでいること' do
        click_link '古い順'
        expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
      end
    end

    context '新しい順に並び替える場合' do
      it '作成時期が新しい順に並んでいること' do
        click_link '新しい順'
        expect(page.text).to match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
      end
    end

    context '評価が高い順に並び替える場合' do
      it 'googleでの評価が高い順(tokyo 4.3,sapporo 4.1,yokohama 3.9の順番)に並んでいること' do
        click_link '評価が高い順'
        expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
      end
    end

    context 'myスコアが高い順に並び替える場合' do
      it 'myスコアが高い順(sapporo 10,yokohama 5,tokyo 1の順番)に並んでいること' do
        click_link 'myスコアが高い順'
        expect(page.text).to match(/#{'sapporo-station'}.*#{'yokohama-station'}.*#{'tokyo-station'}/m)
        expect(page.text).to_not match(/#{'tokyo-station'}.*#{'yokohama-station'}.*#{'sapporo-station'}/m)
      end
    end

    context '全て表示をクリックした場合' do
      it 'デフォルトの状態(古い順)で並んでいること' do
        click_link '全て表示'
        expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
      end
    end
  end

  describe 'もう一度行きたいに登録', js: true do
    before do
      tokyo_station_create_use_in_gone_place
    end

    context 'indexページで登録する場合' do
      it 'まだもう一度行きたい一覧に登録されておらず、もう一度行きたいボタンが存在すること' do
        expect(page).to have_button('もう一度行きたい')
        expect(page).to_not have_content 'tokyo-stationをもう一度行きたいに登録しました'
        expect(page).to_not have_content '登録済みです'
        within('.once-again-places') do
          expect(page).to_not have_content('tokyo-station')
          expect(page).to_not have_button('解除する')
        end
      end

      it 'もう一度行きたいボタンを押すともう一度行きたい一覧に登録され、もう一度行きたいボタンが登録済みですに変わること' do
        click_button 'もう一度行きたい'
        expect(page).to have_content 'tokyo-stationをもう一度行きたいに登録しました'
        expect(page).to have_content '登録済みです'
        within('.once-again-places') do
          expect(page).to have_button('解除する')
          expect(page).to have_content('tokyo-station')
        end
      end
    end

    context '詳細ページで登録する場合' do
      before do
        click_link 'tokyo-station'
      end

      it 'まだもう一度行きたいに登録されておらず、登録するボタンが存在すること' do
        expect(page).to have_button('登録する')
      end

      it 'もう一度行きたいに登録するボタンを押すと登録メッセージが表示され、登録ボタンが解除ボタンに変わること' do
        click_button '登録する'
        sleep(2)
        expect(page).to have_content 'tokyo-stationをもう一度行きたいに登録しました'
        expect(page).to have_button('解除する')
      end

      it 'もう一度行きたいに登録するボタンを押し一覧ページに戻るともう一度行きたい一覧に登録されていること' do
        click_button '登録する'
        sleep(2)
        click_link '訪問済み一覧ページへ'
        expect(page).to have_content '登録済みです'
        within('.once-again-places') do
          expect(page).to have_button('解除する')
          expect(page).to have_content('tokyo-station')
        end
      end
    end
  end

  describe 'もう一度行きたいを解除', js: true do
    before do
      tokyo_station_create_use_in_gone_place
      click_button 'もう一度行きたい'
    end

    it 'beforeで作られたtokyo-stationがもう一度行きたいに登録されていること' do
      expect(page).to have_content 'tokyo-stationをもう一度行きたいに登録しました'
      expect(page).to have_content '登録済みです'
      within('.once-again-places') do
        expect(page).to have_button('解除する')
        expect(page).to have_content('tokyo-station')
      end
    end

    context 'indexページで解除する場合' do
      it 'もう一度行きたいが解除されもう一度行きたい一覧から消えること' do
        click_button '解除する'
        sleep(2)
        expect(page).to have_content 'tokyo-stationのもう一度行きたいを解除しました'
        expect(page).to have_button('もう一度行きたい')
        within('.once-again-places') do
          expect(page).to_not have_button('解除する')
          expect(page).to_not have_content('tokyo-station')
        end
      end
    end

    context '詳細ページで解除する場合' do
      before do
        click_link 'tokyo-station'
      end

      it 'もう一度行きたいに登録されている状態であること' do
        expect(page).to have_button('解除する')
      end

      it '解除ボタンを押すと解除メッセージが表示され、登録ボタンに変わること' do
        click_button '解除する'
        sleep(2)
        expect(page).to have_content 'tokyo-stationのもう一度行きたいを解除しました'
        expect(page).to have_button('登録する')
      end

      it '解除ボタンを押し一覧ページに戻るともう一度行きたい一覧に登録されていないこと' do
        click_button '解除する'
        sleep(2)
        click_link '訪問済み一覧ページへ'
        expect(page).to have_button('もう一度行きたい')
        within('.once-again-places') do
          expect(page).to_not have_button('解除する')
          expect(page).to_not have_content('tokyo-station')
        end
      end
    end
  end
end
