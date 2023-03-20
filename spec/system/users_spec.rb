require 'rails_helper'

RSpec.describe "Users_system", type: :system do
  let!(:user) { create(:user) }

  before do
    visit users_path
  end

  describe 'user一覧の情報が表示されてるか' do
    it "nameが表示されていること" do
      expect(page).to have_content user.name
    end
  end
end
