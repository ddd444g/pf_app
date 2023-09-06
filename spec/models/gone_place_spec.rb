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

  describe 'GonePlaceモデルのバリデーションが有効であるか' do
    let!(:gone_place) { create(:gone_place, user_id: user.id, category_id: category.id) }
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

    context 'reviewに対するバリデーションが有効であるか' do
      it 'reviewが空なら登録できないこと' do
        gone_place = build(:gone_place, review: ' ')
        gone_place.valid?
        expect(gone_place.errors[:review]).to include('を入力してください')
      end

      it 'reviewがnilなら登録できないこと' do
        gone_place = build(:gone_place, review: nil)
        gone_place.valid?
        expect(gone_place.errors[:review]).to include('を入力してください')
      end
    end

    context 'scoreに対するバリデーションが有効であるか' do
      it 'scoreが空なら登録できないこと' do
        gone_place = build(:gone_place, score: " ")
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('を入力してください')
      end

      it 'scoreがnilなら登録できないこと' do
        gone_place = build(:gone_place, score: nil)
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('を入力してください')
      end

      it 'scoreが1未満なら登録できないこと' do
        gone_place = build(:gone_place, score: 0)
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は1以上の値にしてください')
      end

      it 'scoreが11以上なら登録できないこと' do
        gone_place = build(:gone_place, score: 11)
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は10以下の値にしてください')
      end

      it 'scoreが小数点を含む場合は登録できないこと' do
        gone_place = build(:gone_place, score: 5.5)
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は整数で入力してください')
      end

      it 'scoreが全角数字の場合は登録できないこと' do
        gone_place = build(:gone_place, score: '５')
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は数値で入力してください')
      end
    end
  end
end
