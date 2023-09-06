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
        gone_place.name = nil
        gone_place.valid?
        expect(gone_place.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        gone_place.name = ' '
        gone_place.valid?
        expect(gone_place.errors[:name]).to include('を入力してください')
      end

      it 'nameが有効なら登録できること' do
        gone_place.name = 'test_gone_place'
        expect(gone_place).to be_valid
      end
    end

    context 'latitudeに対するバリデーションが有効であるか' do
      it 'latitudeが空なら登録できないこと' do
        gone_place.latitude = ' '
        gone_place.valid?
        expect(gone_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeがnilなら登録できないこと' do
        gone_place.latitude = nil
        gone_place.valid?
        expect(gone_place.errors[:latitude]).to include('で検索し位置を指定してください')
      end

      it 'latitudeが有効なら登録できること' do
        gone_place.latitude = 1
        expect(gone_place).to be_valid
      end
    end

    context 'longitudeに対するバリデーションが有効であるか' do
      it 'longitudeが空なら登録できないこと' do
        gone_place.longitude = ' '
        gone_place.valid?
        expect(gone_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeがnilなら登録できないこと' do
        gone_place.longitude = nil
        gone_place.valid?
        expect(gone_place.errors[:longitude]).to include('したい位置にピンを刺してください')
      end

      it 'longitudeが有効なら登録できること' do
        gone_place.longitude = 1
        expect(gone_place).to be_valid
      end
    end

    context 'reviewに対するバリデーションが有効であるか' do
      it 'reviewが空なら登録できないこと' do
        gone_place.review = ' '
        gone_place.valid?
        expect(gone_place.errors[:review]).to include('を入力してください')
      end

      it 'reviewがnilなら登録できないこと' do
        gone_place.review = nil
        gone_place.valid?
        expect(gone_place.errors[:review]).to include('を入力してください')
      end

      it 'reviewが有効なら登録できること' do
        gone_place.review = 'nice'
        expect(gone_place).to be_valid
      end
    end

    context 'scoreに対するバリデーションが有効であるか' do
      it 'scoreが空なら登録できないこと' do
        gone_place.score = ' '
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('を入力してください')
      end

      it 'scoreがnilなら登録できないこと' do
        gone_place.score = nil
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('を入力してください')
      end

      it 'scoreが1未満なら登録できないこと' do
        gone_place.score = 0
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は1以上の値にしてください')
      end

      it 'scoreが1以上なら登録できること' do
        gone_place.score = 1
        expect(gone_place).to be_valid
      end

      it 'scoreが11以上なら登録できないこと' do
        gone_place.score = 11
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は10以下の値にしてください')
      end

      it 'scoreが10以下なら登録できること' do
        gone_place.score = 10
        expect(gone_place).to be_valid
      end

      it 'scoreが小数点を含む場合は登録できないこと' do
        gone_place.score = 5.5
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は整数で入力してください')
      end

      it 'scoreが全角数字の場合は登録できないこと' do
        gone_place.score = '５'
        gone_place.valid?
        expect(gone_place.errors[:score]).to include('は数値で入力してください')
      end
    end
  end

  describe '絞り込み検索が機能しているか' do
    let!(:tokyo) do
      create(:gone_place, user_id: user.id, category_id: category.id, name: 'tokyo', review: 'Kanto',
                          googlemap_name: 'TOKYO',
                          address: 'japan-tokyo')
    end
    let!(:tokyo2) do
      create(:gone_place, user_id: user.id, category_id: category.id, name: 'tokyo2', review: 'Kanto',
                          googlemap_name: 'TOKYO2',
                          address: 'japan-tokyo2')
    end
    let!(:osaka) do
      create(:gone_place, user_id: user.id, category_id: category.id, name: 'osaka', review: 'Kansai',
                          googlemap_name: 'OSAKA',
                          address: 'japan-osaka')
    end

    context 'キーワードが空白またはnilの場合' do
      it 'キーワードがnilの場合、全てのモデルを返すこと' do
        results = GonePlace.search(nil)
        expect(results.count).to eq(3)
      end

      it 'キーワードがnilの場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = GonePlace.search(nil)
        expect(results).to include(tokyo, tokyo2, osaka)
      end

      it 'キーワードが空白の場合、全てのモデルを返すこと' do
        results = GonePlace.search(" ")
        expect(results.count).to eq(3)
      end

      it 'キーワードが空白の場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = GonePlace.search(" ")
        expect(results).to include(tokyo, tokyo2, osaka)
      end
    end

    context 'nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = GonePlace.search("tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = GonePlace.search("tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = GonePlace.search("to")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = GonePlace.search("to")
        expect(results).to include(tokyo, tokyo2)
      end

      it '該当しない場合、何も取得しないこと' do
        results = GonePlace.search("fukuoka")
        expect(results.count).to eq(0)
      end
    end

    context 'reviewで検索する場合' do
      it '該当する1件が取得できていること' do
        results = GonePlace.search("Kansai")
        expect(results.count).to eq(1)
      end

      it '該当するosakaが取得できていること' do
        results = GonePlace.search("Kansai")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = GonePlace.search("Kans")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = GonePlace.search("Kans")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = GonePlace.search("Kant")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = GonePlace.search("kant")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'googlemap_nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = GonePlace.search("TOKYO2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = GonePlace.search("TOKYO2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = GonePlace.search("OSA")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = GonePlace.search("OSA")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = GonePlace.search("TOK")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = GonePlace.search("TOK")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'addressで検索する場合' do
      it '該当する1件が取得できていること' do
        results = GonePlace.search("japan-tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = GonePlace.search("japan-tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = GonePlace.search("japan-o")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = GonePlace.search("japan-o")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = GonePlace.search("japan-t")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = GonePlace.search("japan-t")
        expect(results).to include(tokyo, tokyo2)
      end
    end
  end

  describe '並び替えが機能しているか' do
    let!(:gone_place1) do
      create(:gone_place, user_id: user.id, category_id: category.id, created_at: 1.day.ago, rating: 1, score: 1)
    end
    let!(:gone_place2) do
      create(:gone_place, user_id: user.id, category_id: category.id, created_at: 2.day.ago, rating: 2, score: 2)
    end
    let!(:gone_place3) do
      create(:gone_place, user_id: user.id, category_id: category.id, created_at: 3.day.ago, rating: 3, score: 3)
    end
    context '新しい順に並び替える場合' do
      it 'created_atが新しい順に並んでいること' do
        result_latest = GonePlace.sort_gone_places("latest")
        expect(result_latest).to eq([gone_place1, gone_place2, gone_place3])
      end
    end

    context '古い順に並び替える場合' do
      it 'created_atが古い順に並んでいること' do
        result_old = GonePlace.sort_gone_places("old")
        expect(result_old).to eq([gone_place3, gone_place2, gone_place1])
      end
    end

    context '評価が高い順に並び替える場合' do
      it 'ratingが高い順に並んでいること' do
        result_rating = GonePlace.sort_gone_places("rating")
        expect(result_rating).to eq([gone_place3, gone_place2, gone_place1])
      end
    end

    context 'MYスコアが高い順に並び替える場合' do
      it 'scoreが高い順に並んでいること' do
        result_score = GonePlace.sort_gone_places("score")
        expect(result_score).to eq([gone_place3, gone_place2, gone_place1])
      end
    end

    context 'sort_paramに無効な値が入った場合' do
      it '古い順に並んでいること' do
        result_invalid = GonePlace.sort_gone_places("invalid")
        expect(result_invalid).to eq([gone_place1, gone_place2, gone_place3])
      end
    end
  end
end
