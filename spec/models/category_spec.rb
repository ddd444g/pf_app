require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Categoryモデルの関連付けが出来ているか' do
    it 'placesとの関連付けがあること' do
      should have_many(:places)
    end

    it 'gone_placesとの関連付けがあること' do
      should have_many(:gone_places)
    end

    it 'plan_placesとの関連付けがあること' do
      should have_many(:plan_places)
    end

    it 'recommend_placesとの関連付けがあること' do
      should have_many(:recommend_places)
    end
  end
end
