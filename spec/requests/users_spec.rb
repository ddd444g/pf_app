require 'rails_helper'

RSpec.describe 'Users_request', type: :request do
  describe 'GET /users_index' do
    it 'リクエストが成功すること' do
      get users_url
      expect(response).to have_http_status(200)
    end
  end
end
