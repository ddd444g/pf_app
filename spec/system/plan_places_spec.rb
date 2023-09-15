require 'rails_helper'

RSpec.describe 'PlanPlaces_system', type: :system do
  let!(:user) { create(:user) }
  let!(:category) { create(:category, name: 'others') }
  let!(:plan) { create(:plan, plan_name: 'trip', start_time: '2023-01-01 12:00:00', end_time: '2023-01-02 12:00:00', user: user) }
  let!(:plan_place) do
    create(:plan_place, plan_place_name: 'kobe-station', memo: 'Hyogo', plan: plan, user: user, category: category,
                        start_time: '2023-01-01 12:00:00')
  end

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
    click_link '予定'
    click_link '詳細'
  end

  describe 'PlanPlace新規登録', js: true do
    before do
      # モーダルを開く
      find_by_id('create').click
    end

    describe 'モーダルフォームから登録' do
      context 'フォームの入力値が正常の場合' do
        it 'PlanPlaceの新規作成が成功し新規作成した場所が表示されていること' do
          # mapで検索
          page.execute_script("document.getElementById('address').value = 'sapporo-station'")
          find_by_id('search-button').click
          # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
          sleep(3)
          # 自動設定されたのを自分で上書き
          fill_in '登録名', with: 'sapporo-station'
          fill_in 'memo', with: 'Hokkaido'
          select('others', from: 'plan_place_category_id', match: :first)
          click_button '登録を完了する'
          sleep(3)
          expect(page).to have_content 'sapporo-station'
          expect(page).to have_content 'Hokkaido'
          expect(page).to have_content '未定'
          expect(page).to have_content 'others'
        end

        it 'nameを登録しなくてもmapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定され登録が成功していること' do
          # mapで検索
          page.execute_script("document.getElementById('address').value = 'sapporo-station'")
          find_by_id('search-button').click
          # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
          sleep(3)
          fill_in 'memo', with: 'Hokkaido'
          select('others', from: 'plan_place_category_id', match: :first)
          click_button '登録を完了する'
          expect(page).to have_content 'Sapporo Station'
          expect(page).to have_content '未定'
          expect(page).to have_content 'others'
        end
      end

      context 'mapで検索してない場合' do
        it 'latitude,longitudeのバリデーションでひっかりエラーメッセージが表示されること' do
          fill_in '登録名', with: 'sapporo-station'
          fill_in 'memo', with: 'Hokkaido'
          select('others', from: 'plan_place_category_id', match: :first)
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
          select('others', from: 'plan_place_category_id', match: :first)
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
          fill_in 'memo', with: 'Hokkaido'
          select('others', from: 'plan_place_category_id', match: :first)
          click_button '登録を完了する'
          sleep(3)
          expect(page).to have_content '登録名を入力してください'
        end
      end
    end

    describe '行きたい場所、もう一度行きたい場所から登録' do
      let!(:place) do
        create(:place, name: 'osaka-station', memo: 'Osaka',
                       googlemap_name: 'Osaka Station', address: 'Osaka', user: user,
                       category: category)
      end
      let!(:gone_place) do
        create(:gone_place, name: 'tokyo-station',
                            googlemap_name: 'Tokyo Station', address: 'Tokyo',
                            once_again: true, user: user, category: category)
      end
      before do
        click_link '一覧ページへ'
      end

      describe '行きたい場所から登録' do
        before do
          within('.places') do
            click_link '登録する'
          end
        end

        context 'フォームの入力値が正常の場合' do
          it 'PlanPlaceの新規作成が成功し新規作成した場所が表示されていること' do
            fill_in '登録名', with: 'osaka-station'
            fill_in 'memo', with: 'Osaka'
            click_button '登録を完了する'
            sleep(3)
            expect(page).to have_content 'osaka-station'
            expect(page).to have_content '未定'
            expect(page).to have_content 'others'
          end

          it 'nameを登録しなくてもplaceの元のnameが入力されていること' do
            fill_in 'memo', with: 'Osaka'
            click_button '登録を完了する'
            expect(page).to have_content 'osaka-station'
            expect(page).to have_content '未定'
            expect(page).to have_content 'others'
          end
        end

        context 'nameがnilの場合' do
          it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
            fill_in '登録名', with: nil
            fill_in 'memo', with: 'Osaka'
            click_button '登録を完了する'
            sleep(2)
            expect(page).to have_content '登録名を入力してください'
          end
        end
      end

      describe 'もう一度行きたい場所から登録' do
        before do
          within('.once-again-places') do
            click_link '登録する'
          end
        end

        context 'フォームの入力値が正常の場合' do
          it 'PlanPlaceの新規作成が成功し新規作成した場所が表示されていること' do
            fill_in '登録名', with: 'tokyo-station'
            fill_in 'memo', with: 'Tokyo'
            click_button '登録を完了する'
            sleep(3)
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content '未定'
            expect(page).to have_content 'others'
          end

          it 'nameを登録しなくてもplaceの元のnameが入力されていること' do
            fill_in 'memo', with: 'Tokyo'
            click_button '登録を完了する'
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content '未定'
            expect(page).to have_content 'others'
          end
        end

        context 'nameがnilの場合' do
          it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
            fill_in '登録名', with: nil
            fill_in 'memo', with: 'Tokyo'
            click_button '登録を完了する'
            sleep(2)
            expect(page).to have_content '登録名を入力してください'
          end
        end
      end
    end
  end

  describe 'PlanPlace編集', js: true do
    before do
      click_link plan_place.plan_place_name
      click_link '編集する'
    end

    it 'beforeで作られたテストデータが表示されていること' do
      expect(page).to have_field('登録名', with: plan_place.plan_place_name)
      expect(page).to have_field('memo', with: plan_place.memo)
    end

    context 'フォームの入力値が正常の場合' do
      it 'PlanPlaceの編集が成功し編集が反映されていること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'tokyo-station'")
        find_by_id('search-button').click
        # mapで検索した場所のgooglemapでの正式名称が登録名の入力フォームに自動設定されるのを待つため3秒待機
        sleep(3)
        # 自動設定されたのを自分で上書き
        fill_in '登録名', with: 'tokyo-station'
        fill_in 'memo', with: 'Tokyo'
        select('amusement-park', from: 'plan_place_category_id')
        click_button '編集を完了する'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'Tokyo'
        expect(page).to have_content 'amusement-park'
        expect(page).not_to have_content 'kobe-station'
        expect(page).not_to have_content 'Hyogo'
      end
    end

    context '何もせず完了ボタンを押した場合' do
      it 'PlanPlaceの編集がされず元のままであること' do
        click_button '編集を完了する'
        expect(page).to have_content 'kobe-station'
        expect(page).to have_content 'Hyogo'
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

    context 'mapで検索しても場所が出てこない場合' do
      it 'nilで検索した場合、位置情報は更新されずに編集は完了すること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = ' '")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
        click_button '編集を完了する'
        expect(page).to have_content 'kobe-station'
        expect(page).to have_content 'Hyogo'
        expect(page).to have_content 'others'
      end

      it '存在しない場所が検索結果の場合、位置情報は更新されずに編集は完了すること' do
        # mapで検索
        page.execute_script("document.getElementById('address').value = 'test-test-hoge-hoge'")
        page.accept_confirm("該当する結果がありませんでした") do
          find_by_id('search-button').click
        end
        click_button '編集を完了する'
        expect(page).to have_content 'kobe-station'
        expect(page).to have_content 'Hyogo'
        expect(page).to have_content 'others'
      end
    end
  end

  describe 'PlanPlace削除', js: true do
    it '作成したデータが存在すること' do
      expect(page).to have_content plan_place.plan_place_name
      expect(page).to have_content plan_place.memo
    end

    context '削除する場合' do
      it '削除が成功し表示されていないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "#{plan_place.plan_place_name}を削除しました"
        # 削除完了メッセージに'{plan_place.plan_place_name'が入っているためリロード
        visit current_path
        expect(page).not_to have_content plan_place.plan_place_name
        expect(page).not_to have_content plan_place.memo
      end
    end

    context '削除しない場合' do
      it 'キャンセルして削除されていないこと' do
        click_link '削除'
        # 削除をキャンセル
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content plan_place.plan_place_name
        expect(page).to have_content plan_place.memo
      end
    end
  end

  describe 'PlanPlace訪問予定時刻の並び順', js: true do
    let!(:plan_place2) do
      create(:plan_place, plan_place_name: 'hakata-station', plan: plan, user: user, category: category,
                          start_time: '2023-01-01 15:00:00')
    end
    let!(:plan_place3) do
      create(:plan_place, plan_place_name: 'sendai-station', plan: plan, user: user, category: category,
                          start_time: '2023-01-02 10:00:00')
    end

    context '未定がない場合' do
      it '予定時刻が早い順に上から並んでいること' do
        visit current_path
        expect(page.text).to match(/#{'kobe-station'}.*#{'hakata-station'}.*#{'sendai-station'}/m)
      end
    end

    context '未定がある場合' do
      let!(:plan_place4) do
        create(:plan_place, plan_place_name: 'sapporo-station', plan: plan, user: user, category: category)
      end
      it '未定が一番上でその下から予定時刻が早い順に並んでいること' do
        visit current_path
        expect(page.text).to match(/#{'sapporo-station'}.*#{'kobe-station'}.*#{'hakata-station'}.*#{'sendai-station'}/m)
      end
    end
  end
end
