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

  describe '絞り込み検索が機能しているか' do
    let!(:tokyo) do
      create(:recommend_place, user_id: user.id, category_id: category.id, recommend_place_name: 'tokyo',
                               recommend_comment: 'Kanto',
                               googlemap_name: 'TOKYO',
                               address: 'japan-tokyo')
    end
    let!(:tokyo2) do
      create(:recommend_place, user_id: user.id, category_id: category.id, recommend_place_name: 'tokyo2',
                               recommend_comment: 'Kanto',
                               googlemap_name: 'TOKYO2',
                               address: 'japan-tokyo2')
    end
    let!(:osaka) do
      create(:recommend_place, user_id: user.id, category_id: category.id, recommend_place_name: 'osaka',
                               recommend_comment: 'Kansai',
                               googlemap_name: 'OSAKA',
                               address: 'japan-osaka')
    end

    context 'キーワードが空白またはnilの場合' do
      it 'キーワードがnilの場合、全てのモデルを返すこと' do
        results = RecommendPlace.search(nil)
        expect(results.count).to eq(3)
      end

      it 'キーワードがnilの場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = RecommendPlace.search(nil)
        expect(results).to include(tokyo, tokyo2, osaka)
      end

      it 'キーワードが空白の場合、全てのモデルを返すこと' do
        results = RecommendPlace.search(" ")
        expect(results.count).to eq(3)
      end

      it 'キーワードが空白の場合、tokyo,tokyo2,osakaが検索結果に含まれていること' do
        results = RecommendPlace.search(" ")
        expect(results).to include(tokyo, tokyo2, osaka)
      end
    end

    context 'recommned_place_nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = RecommendPlace.search("tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = RecommendPlace.search("tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = RecommendPlace.search("to")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = RecommendPlace.search("to")
        expect(results).to include(tokyo, tokyo2)
      end

      it '該当しない場合、何も取得しないこと' do
        results = RecommendPlace.search("fukuoka")
        expect(results.count).to eq(0)
      end
    end

    context 'recommend_commentで検索する場合' do
      it '該当する1件が取得できていること' do
        results = RecommendPlace.search("Kansai")
        expect(results.count).to eq(1)
      end

      it '該当するosakaが取得できていること' do
        results = RecommendPlace.search("Kansai")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = RecommendPlace.search("Kans")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = RecommendPlace.search("Kans")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = RecommendPlace.search("Kant")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = RecommendPlace.search("kant")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'googlemap_nameで検索する場合' do
      it '該当する1件が取得できていること' do
        results = RecommendPlace.search("TOKYO2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = RecommendPlace.search("TOKYO2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = RecommendPlace.search("OSA")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = RecommendPlace.search("OSA")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = RecommendPlace.search("TOK")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = RecommendPlace.search("TOK")
        expect(results).to include(tokyo, tokyo2)
      end
    end

    context 'addressで検索する場合' do
      it '該当する1件が取得できていること' do
        results = RecommendPlace.search("japan-tokyo2")
        expect(results.count).to eq(1)
      end

      it '該当するtokyo2が取得できていること' do
        results = RecommendPlace.search("japan-tokyo2")
        expect(results).to include(tokyo2)
      end

      it '部分一致で該当する1件が取得できていること' do
        results = RecommendPlace.search("japan-o")
        expect(results.count).to eq(1)
      end

      it '部分一致で該当するosakaが取得できていること' do
        results = RecommendPlace.search("japan-o")
        expect(results).to include(osaka)
      end

      it '部分一致で該当する2件が取得できていること' do
        results = RecommendPlace.search("japan-t")
        expect(results.count).to eq(2)
      end

      it '部分一致で該当するtokyo,tokyo2が取得できていること' do
        results = RecommendPlace.search("japan-t")
        expect(results).to include(tokyo, tokyo2)
      end
    end
  end

  describe '並び替えが機能しているか' do
    let!(:recommend_place1) do
      create(:recommend_place, user_id: user.id, category_id: category.id, created_at: 1.day.ago, rating: 1)
    end
    let!(:recommend_place2) do
      create(:recommend_place, user_id: user.id, category_id: category.id, created_at: 2.day.ago, rating: 2)
    end
    let!(:recommend_place3) do
      create(:recommend_place, user_id: user.id, category_id: category.id, created_at: 3.day.ago, rating: 3)
    end
    context '新しい順に並び替える場合' do
      it 'created_atが新しい順に並んでいること' do
        result_latest = RecommendPlace.sort_recommend_places("latest")
        expect(result_latest).to eq([recommend_place1, recommend_place2, recommend_place3])
      end
    end

    context '古い順に並び替える場合' do
      it 'created_atが古い順に並んでいること' do
        result_old = RecommendPlace.sort_recommend_places("old")
        expect(result_old).to eq([recommend_place3, recommend_place2, recommend_place1])
      end
    end

    context '評価が高い順に並び替える場合' do
      it 'ratingが高い順に並んでいること' do
        result_rating = RecommendPlace.sort_recommend_places("rating")
        expect(result_rating).to eq([recommend_place3, recommend_place2, recommend_place1])
      end
    end

    context 'sort_paramに無効な値が入った場合' do
      it '古い順に並んでいること' do
        result_invalid = RecommendPlace.sort_recommend_places("invalid")
        expect(result_invalid).to eq([recommend_place1, recommend_place2, recommend_place3])
      end
    end
  end
end
