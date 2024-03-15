require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  let(:result) { JSON.parse(response.body) }

  def user_to_json_response(instance_user)
    JSON.parse(Api::UserBaseSerializer.new(instance_user, { include_token: true }).to_json)
  end

  describe 'POST #login with email/password' do
    context 'user exists' do
      before { post 'login', params: { user: { email: user.email, password: 'password' }, format: 'json' } }
      it { expect(response.status).to eq(200) }
      it { expect(result['user']['email']).to eq('john-doe@mail.com') }
      it { expect(result['user']['token']).to eq(user_to_json_response(user.reload)['token']) }
      it { expect(result).to eq({ 'user' => user_to_json_response(user.reload) }) }
    end

    context 'user do not exists' do
      before { post 'login', params: { user: { email: 'email@email.com', password: 'password' }, format: 'json' } }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Could not authenticate user') }
    end
  end
end
