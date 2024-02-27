require 'rails_helper'

RSpec.describe Chatroom, type: :model do
  describe 'validation' do
    it { expect(Chatroom.new({ name: "Nico's birthday" }).save).to be true }
    it { expect(Chatroom.new({ name: nil }).save).to be false }
    it { expect(Chatroom.new({ name: ' ' }).save).to be false }
  end
end
