require 'rails_helper'

RSpec.describe Plan, type: :model do
  let!(:user) { create(:user) }

  describe 'Planモデルが登録できるか' do
    let!(:plan) { create(:plan, user_id: user.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(plan).to be_valid
    end
  end
end
