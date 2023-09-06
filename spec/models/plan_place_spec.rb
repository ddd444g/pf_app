require 'rails_helper'

RSpec.describe PlanPlace, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:plan) { create(:plan, user_id: user.id) }

  describe 'PlanPlaceモデルが登録できるか' do
    let!(:plan_place) { create(:plan_place, user_id: user.id, category_id: category.id, plan_id: plan.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(plan_place).to be_valid
    end
  end
end
