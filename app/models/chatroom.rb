class Chatroom < ApplicationRecord
  has_many :chatroom_memberships, dependent: :destroy
  has_many :members, through: :chatroom_memberships, source: :user

  validates :name, presence: true
end
