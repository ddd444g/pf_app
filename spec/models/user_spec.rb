require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe 'Userモデルの関連付けが出来ているか' do
    it "userは複数のplacesを持っていること" do
      should have_many(:places).dependent(:delete_all)
    end

    it "userは複数のgone_placesを持っていること" do
      should have_many(:gone_places).dependent(:destroy)
    end

    it "userは複数のrecommend_placesを持っていること" do
      should have_many(:recommend_places).dependent(:delete_all)
    end

    it "userは複数のplansを持っていること" do
      should have_many(:plans).dependent(:delete_all)
    end

    it "userは複数のplan_placesを持っていること" do
      should have_many(:plan_places).dependent(:delete_all)
    end
  end

  describe 'Userモデルが登録できるか' do
    it 'name,email,passwordがあれば有効な状態であること' do
      expect(user).to be_valid
    end
  end

  describe 'Userモデルのバリデーションが有効であるか' do
    context 'nameに対するバリデーションが有効であるか' do
      it 'nameがnilなら登録できないこと' do
        user.name = nil
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end

      it 'nameが空なら登録できないこと' do
        user.name = ' '
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end

      it 'nameがあれば登録できること' do
        user.name = 'taro'
        expect(user).to be_valid
      end
    end

    context 'emailに対するバリデーションが有効であるか' do
      it 'emailがnilなら登録できないこと' do
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end

      it 'emailが空なら登録できないこと' do
        user.email = ' '
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
        user.email = 'test.jp'
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it 'スペースがあると登録できないこと' do
        user.email = 'test @test.jp'
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it '.で終わっている場合登録できないこと' do
        user.email = 'test.test@jp.'
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end

      it '正規表現であれば場合登録できること' do
        user.email = 'test@test.jp'
        expect(user).to be_valid
      end
    end

    context 'passwordに対するバリデーションが有効であるか' do
      it 'passwordがnilなら登録できないこと' do
        user.password = nil
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'passwordが空なら登録できないこと' do
        user.password = ' '
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'passwordが5文字以下なら登録できないこと' do
        user.password = '12345'
        user.valid?
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end

      it 'passwordが6文字以上なら登録できること' do
        user.password = '123456'
        user.password_confirmation = user.password
        expect(user).to be_valid
      end

      it 'passwordがpassword_confirmationと一致しない場合登録できないこと' do
        user.password = '123456'
        user.password_confirmation = '654321'
        user.valid?
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end
  end
end
