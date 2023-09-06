require 'rails_helper'

RSpec.describe RecommendPlace, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  describe 'RecommendPlaceモデルが登録できるか' do
    let!(:recommend_place) { create(:recommend_place, user_id: user.id, category_id: category.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(recommend_place).to be_valid
    end
  end

  describe 'RecommendPlaceモデルのバリデーションが有効であるか' do
    let!(:recommend_place) { create(:recommend_place, user_id: user.id, category_id: category.id) }
    context 'recommend_place_nameに対するバリデーションが有効であるか' do
      it 'recommend_place_nameがnilなら登録できないこと' do
        recommend_place.recommend_place_name = nil
        recommend_place.valid?
        expect(recommend_place.errors[:recommend_place_name]).to include('を入力してください')
      end

      it 'recommend_place_nameが空なら登録できないこと' do
        recommend_place.recommend_place_name = ' '
        recommend_place.valid?
        expect(recommend_place.errors[:recommend_place_name]).to include('を入力してください')
      end

      it 'recommend_place_nameが有効なら登録できること' do
        recommend_place.recommend_place_name = 'test_recommend_place'
        expect(recommend_place).to be_valid
      end
    end

    context 'recommend_commentに対するバリデーションが有効であるか' do
      it 'recommend_commentがnilなら登録できないこと' do
        recommend_place.recommend_comment = nil
        recommend_place.valid?
        expect(recommend_place.errors[:recommend_comment]).to include('を入力してください')
      end

      it 'recommend_commentが空なら登録できないこと' do
        recommend_place.recommend_comment = ' '
        recommend_place.valid?
        expect(recommend_place.errors[:recommend_comment]).to include('を入力してください')
      end

      it 'recommend_commentが有効なら登録できること' do
        recommend_place.recommend_comment = 'test_recommend_place'
        expect(recommend_place).to be_valid
      end
    end
  end
end
