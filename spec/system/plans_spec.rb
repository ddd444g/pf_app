require 'rails_helper'

RSpec.describe 'Plans_system', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
    click_link '予定'
  end

  describe 'Plan新規登録', js: true do
    before do
      # モーダルを開く
      find_by_id('create').click
      sleep(2)
    end

    context 'フォームの入力値が正常の場合' do
      it 'Planの新規作成が成功し表とカレンダーのどちらにも表示されていること' do
        fill_in '予定名', with: 'trip'
        sleep(2)
        fill_in 'plan_start_time', with: "09202023\t0000a"
        sleep(2)
        fill_in 'plan_end_time', with: "09232023\t0000a"
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '予定を新規登録をしました'
        # 表に追加できているか
        within('.plans') do
          expect(page).to have_content 'trip'
        end
        # カレンダーに追加できているか
        within('.calendar') do
          expect(page).to have_content 'trip'
        end
      end
    end

    context 'nameがnilの場合' do
      it 'nameのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: nil
        sleep(2)
        fill_in 'plan_start_time', with: "09202023\t0000a"
        sleep(2)
        fill_in 'plan_end_time', with: "09232023\t0000a"
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '予定名を入力してください'
      end
    end

    context 'start_timeがnilの場合' do
      it 'start_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        sleep(2)
        fill_in 'plan_start_time', with: nil
        sleep(2)
        fill_in 'plan_end_time', with: "09232023\t0000a"
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '開始日時を入力してください'
      end
    end

    context 'end_timeがnilの場合' do
      it 'end_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        sleep(2)
        fill_in 'plan_start_time', with: "09202023\t0000a"
        sleep(2)
        fill_in 'plan_end_time', with: nil
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '終了日時を入力してください'
      end
    end

    context 'start_timeよりend_timeの時刻の方が前の場合' do
      it 'end_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        sleep(2)
        fill_in 'plan_start_time', with: "09202023\t0000a"
        sleep(2)
        fill_in 'plan_end_time', with: "09172023\t0000a"
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '登録を完了する'
        sleep(3)
        expect(page).to have_content '終了日時は開始日時より後にして下さい'
      end
    end
  end
end
