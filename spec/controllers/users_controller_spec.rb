require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {  first_name: 'Charles', last_name: 'henri', email: 'henri@mail.fr', password: 'henri-password',
       password_confirmation: 'henri-password' }
  end
  let(:no_first_name_attributes) do
    {  last_name: 'Henri', email: 'henri@mail.fr', password: 'henri-password',
       password_confirmation: 'henri-password' }
  end
  let(:no_last_name_attributes) do
    { first_name: 'Charles', email: 'henri@mail.fr', password: 'henri-password',
      password_confirmation: 'henri-password' }
  end
  let(:no_email_attributes) do
    { first_name: 'Charles', last_name: 'Henri', password: 'henri-password',
      password_confirmation: 'henri-password' }
  end
  let(:no_unique_email_attributes) do
    { first_name: 'Charles', last_name: 'Henri', email: 'henri-charles@mail.fr', password: 'henri-password',
      password_confirmation: 'henri-password' }
  end
  let(:wrong_email_format) do
    { first_name: 'Charles', last_name: 'Henri', email: 'henrimail.fr', password: 'henri-password',
      password_confirmation: 'henri-password' }
  end
  let(:no_password_attributes) do
    { first_name: 'Charles', last_name: 'Henri', email: 'henri@mail.fr' }
  end
  let(:wrong_password_confirmation) do
    { first_name: 'Charles', last_name: 'Henri', email: 'henri@mail.fr', password: 'henri-password',
      password_confirmation: 'password' }
  end

  let!(:user1) do
    FactoryBot.create(:user)
  end

  let!(:user2) do
    # User.create(first_name: 'Henri', last_name: 'Charles')
    FactoryBot.create(:user, first_name: 'Henri', last_name: 'Charles', email: 'henri-charles@mail.fr')
  end

  let(:result) { JSON.parse(response.body) }

  describe 'GET index' do
    context 'works with valid attributes' do
      before do
        get :index, params: { token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['users'][0]['first_name']).to eq('John') }
      it { expect(result['users'][0]['last_name']).to eq('Doe') }
      it { expect(result['users'][0]['email']).to eq('john-doe@mail.com') }
    end
  end

  describe 'GET show' do
    context 'works with valid attributes' do
      before do
        get :show, params: { id: user2.id, token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['user']['first_name']).to eq('Henri') }
      it { expect(result['user']['last_name']).to eq('Charles') }
      it { expect(result['user']['email']).to eq('henri-charles@mail.fr') }
    end

    context 'no token' do
      before { get :show, params: { id: user2.id }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Nil JSON web token') }
    end

    context 'unauthorized token' do
      before { get :show, params: { id: user2.id, token: user1.token }, format: :json }
      it { expect(response.status).to eq(401) }
      it { expect(result['error']['message']).to eq('Unauthorized user') }
    end

    context 'wrong id' do
      before { get :show, params: { id: 342, token: user2.token }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(result['error']['message']).to eq('Can not find user') }
    end
  end

  describe 'POST create' do
    context 'works with valid attributes' do
      before { post :create, params: { user: valid_attributes }, format: :json }
      it { expect(response.status).to eq(201) }
      it { expect(result['user']['first_name']).to eq('Charles') }
      it { expect(result['user']['last_name']).to eq('Henri') }
      it { expect(result['user']['email']).to eq('henri@mail.fr') }
    end

    context 'missing first name' do
      before { post :create, params: { user: no_first_name_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include("First name can't be blank") }
    end

    context 'missing last name' do
      before { post :create, params: { user: no_last_name_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include("Last name can't be blank") }
    end

    context 'missing email' do
      before { post :create, params: { user: no_email_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include("Email can't be blank") }
    end

    context 'email uniqueness' do
      before { post :create, params: { user: no_unique_email_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include('Email has already been taken') }
    end

    context 'email format' do
      before { post :create, params: { user: wrong_email_format }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include('Email is invalid') }
    end

    context 'missing password' do
      before { post :create, params: { user: no_password_attributes }, format: :json }
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['error']['message']).to include("Password can't be blank") }
    end

    context 'wrong password confirmation' do
      before { post :create, params: { user: wrong_password_confirmation }, format: :json }
      it { expect(response.status).to eq(400) }
      it {
        expect(JSON.parse(response.body)['error']['message']).to include("Password confirmation doesn't match Password")
      }
    end
  end

  describe 'PATCH update' do
    context 'works with valid attributes' do
      before do
        put :update, params: { id: user2.to_param, token: user2.token, user: valid_attributes },
                     format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['user']['first_name']).to eq('Charles') }
      it { expect(result['user']['last_name']).to eq('Henri') }
      it { expect(result['user']['email']).to eq('henri@mail.fr') }
    end

    context 'wrong id' do
      before { put :update, params: { id: 342, token: user2.token, user: valid_attributes }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(JSON.parse(response.body)['error']['message']).to eq('Can not find user') }
    end

    context 'wrong password confirmation' do
      before do
        put :update, params: { id: user2.to_param, token: user2.token, user: wrong_password_confirmation },
                     format: :json
      end
      it { expect(response.status).to eq(400) }
      it {
        expect(JSON.parse(response.body)['error']['message']).to include("Password confirmation doesn't match Password")
      }
    end
  end

  describe 'DELETE destroy' do
    context 'responds with 200' do
      before do
        delete :destroy, params: { id: user2.id, token: user2.token }, format: :json
      end
      it { expect(response.status).to eq(200) }
      it { expect(result['users'].size).to eq(1) }
    end

    context 'wrong id' do
      before { delete :destroy, params: { id: 342, token: user2.token }, format: :json }
      it { expect(response.status).to eq(404) }
      it { expect(JSON.parse(response.body)['error']['message']).to eq('Can not find user') }
    end
  end
end
