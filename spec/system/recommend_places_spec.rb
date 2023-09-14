require 'rails_helper'

RSpec.describe 'RecmmendPlaces_system', type: :system do
  let!(:user) { create(:user) }

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
end
