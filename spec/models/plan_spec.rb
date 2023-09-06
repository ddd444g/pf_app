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

    context 'start_timeに対するバリデーションが有効であるか' do
      it 'start_timeがnilなら登録できないこと' do
        plan.start_time = nil
        plan.valid?
        expect(plan.errors[:start_time]).to include('を入力してください')
      end

      it 'start_timeが空なら登録できないこと' do
        plan.start_time = ' '
        plan.valid?
        expect(plan.errors[:start_time]).to include('を入力してください')
      end
    end

    context 'end_timeに対するバリデーションが有効であるか' do
      it 'end_timeがnilなら登録できないこと' do
        plan.end_time = nil
        plan.valid?
        expect(plan.errors[:end_time]).to include('を入力してください')
      end

      it 'end_timeが空なら登録できないこと' do
        plan.end_time = ' '
        plan.valid?
        expect(plan.errors[:end_time]).to include('を入力してください')
      end
    end

    context 'plan_colorに対するバリデーションが有効であるか' do
      it 'plan_colorがnilなら登録できないこと' do
        plan.plan_color = nil
        plan.valid?
        expect(plan.errors[:plan_color]).to include('を入力してください')
      end

      it 'plan_colorが空なら登録できないこと' do
        plan.plan_color = ' '
        plan.valid?
        expect(plan.errors[:plan_color]).to include('を入力してください')
      end
    end
  end

  describe '自作のバリデーションが有効であるか' do
    let!(:plan) { create(:plan, user_id: user.id, start_time: Time.now, end_time: Time.now + 1.hour) }
    context 'start_timeよりend_timeが後でないと登録出来ないか' do
      it 'start_timeがend_timeより後の場合登録出来ないこと' do
        plan.end_time = Time.now - 1.hour
        plan.valid?
        expect(plan.errors[:end_time]).to include('は開始日時より後にして下さい')
      end

      it 'start_timeがend_timeより前の場合登録出来ること' do
        expect(plan).to be_valid
      end
    end

    context 'start_timeよりend_timeが1分以上後でないと登録出来ないか' do
      it 'start_timeがend_timeと同じ時刻なら登録出来ないこと' do
        plan.end_time = Time.now
        plan.end_time = Time.now
        plan.valid?
        expect(plan.errors[:end_time]).to include('は開始日時より、1分以上後にして下さい')
      end

      it 'start_timeがend_time1分以上後なら登録出来ること' do
        plan.end_time = Time.now
        plan.end_time = Time.now + 1.minute
        expect(plan).to be_valid
      end
    end
  end
end
