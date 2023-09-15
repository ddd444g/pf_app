require 'rails_helper'

RSpec.describe 'PlanPlaces_system', type: :system do
  let!(:user) { create(:user) }
  let!(:plan) { create(:plan, plan_name: 'trip', start_time: '2023-01-01 12:00:00', end_time: '2023-01-02 12:00:00', user: user) }

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

    describe 'モーダルフォームから新規作成' do
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
          select('others', from: 'plan_place_category_id')
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
          select('others', from: 'plan_place_category_id')
          click_button '登録を完了する'
          expect(page).to have_content 'Sapporo Station'
          expect(page).to have_content '未定'
          expect(page).to have_content 'others'
        end
      end
    end
  end
end
