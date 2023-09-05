require 'rails_helper'

RSpec.describe GonePlace, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }

  describe 'GonePlaceモデルが登録できるか' do
    let!(:gone_place) { create(:gone_place, user_id: user.id, category_id: category.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(gone_place).to be_valid
    end
  end
end
