require 'rails_helper'

RSpec.describe User do
  before do
    User.new({ first_name: 'chacha', last_name: 'martineau', email: 'fanny@mail.fr', password: 'chacha',
               password_confirmation: 'chacha' }).save
  end

  describe 'validation' do
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'chacha@mail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be true
    }
    it {
      expect(User.new({ first_name: '', last_name: 'martineau', email: 'chacha@mail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: nil, last_name: 'martineau', email: 'chacha@mail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: nil, email: 'chacha@mail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: nil, password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'chachamail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'fanny@mail.fr', password: 'chacha',
                        password_confirmation: 'chacha' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'chachamail.fr', password: nil,
                        password_confirmation: nil }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'chachamail.fr', password: ' ',
                        password_confirmation: ' ' }).save).to be false
    }
    it {
      expect(User.new({ first_name: 'chacha', last_name: 'martineau', email: 'chachamail.fr', password: 'chacha',
                        password_confirmation: 'cha' }).save).to be false
    }
  end
end
