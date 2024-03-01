require 'rails_helper'

RSpec.describe ChatroomMembershipsController, type: :controller do
  let!(:user1) do
    FactoryBot.create(:user)
  end

  let!(:user2) do
    FactoryBot.create(:user, first_name: 'Henri', last_name: 'Charles', email: 'henri-charles@mail.fr')
  end

  let!(:user3) do
    FactoryBot.create(:user, first_name: 'Léo', last_name: 'Martin', email: 'leo@mail.fr')
  end

  let!(:chatroom1) do
    Chatroom.create(name: "Paul's birthday")
  end

  let!(:chatroom_membership) do
    chatroom1.chatroom_memberships.create!(user: user3)
  end

  let(:result) { JSON.parse(response.body) }

  describe 'POST create' do
    context 'works with valid attributes' do
      before do
        post :create, params: { token: user2.token, chatroom_id: chatroom1.id, user_ids: [user1.id, user2.id] },
                      format: :json
      end
      it { expect(response.status).to eq(201) }
      it { expect(result['chatroom']['members'][1]['first_name']).to eq(user1.first_name) }
    end

    context 'missing token' do
      before do
        post :create, params: { token: nil, chatroom_id: chatroom1.id, user_ids: [user1.id, user2.id] }, format: :json
      end
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Nil JSON web token') }
    end

    context 'wrong chatroom id' do
      before do
        post :create, params: { token: user2.token, chatroom_id: 12, user_ids: [user1.id] }, format: :json
      end
      it { expect(response.status).to eq(404) }
      it { expect(result['error']['message']).to eq('Can not find chatroom') }
    end

    context 'user already member' do
      before do
        post :create, params: { token: user2.token, chatroom_id: chatroom1.id, user_ids: [user3.id] }, format: :json
      end
      it { expect(response.status).to eq(400) }
      it {
        expect(result['error']['message']).to include('Can not create chatroom membership')
      }
    end
  end

  describe 'DELETE destroy' do
    context 'responds with 200' do
      before do
        delete :destroy,
               params: { token: user2.token, chatroom_id: chatroom1.id, id: 1 }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['chatroom']['members'].size).to eq(0) }
    end

    context 'wrong chatroom id' do
      before { delete :destroy, params: { token: user2.token, chatroom_id: 14, id: 1 }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(result['error']['message']).to eq('Can not find chatroom') }
    end
  end
end
