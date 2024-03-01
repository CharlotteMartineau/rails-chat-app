require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:user) do
    FactoryBot.create(:user)
  end

  let!(:chatroom) do
    Chatroom.create(name: "Paul's birthday")
  end

  describe 'validation' do
    it { expect(Message.new({ chatroom:, user:, content: 'Hello' }).save).to be true }
    it { expect(Message.new({ content: nil }).save).to be false }
    it { expect(Message.new({ content: ' ' }).save).to be false }
  end
end
