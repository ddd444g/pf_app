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
        place.name = nil
        place.valid?
        expect(place.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        place.name = ' '
        place.valid?
        expect(place.errors[:name]).to include('を入力してください')
      end

      it 'nameが有効なら登録できること' do
        place.name = 'test_place'
        expect(place).to be_valid
      end
    end

    context 'latitudeに対するバリデーションが有効であるか' do
      it 'latitudeがnilなら登録できないこと' do
        place.latitude = nil
        place.valid?
        expect(place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeが空なら登録できないこと' do
        place.latitude = ' '
        place.valid?
        expect(place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeが有効なら登録できること' do
        place.latitude = 1
        expect(place).to be_valid
      end
    end

    context 'longitudeに対するバリデーションが有効であるか' do
      it 'longitudeがnilなら登録できないこと' do
        place.longitude = nil
        place.valid?
        expect(place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeが空なら登録できないこと' do
        place.longitude = ' '
        place.valid?
        expect(place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeが有効なら登録できること' do
        place.longitude = 1
        expect(place).to be_valid
      end
    end
  end

  describe '絞り込み検索が機能しているか' do
    let!(:tokyo) do
      create(:place, user_id: user.id, category_id: category.id, name: 'tokyo', memo: 'Kanto',
                     googlemap_name: 'TOKYO',
                     address: 'japan-tokyo')
    end
    let!(:tokyo2) do
      create(:place, user_id: user.id, category_id: category.id, name: 'tokyo2', memo: 'Kanto',
                     googlemap_name: 'TOKYO2',
                     address: 'japan-tokyo2')
    end
    let!(:osaka) do
      create(:place, user_id: user.id, category_id: category.id, name: 'osaka', memo: 'Kansai',
                     googlemap_name: 'OSAKA',
                     address: 'japan-osaka')
    end

    context 'キーワードが空白またはnilの場合' do
      it 'キーワードがnilの場合、全てのモデルを返すこと' do
        results = Place.search(nil)
        expect(results.count).to eq(3)
      end

      it 'キーワードがnilの場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = Place.search(nil)
        expect(results).to include(tokyo, tokyo2, osaka)
      end

      it 'キーワードが空白の場合、全てのモデルを返すこと' do
        results = Place.search(" ")
        expect(results.count).to eq(3)
      end

      it 'キーワードが空白の場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = Place.search(" ")
        expect(results).to include(tokyo, tokyo2, osaka)
      end
    end

    context 'nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = Place.search("tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = Place.search("tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = Place.search("to")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = Place.search("to")
        expect(results).to include(tokyo, tokyo2)
      end

      it '該当しない場合、何も取得しないこと' do
        results = Place.search("fukuoka")
        expect(results.count).to eq(0)
      end
    end

    context 'memoで検索する場合' do
      it '該当する1件が取得できていること' do
        results = Place.search("Kansai")
        expect(results.count).to eq(1)
      end

      it '該当するosakaが取得できていること' do
        results = Place.search("Kansai")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = Place.search("Kans")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = Place.search("Kans")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = Place.search("Kant")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = Place.search("kant")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'googlemap_nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = Place.search("TOKYO2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = Place.search("TOKYO2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = Place.search("OSA")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = Place.search("OSA")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = Place.search("TOK")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = Place.search("TOK")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'addressで検索する場合' do
      it '該当する1件が取得できていること' do
        results = Place.search("japan-tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = Place.search("japan-tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = Place.search("japan-o")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = Place.search("japan-o")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = Place.search("japan-t")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = Place.search("japan-t")
        expect(results).to include(tokyo, tokyo2)
      end
    end
  end

  describe '並び替えが機能しているか' do
    let!(:place1) { create(:place, user_id: user.id, category_id: category.id, created_at: 1.day.ago, rating: 1) }
    let!(:place2) { create(:place, user_id: user.id, category_id: category.id, created_at: 2.day.ago, rating: 2) }
    let!(:place3) { create(:place, user_id: user.id, category_id: category.id, created_at: 3.day.ago, rating: 3) }
    context '新しい順に並び替える場合' do
      it 'created_atが新しい順に並んでいること' do
        result_latest = Place.sort_places("latest")
        expect(result_latest).to eq([place1, place2, place3])
      end
    end

    context '古い順に並び替える場合' do
      it 'created_atが古い順に並んでいること' do
        result_old = Place.sort_places("old")
        expect(result_old).to eq([place3, place2, place1])
      end
    end

    context '評価が高い順に並び替える場合' do
      it 'ratingが高い順に並んでいること' do
        result_rating = Place.sort_places("rating")
        expect(result_rating).to eq([place3, place2, place1])
      end
    end

    context 'sort_paramに無効な値が入った場合' do
      it '古い順に並んでいること' do
        result_invalid = Place.sort_places("invalid")
        expect(result_invalid).to eq([place1, place2, place3])
      end
    end
  end
end
