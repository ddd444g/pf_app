require 'rails_helper'

RSpec.describe Plan, type: :model do
  let!(:user) { create(:user) }

  describe 'Planモデルが登録できるか' do
    let!(:plan) { create(:plan, user_id: user.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(plan).to be_valid
    end
  end

  describe 'planモデルのバリデーションが有効であるか' do
    let!(:plan) { create(:plan, user_id: user.id) }
    context 'plan_nameに対するバリデーションが有効であるか' do
      it 'nameがnilなら登録できないこと' do
        plan.plan_name = nil
        plan.valid?
        expect(plan.errors[:plan_name]).to include('を入力してください')
      end

      it 'plan_nameが空なら登録できないこと' do
        plan.plan_name = ' '
        plan.valid?
        expect(plan.errors[:plan_name]).to include('を入力してください')
      end

      it 'plan_nameが有効なら登録できること' do
        plan.plan_name = 'test_plan'
        expect(plan).to be_valid
      end
    end
  end
end
