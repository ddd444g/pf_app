require 'rails_helper'

RSpec.describe 'RecmmendPlaces_system', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:category) { create(:category) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
  end

  describe 'RecommendPlace編集', js: true do
    # tokyo-stationをおすすめに公開し、編集ページまで移動
    before do
      click_link '訪問済み'
      tokyo_station_create_use_in_recommend_place
      sleep(3)
      click_link 'tokyo-station'
      click_link '編集する'
    end

    it 'beforeで作られたテストデータが表示されていること' do
      expect(page).to have_field('登録名', with: 'tokyo-station')
      expect(page).to have_field('おすすめコメント', with: 'good')
    end

    context 'フォームの入力値が正常の場合' do
      it 'RecommendPlaceの編集が成功し編集が反映されていること' do
        fill_in '登録名', with: 'TOKYO-STATION'
        fill_in 'おすすめコメント', with: 'amazing'
        select('amusement-park', from: 'recommend_place_category_id')
        click_button '編集を完了する'
        expect(page).to have_content 'TOKYO-STATION'
        expect(page).to have_content 'amazing'
        expect(page).to have_content 'amusement-park'
        expect(page).not_to have_content 'tokyo-station'
        expect(page).not_to have_content 'good'
      end
    end

    context '何もせず完了ボタンを押した場合' do
      it 'RecommendPlaceの編集がされず元のままであること' do
        click_button '編集を完了する'
        expect(page).to have_content 'tokyo-station'
        expect(page).to have_content 'good'
        expect(page).to have_content 'others'
      end
    end

    context 'nameがnilの場合' do
      it 'nameのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in '登録名', with: nil
        fill_in 'おすすめコメント', with: 'amazing'
        click_button '編集を完了する'
        expect(page).to have_content '登録名を入力してください'
      end
    end

    context 'おすすめコメントがnilの場合' do
      it 'おすすめコメントのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in '登録名', with: 'TOKYO-STATION'
        fill_in 'おすすめコメント', with: nil
        click_button '編集を完了する'
        expect(page).to have_content 'おすすめコメントを入力してください'
      end
    end
  end

  describe 'RecommendPlace削除', js: true do
    before do
      click_link '訪問済み'
      tokyo_station_create_use_in_recommend_place
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
        expect(page).to have_content 'tokyo-stationをおすすめから削除しました'
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

  describe 'RecommendPlace絞り込み検索', js: true do
    let!(:tokyo) do
      create(:recommend_place, recommend_place_name: 'tokyo-station', recommend_comment: 'good',
                               googlemap_name: 'Tokyo Station', address: 'Tokyo chiyoda',
                               rating: 1, user_id: user.id,
                               category_id: category.id)
    end

    let!(:sapporo) do
      create(:recommend_place, recommend_place_name: 'sapporo-station', recommend_comment: 'amazing',
                               googlemap_name: 'Sapporo Station', address: 'Hokkaido',
                               rating: 3, user_id: user.id,
                               category_id: category.id)
    end

    let!(:osaka) do
      create(:recommend_place, recommend_place_name: 'osaka-station', recommend_comment: 'good',
                               googlemap_name: 'Osaka Station', address: 'Kansai',
                               rating: 4, user_id: other_user.id,
                               category_id: category.id)
    end

    let!(:tokyo2) do
      create(:recommend_place, recommend_place_name: 'tokyo-station2', recommend_comment: 'good2',
                               googlemap_name: 'Tokyo Station', address: 'Tokyo chiyoda',
                               rating: 2, user_id: user.id,
                               category_id: category.id)
    end

    before do
      click_link 'おすすめ'
      click_link '自分の投稿したおすすめ一覧へ'
    end

    it 'beforeで作られたおすすめ場所が全て表示されていること' do
      click_link '他の人のおすすめ一覧へ'
      expect(page).to have_content 'tokyo-station'
      expect(page).to have_content 'tokyo-station2'
      expect(page).to have_content 'sapporo-station'
      expect(page).to have_content 'osaka-station'
    end

    describe '自分が投稿したおすすめ一覧ページの場合' do
      context 'キーワードがnilの場合' do
        it '自分が投稿したおすすめ場所のみが全て表示されていること' do
          fill_in 'search', with: nil
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end

      context 'nameで検索する場合' do
        it '一致する一件のみが表示されていること' do
          fill_in 'search', with: 'sapporo-station'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '部分一致で一致する二件のみが表示されていること' do
          fill_in 'search', with: 'tokyo'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '自分が投稿したおすすめ場所だけが検索対象であること' do
          fill_in 'search', with: 'osaka-station'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end

      context 'おすすめコメントで検索する場合' do
        it '一致する一件のみが表示されていること' do
          fill_in 'search', with: 'amazing'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '部分一致で一致する二件のみが表示されていること' do
          fill_in 'search', with: 'good'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end

      context 'googlemap_nameで検索する場合' do
        it '一致する一件のみが表示されていること' do
          fill_in 'search', with: 'Sapporo'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '自分が投稿したおすすめ場所だけが検索対象であること' do
          fill_in 'search', with: 'Osaka'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to_not have_content 'osaka-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
          end
        end
      end

      context 'addressで検索する場合' do
        it '一致する一件のみが表示されていること' do
          fill_in 'search', with: 'Hokkaido'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '部分一致で一致する二件のみが表示されていること' do
          fill_in 'search', with: 'chiyoda'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '自分が投稿したおすすめ場所だけが検索対象であること' do
          fill_in 'search', with: 'Kansai'
          sleep(3)
          click_button '検索'
          within('.my-post-index') do
            expect(page).to_not have_content 'osaka-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
          end
        end
      end

      context '全て表示ボタンをクリックした場合' do
        before do
          fill_in 'search', with: 'fukuoka'
          sleep(3)
          click_button '検索'
        end

        it '全て表示ボタンのテストの為、beforeで何も表示されていない状態が作られていること' do
          within('.my-post-index') do
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '自分が投稿したすべての場所が表示されること' do
          click_link '全て表示'
          within('.my-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end
    end

    describe '全てのおすすめ一覧ページの場合' do
      before do
        click_link '他の人のおすすめ一覧へ'
      end

      context 'キーワードがnilの場合' do
        it '全てのおすすめ場所表示されていること' do
          fill_in 'search', with: nil
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to have_content 'sapporo-station'
            expect(page).to have_content 'osaka-station'
          end
        end
      end

      context 'nameで検索する場合' do
        it '自分が投稿していない場所も検索対象であること' do
          fill_in 'search', with: 'osaka-station'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'osaka-station'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
          end
        end

        it '部分一致で一致する二件のみが表示されていること' do
          fill_in 'search', with: 'tokyo'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end

      context 'おすすめコメントで検索する場合' do
        it '一致する一件のみが表示されていること' do
          fill_in 'search', with: 'amazing'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it '部分一致で一致する三件が表示されていること' do
          fill_in 'search', with: 'good'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to have_content 'osaka-station'
            expect(page).to_not have_content 'sapporo-station'
          end
        end
      end

      context 'googlemap_nameで検索する場合' do
        it '自分が投稿していない場所も検索対象であること' do
          fill_in 'search', with: 'Osaka'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'osaka-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
          end
        end
      end

      context 'addressで検索する場合' do
        it '自分が投稿していない場所も検索対象であること' do
          fill_in 'search', with: 'Kansai'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'osaka-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
          end
        end

        it '部分一致で一致する二件のみが表示されていること' do
          fill_in 'search', with: 'chiyoda'
          sleep(3)
          click_button '検索'
          within('.all-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'osaka-station'
          end
        end
      end

      context '全て表示ボタンをクリックした場合' do
        before do
          fill_in 'search', with: 'fukuoka'
          sleep(3)
          click_button '検索'
        end

        it '全て表示ボタンのテストの為、beforeで何も表示されていない状態が作られていること' do
          within('.all-post-index') do
            expect(page).to_not have_content 'sapporo-station'
            expect(page).to_not have_content 'tokyo-station'
            expect(page).to_not have_content 'tokyo-station2'
            expect(page).to_not have_content 'osaka-station'
          end
        end

        it 'すべてのおすすめ場所が表示されること' do
          click_link '全て表示'
          within('.all-post-index') do
            expect(page).to have_content 'tokyo-station'
            expect(page).to have_content 'tokyo-station2'
            expect(page).to have_content 'sapporo-station'
            expect(page).to have_content 'osaka-station'
          end
        end
      end
    end
  end

  describe 'RecommendPlace並び替え機能', js: true do
    let!(:tokyo) do
      create(:recommend_place, recommend_place_name: 'tokyo-station', recommend_comment: 'good',
                               googlemap_name: 'Tokyo Station', address: 'Tokyo chiyoda',
                               rating: 1, user_id: user.id,
                               category_id: category.id)
    end

    let!(:sapporo) do
      create(:recommend_place, recommend_place_name: 'sapporo-station', recommend_comment: 'amazing',
                               googlemap_name: 'Sapporo Station', address: 'Hokkaido',
                               rating: 3, user_id: user.id,
                               category_id: category.id)
    end

    let!(:osaka) do
      create(:recommend_place, recommend_place_name: 'osaka-station', recommend_comment: 'good',
                               googlemap_name: 'Osaka Station', address: 'Kansai',
                               rating: 4, user_id: other_user.id,
                               category_id: category.id)
    end

    let!(:yokohama) do
      create(:recommend_place, recommend_place_name: 'yokohama-station', recommend_comment: 'nice',
                               googlemap_name: 'Yokohama Station', address: 'Kanagawa',
                               rating: 5, user_id: user.id,
                               category_id: category.id)
    end

    before do
      click_link 'おすすめ'
    end

    describe '自分が投稿したおすすめ一覧ページ' do
      before do
        click_link '自分の投稿したおすすめ一覧へ'
      end

      context 'デフォルトの場合' do
        it '作成時期が古い順に並んでいること' do
          expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
          expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        end

        it '自分が登録した場所しか表示されていないこと' do
          expect(page).to have_content 'tokyo-station'
          expect(page).to have_content 'yokohama-station'
          expect(page).to have_content 'sapporo-station'
          expect(page).to_not have_content 'osaka-station'
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

        it '自分が登録した場所しか表示されていないこと' do
          click_link '古い順'
          expect(page).to have_content 'tokyo-station'
          expect(page).to have_content 'yokohama-station'
          expect(page).to have_content 'sapporo-station'
          expect(page).to_not have_content 'osaka-station'
        end
      end

      context '新しい順に並び替える場合' do
        before do
          click_link '新しい順'
        end

        it '作成時期が新しい順に並んでいること' do
          expect(page.text).to match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
          expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        end

        it '自分が登録した場所しか表示されていないこと' do
          expect(page).to have_content 'tokyo-station'
          expect(page).to have_content 'yokohama-station'
          expect(page).to have_content 'sapporo-station'
          expect(page).to_not have_content 'osaka-station'
        end
      end

      context '評価が高い順に並び替える場合' do
        before do
          click_link '評価が高い順'
        end

        it 'googleでの評価が高い順(yokohama 5,sapporo 3,tokyo 1の順番)に並んでいること' do
          expect(page.text).to match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
          expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
        end

        it '自分が登録した場所しか表示されていないこと' do
          expect(page).to have_content 'tokyo-station'
          expect(page).to have_content 'yokohama-station'
          expect(page).to have_content 'sapporo-station'
          expect(page).to_not have_content 'osaka-station'
        end
      end

      context '全て表示をクリックした場合' do
        before do
          click_link '全て表示'
        end

        it 'デフォルトの状態(古い順)で並んでいること' do
          expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'yokohama-station'}/m)
          expect(page.text).to_not match(/#{'yokohama-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        end

        it '自分が登録した場所しか表示されていないこと' do
          expect(page).to have_content 'tokyo-station'
          expect(page).to have_content 'yokohama-station'
          expect(page).to have_content 'sapporo-station'
          expect(page).to_not have_content 'osaka-station'
        end
      end
    end

    describe '全てのおすすめ一覧ページ' do
      context 'デフォルトの場合' do
        it '作成時期が古い順に並んでいること' do
          expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
          expect(page.text).to_not match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        end
      end

      context '古い順に並び替える場合' do
        before do
          click_link '新しい順'
          sleep(3)
        end

        it 'デフォルトの状態では無く、新しい順に並んでいること' do
          expect(page.text).to match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
          expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
        end

        it '作成時期が古い順に並んでいること' do
          click_link '古い順'
          expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
          expect(page.text).to_not match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        end
      end

      context '新しい順に並び替える場合' do
        before do
          click_link '新しい順'
        end

        it '作成時期が新しい順に並んでいること' do
          expect(page.text).to match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
          expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
        end
      end

      context '評価が高い順に並び替える場合' do
        before do
          click_link '評価が高い順'
        end

        it 'googleでの評価が高い順(yokohama 5,oska 4,sapporo 3,tokyo 1の順番)に並んでいること' do
          expect(page.text).to match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
          expect(page.text).to_not match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
        end
      end

      context '全て表示をクリックした場合' do
        before do
          click_link '全て表示'
        end

        it 'デフォルトの状態(古い順)で並んでいること' do
          expect(page.text).to match(/#{'tokyo-station'}.*#{'sapporo-station'}.*#{'osaka-station'}.*#{'yokohama-station'}/m)
          expect(page.text).to_not match(/#{'yokohama-station'}.*#{'osaka-station'}.*#{'sapporo-station'}.*#{'tokyo-station'}/m)
        end
      end
    end
  end
end
