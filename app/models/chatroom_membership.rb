class ChatroomMembership < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :user, uniqueness: { scope: :chatroom }
end
