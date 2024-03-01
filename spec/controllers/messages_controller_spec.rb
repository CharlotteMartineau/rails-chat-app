require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:user1) do
    FactoryBot.create(:user)
  end

  let!(:chatroom1) do
    Chatroom.create(name: "Paul's birthday")
  end

  let!(:chatroom_membership) do
    chatroom1.chatroom_memberships.create!(user: user1)
  end

  let!(:message) do
    user1.messages.create!(chatroom_id: chatroom_membership.id, content: 'hey')
  end

  let!(:message2) do
    user1.messages.create!(chatroom_id: chatroom_membership.id, content: 'hola')
  end

  let(:result) { JSON.parse(response.body) }

  describe 'POST create' do
    context 'works with valid attributes' do
      before do
        post :create, params: { token: user1.token, chatroom_id: chatroom1.id, content: 'hello' },
                      format: :json
      end
      it { expect(response.status).to eq(201) }
      it { expect(result['message']['content']).to eq('hello') }
    end

    context 'missing token' do
      before do
        post :create, params: { token: nil, chatroom_id: chatroom1.id, content: 'hello' }, format: :json
      end
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Nil JSON web token') }
    end

    context 'wrong chatroom id' do
      before do
        post :create, params: { token: user1.token, chatroom_id: 12, content: 'hello' }, format: :json
      end
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Unauthorized') }
    end
  end

  describe 'DELETE destroy' do
    context 'responds with 200' do
      before do
        delete :destroy, params: { token: user1.token, id: 2 }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['message_id']).to eq(2) }
    end

    context 'wrong message id' do
      before { delete :destroy, params: { token: user1.token, id: 4 }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Unauthorized') }
    end

    context 'missing token' do
      before { delete :destroy, params: { token: nil, id: 1 }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Nil JSON web token') }
    end
  end
end
