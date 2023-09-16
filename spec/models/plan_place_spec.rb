require 'rails_helper'

RSpec.describe PlanPlace, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:plan) { create(:plan, user_id: user.id) }

  describe 'PlanPlaceモデルの関連付けが出来ているか' do
    it 'userとの関連付けがあること' do
      should belong_to(:user)
    end

    it 'planとの関連付けがあること' do
      should belong_to(:plan)
    end

    it 'placeとの関連付けがあること' do
      should belong_to(:place).optional(true)
    end

    it 'gone_placeとの関連付けがあること' do
      should belong_to(:gone_place).optional(true)
    end

    it 'categoryとの関連付けがあること' do
      should belong_to(:category)
    end
  end

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

  describe 'PlanPlaceモデルは紐ずくPlanモデルの開始時刻から終了時刻までの間でしか登録できないか' do
    let!(:plan2) { create(:plan, user_id: user.id, start_time: '2023-01-01 0:00:00', end_time: '2024-01-01 0:00:00') }
    let!(:plan_place) do
      create(:plan_place, user_id: user.id, category_id: category.id, plan_id: plan2.id, start_time: user.id)
    end
    it 'PlanPlaceのstart_timeがnilの場合登録できること' do
      plan_place.start_time = nil
      expect(plan_place).to be_valid
    end

    it 'PlanPlaceのstart_timeが空の場合登録できること' do
      plan_place.start_time = ' '
      expect(plan_place).to be_valid
    end

    it 'PlanPlaceのstart_timeがPlanの開始時間1分前の場合登録できないこと' do
      plan_place.start_time = '2022-12-31 23:59:59'
      plan_place.valid?
      expect(plan_place.errors[:start_time]).to include('はプランの期間内で設定してください')
    end

    it 'PlanPlaceのstart_timeがPlanの終了時間1分後の場合登録できないこと' do
      plan_place.start_time = '2024-01-01 0:01:00'
      plan_place.valid?
      expect(plan_place.errors[:start_time]).to include('はプランの期間内で設定してください')
    end

    it 'PlanPlaceのstart_timeがPlanの開始時間と同じ場合登録できること' do
      plan_place.start_time = '2023-01-01 0:00:00'
      expect(plan_place).to be_valid
    end

    it 'PlanPlaceのstart_timeがPlanの終了時間と同じ場合登録できること' do
      plan_place.start_time = '2024-01-01 0:00:00'
      expect(plan_place).to be_valid
    end
  end
end
