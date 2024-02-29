require 'rails_helper'

RSpec.describe ChatroomMembership, type: :model do
  let!(:user) do
    FactoryBot.create(:user)
  end

  let!(:chatroom) do
    Chatroom.create(name: "Paul's birthday")
  end

  describe 'validation' do
    it { expect(ChatroomMembership.new({ chatroom:, user: }).save).to be true }
    it { expect(ChatroomMembership.new({ chatroom: nil, user: }).save).to be false }
    it { expect(ChatroomMembership.new({ chatroom:, user: nil }).save).to be false }
  end
end
