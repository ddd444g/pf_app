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

  describe 'Placeモデルのバリデーションが有効であるか' do
    let!(:place) { create(:place, user_id: user.id, category_id: category.id) }
    context 'nameに対するバリデーションが有効であるか' do
      it 'nameがnilなら登録できないこと' do
        gone_place = build(:gone_place, name: nil)
        gone_place.valid?
        expect(gone_place.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        gone_place = build(:gone_place, name: ' ')
        gone_place.valid?
        expect(gone_place.errors[:name]).to include('を入力してください')
      end
    end

    context 'latitudeに対するバリデーションが有効であるか' do
      it 'latitudeが空なら登録できないこと' do
        gone_place = build(:gone_place, latitude: ' ')
        gone_place.valid?
        expect(gone_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeがnilなら登録できないこと' do
        gone_place = build(:gone_place, latitude: nil)
        gone_place.valid?
        expect(gone_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end
    end

    context 'longitudeに対するバリデーションが有効であるか' do
      it 'longitudeが空なら登録できないこと' do
        gone_place = build(:gone_place, longitude: ' ')
        gone_place.valid?
        expect(gone_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudenilがnilなら登録できないこと' do
        gone_place = build(:gone_place, longitude: nil)
        gone_place.valid?
        expect(gone_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end
    end
  end
end
