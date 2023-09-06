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

  describe 'PlanPlaceモデルのバリデーションが有効であるか' do
    let!(:plan_place) { create(:plan_place, user_id: user.id, category_id: category.id, plan_id: plan.id) }
    context 'plan_place_nameに対するバリデーションが有効であるか' do
      it 'plan_place_nameがnilなら登録できないこと' do
        plan_place.plan_place_name = nil
        plan_place.valid?
        expect(plan_place.errors[:plan_place_name]).to include('を入力してください')
      end

      it 'plan_place_nameが空なら登録できないこと' do
        plan_place.plan_place_name = ' '
        plan_place.valid?
        expect(plan_place.errors[:plan_place_name]).to include('を入力してください')
      end

      it 'plan_place_nameが有効なら登録できること' do
        plan_place.plan_place_name = 'test_plan_place'
        expect(plan_place).to be_valid
      end
    end

    context 'latitudeに対するバリデーションが有効であるか' do
      it 'latitudeがnilなら登録できないこと' do
        plan_place.latitude = nil
        plan_place.valid?
        expect(plan_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeが空なら登録できないこと' do
        plan_place.latitude = ' '
        plan_place.valid?
        expect(plan_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeが有効なら登録できること' do
        plan_place.latitude = 1
        expect(plan_place).to be_valid
      end
    end

    context 'longitudeに対するバリデーションが有効であるか' do
      it 'longitudeがnilなら登録できないこと' do
        plan_place.longitude = nil
        plan_place.valid?
        expect(plan_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeが空なら登録できないこと' do
        plan_place.longitude = ' '
        plan_place.valid?
        expect(plan_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeが有効なら登録できること' do
        plan_place.longitude = 1
        expect(plan_place).to be_valid
      end
    end
  end
end
