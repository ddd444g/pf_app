require 'rails_helper'

RSpec.describe Place, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:place) { create(:place, user_id: user.id, category_id: category.id) }

  describe 'Placeモデルが登録できるか' do
    it 'すべての項目があれば有効な状態であること' do
      expect(place).to be_valid
    end
  end
end
