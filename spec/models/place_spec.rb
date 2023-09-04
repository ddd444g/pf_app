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

  describe 'Placeモデルのバリデーションが有効であるか' do
    context 'nameに対するバリデーションが有効であるか' do
      it 'nameがnilなら登録できないこと' do
        place = build(:place, name: nil)
        place.valid?
        expect(place.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        place = build(:place, name: ' ')
        place.valid?
        expect(place.errors[:name]).to include('を入力してください')
      end
    end

    context 'latitudeに対するバリデーションが有効であるか' do
      it 'latitudeが空なら登録できないこと' do
        place = build(:place, latitude: ' ')
        place.valid?
        expect(place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeがnilなら登録できないこと' do
        place = build(:place, latitude: nil)
        place.valid?
        expect(place.errors[:latitude]).to include('で検索し位置を指定してください')
      end
    end

    context 'longitudeに対するバリデーションが有効であるか' do
      it 'longitudeが空なら登録できないこと' do
        place = build(:place, longitude: ' ')
        place.valid?
        expect(place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudenilがnilなら登録できないこと' do
        place = build(:place, longitude: nil)
        place.valid?
        expect(place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end
    end
  end
end
