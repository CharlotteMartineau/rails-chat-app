class Chatroom < ApplicationRecord
    validates :name, presence: true
end
