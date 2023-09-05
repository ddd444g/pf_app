require 'rails_helper'

RSpec.describe Place, type: :model do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }

  describe 'Placeモデルが登録できるか' do
    let!(:place) { create(:place, user_id: user.id, category_id: category.id) }
    it 'すべての項目があれば有効な状態であること' do
      expect(place).to be_valid
    end
  end

  describe 'Placeモデルのバリデーションが有効であるか' do
    let!(:place) { create(:place, user_id: user.id, category_id: category.id) }
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

  describe '絞り込み検索が機能しているか' do
    let!(:place1) do
      create(:place, user_id: user.id, category_id: category.id, name: 'Tokyo', memo: 'Kanto region',
                     googlemap_name: 'tokyo',
                     address: 'japan tokyo')
    end
    let!(:place2) do
      create(:place, user_id: user.id, category_id: category.id, name: 'Osaka', memo: 'Kansai region',
                     googlemap_name: 'osaka',
                     address: 'japan osaka')
    end
    let!(:place3) do
      create(:place, user_id: user.id, category_id: category.id, name: 'Kobe', memo: 'Kansai region',
                     googlemap_name: 'kobe',
                     address: 'japan kobe')
    end

    context 'キーワードが空白またはnilの場合' do
      it 'キーワードがnilの場合、全てのモデルを返すこと' do
        results = Place.search(nil)
        expect(results.count).to eq(3)
      end

      it 'キーワードがnilの場合、place1,2,3が検索結果に含まれていること' do
        results = Place.search(nil)
        expect(results).to include(place1, place2, place3)
      end

      it 'キーワードが空白の場合、全てのモデルを返すこと' do
        results = Place.search(" ")
        expect(results.count).to eq(3)
      end

      it 'キーワードが空白の場合、place1,2,3が検索結果に含まれていること' do
        results = Place.search(" ")
        expect(results).to include(place1, place2, place3)
      end
    end
  end
end
