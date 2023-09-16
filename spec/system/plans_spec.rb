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

    context 'plan_nameがnilの場合' do
      it 'plan_nameのバリデーションでひっかりエラーメッセージが表示されること' do
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

  describe 'Plan編集', js: true do
    let!(:plan) { create(:plan, plan_name: 'travel', start_time: '2023-01-01 00:00:00', end_time: '2023-01-02 00:00:00', user: user) }

    before do
      visit current_path
      click_link '編集'
    end

    it 'テストデータが表示されていること' do
      expect(page).to have_field('予定名', with: plan.plan_name)
      expect(page).to have_field('開始日時', with: '2023-01-01T00:00')
      expect(page).to have_field('終了日時', with: '2023-01-02T00:00')
    end

    context 'フォームの入力値が正常の場合' do
      it 'Planの編集が成功し編集が反映されていること' do
        fill_in '予定名', with: 'trip'
        sleep(2)
        fill_in 'plan_start_time', with: "09202023\t0000a"
        sleep(2)
        fill_in 'plan_end_time', with: "09212023\t0000a"
        sleep(2)
        select('赤', from: 'plan_plan_color')
        click_button '編集を完了する'
        expect(page).to have_content 'trip'
        expect(page).to have_content '9月20日 00:00 〜 9月21日 00:00'
        expect(page).not_to have_content 'travel'
        expect(page).not_to have_content '1月1日 00:00 〜 1月2日 00:00'
      end
    end

    context '何もせず完了ボタンを押した場合' do
      it 'Planの編集がされず元のままであること' do
        click_button '編集を完了する'
        expect(page).to have_content 'travel'
        expect(page).to have_content '1月1日 00:00 〜 1月2日 00:00'
      end
    end

    context 'plan_nameがnilの場合' do
      it 'plan_nameのバリデーションに引っかかりエラーメッセージが表示されること' do
        fill_in '予定名', with: nil
        fill_in 'plan_start_time', with: "09202023\t0000a"
        fill_in 'plan_end_time', with: "09212023\t0000a"
        click_button '編集を完了する'
        expect(page).to have_content '予定名を入力してください'
      end
    end

    context 'start_timeがnilの場合' do
      it 'start_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        fill_in 'plan_start_time', with: nil
        fill_in 'plan_end_time', with: "09232023\t0000a"
        select('赤', from: 'plan_plan_color')
        click_button '編集を完了する'
        expect(page).to have_content '開始日時を入力してください'
      end
    end

    context 'end_timeがnilの場合' do
      it 'end_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        fill_in 'plan_start_time', with: "09202023\t0000a"
        fill_in 'plan_end_time', with: nil
        select('赤', from: 'plan_plan_color')
        click_button '編集を完了する'
        expect(page).to have_content '終了日時を入力してください'
      end
    end

    context 'start_timeよりend_timeの時刻の方が前の場合' do
      it 'end_timeのバリデーションでひっかりエラーメッセージが表示されること' do
        fill_in '予定名', with: 'trip'
        fill_in 'plan_start_time', with: "09202023\t0000a"
        fill_in 'plan_end_time', with: "09172023\t0000a"
        select('赤', from: 'plan_plan_color')
        click_button '編集を完了する'
        expect(page).to have_content '終了日時は開始日時より後にして下さい'
      end
    end
  end

  describe 'Plan削除', js: true do
    let!(:plan2) { create(:plan, plan_name: 'work', start_time: Time.now, end_time: Time.now + 1.day, user: user) }
    before do
      visit current_path
    end

    it '作成したデータが存在すること' do
      # 表に存在するか
      within('.plans') do
        expect(page).to have_content plan2.plan_name
      end
      # カレンダーに存在するか
      within('.calendar') do
        expect(page).to have_content plan2.plan_name
      end
    end

    context '削除する場合' do
      it '削除が成功し表示されていないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "#{plan2.plan_name}を予定から削除しました"
        # 削除完了メッセージに'plan2.plan_name'が入っているためリロード
        visit current_path
        # 表から削除されているか
        within('.plans') do
          expect(page).not_to have_content plan2.plan_name
        end
        # カレンダーから削除されているか
        within('.calendar') do
          expect(page).not_to have_content plan2.plan_name
        end
      end
    end

    context '削除しない場合' do
      it 'キャンセルして削除されていないこと' do
        click_link '削除'
        # 削除をキャンセル
        page.driver.browser.switch_to.alert.dismiss
        # 表に存在するか
        within('.plans') do
          expect(page).to have_content plan2.plan_name
        end
        # カレンダーに存在するか
        within('.calendar') do
          expect(page).to have_content plan2.plan_name
        end
      end
    end
  end
end
