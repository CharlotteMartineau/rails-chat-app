require 'rails_helper'

RSpec.describe ChatroomsController, type: :controller do
  let(:valid_attributes) do
    { name: "Jane's birthday" }
  end

  let(:no_name_attributes) do
    { name: '' }
  end

  let!(:chatroom1) do
    Chatroom.create(name: "Paul's birthday")
  end

  let!(:user2) do
    FactoryBot.create(:user, first_name: 'Henri', last_name: 'Charles', email: 'henri-charles@mail.fr')
  end

  let(:result) { JSON.parse(response.body) }

  describe 'GET index' do
    context 'works with valid attributes' do
      before do
        get :index, params: { token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['chatrooms'][0]['name']).to eq("Paul's birthday") }
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
  end

  describe 'POST create' do
    context 'works with valid attributes' do
      before { post :create, params: { token: user2.token, chatroom: valid_attributes }, format: :json }
      it { expect(response.status).to eq(201) }
      it { expect(result['chatroom']['name']).to eq("Jane's birthday") }
    end

    context 'missing name' do
      before { post :create, params: { token: user2.token, chatroom: no_name_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include("Name can't be blank") }
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
      it { expect(JSON.parse(response.body)['error']['message']).to eq('Can not find chatroom') }
    end
  end
end
