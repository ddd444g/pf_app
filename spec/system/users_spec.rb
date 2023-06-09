require 'rails_helper'

RSpec.describe 'Users_system', type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログインする"
  end

  describe 'user一覧の情報が表示されてるか' do
    it 'nameが表示されていること' do
      expect(page).to have_content user.name
    end
  end
end
