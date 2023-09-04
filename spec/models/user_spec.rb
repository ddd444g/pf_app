require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe 'User' do
    it 'name,email,passwordがあれば有効な状態であること' do
      expect(user).to be_valid
    end
  end

  describe 'Userモデルのバリデーションが有効であるか' do
    context 'nameに対するバリデーションが有効であるか' do
      it 'nameがnilなら登録できないこと' do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        user = build(:user, name: ' ')
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'emailに対するバリデーションが有効であるか' do
      it 'emailがnilなら登録できないこと' do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end

      it 'emailが空なら登録できないこと' do
        user = build(:user, email: ' ')
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end

      it '重複したemailが存在する場合登録できないこと' do
        user = create(:user, email: 'test@test.jp')
        email_test_user = build(:user, email: user.email)
        email_test_user.valid?
        expect(email_test_user.errors[:email]).to include('はすでに存在します')
      end

      it '@がなければ登録できないこと' do
        user = build(:user, email: 'test.jp')
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it 'スペースがあると登録できないこと' do
        user = build(:user, email: 'test @test.jp')
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it '.で終わっている場合登録できないこと' do
        user = build(:user, email: 'test.test@jp.')
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end
    end

    context 'passwordに対するバリデーションが有効であるか' do
      it 'passwordがnilなら登録できないこと' do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'passwordが空なら登録できないこと' do
        user = build(:user, password: ' ')
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'passwordが5文字以下なら登録できないこと' do
        user = build(:user, password: '12345')
        user.valid?
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end

      it 'passwordが6文字以上なら登録できること' do
        user = build(:user, password: '123456')
        expect(user).to be_valid
      end
    end
  end
end
