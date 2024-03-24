require 'rails_helper'

RSpec.describe Api::ChatroomsController, type: :controller do
  let(:valid_attributes) do
    { name: "Jane's birthday" }
  end

  let(:no_name_attributes) do
    { name: '' }
  end

  let!(:user1) do
    FactoryBot.create(:user)
  end

  let!(:user2) do
    FactoryBot.create(:user, first_name: 'Henri', last_name: 'Charles', email: 'henri-charles@mail.fr')
  end

  let!(:chatroom1) do
    Chatroom.create(name: "Paul's birthday")
  end

  let!(:chatroom2) do
    Chatroom.create(name: 'Week end copains')
  end

  let!(:chatroom_membership) do
    chatroom1.chatroom_memberships.create!(user: user2)
  end

  let!(:chatroom_membership2) do
    chatroom2.chatroom_memberships.create!(user: user1)
  end

  let(:result) { JSON.parse(response.body) }

  describe 'GET index' do
    context 'works with valid attributes' do
      before do
        get :index, params: { token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['chatrooms'][0]['name']).to eq("Paul's birthday") }
      it { expect(result['chatrooms'].count).to eq(1) }
    end
  end

  describe 'GET show' do
    context 'works with valid attributes' do
      before do
        get :show, params: { id: chatroom1.id, token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['chatroom']['name']).to eq("Paul's birthday") }
    end

    context 'no token' do
      before { get :show, params: { id: chatroom1.id }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Nil JSON web token') }
    end

    context 'wrong id' do
      before { get :show, params: { id: 342, token: user2.token }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(result['error']['message']).to eq('Can not find chatroom') }
    end

    context 'unauthorized user' do
      before { get :show, params: { id: chatroom2.id, token: user2.token }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Unauthorized user') }
    end
  end

  describe 'POST create' do
    context 'works with valid attributes' do
      before { post :create, params: { token: user2.token, chatroom: valid_attributes }, format: :json }
      it { expect(response.status).to eq(201) }
      it { expect(result['chatroom']['name']).to eq("Jane's birthday") }
    end

    context 'works with no name' do
      before { post :create, params: { token: user2.token, chatroom: no_name_attributes }, format: :json }
      it { expect(response.status).to eq(201) }
      it { expect(result['chatroom']['name']).to eq('') }
    end
  end

  describe 'PATCH update' do
    context 'works with valid attributes' do
      before do
        put :update, params: { id: chatroom1.id, token: user2.token, chatroom: valid_attributes },
                     format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['chatroom']['name']).to eq("Jane's birthday") }
    end

    context 'wrong id' do
      before { put :update, params: { id: 342, token: user2.token, chatroom: valid_attributes }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(result['error']['message']).to eq('Can not find chatroom') }
    end
  end
end
