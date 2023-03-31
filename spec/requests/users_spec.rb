require 'rails_helper'

RSpec.describe 'Users_request', type: :request do
  let(:user) { create(:user) }

  before do
    get login_path
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  describe 'GET /users_index' do
    it 'ログインが成功しuser一覧ページにリダイレクトすること' do
      get users_url
      expect(response).to have_http_status(302)
    end
  end
end
