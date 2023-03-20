require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  
  describe "User" do
    it "nameがあれば有効な状態であること" do
      expect(user).to be_valid
    end
  end

  describe "Userモデルのバリデーションが有効であるか" do
    context "nameに対するバリデーション" do
      it "nameがnilなら登録できないこと" do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "nameが空なら登録できないこと" do
        user = build(:user, name: " ")
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end
    end
  end
end
