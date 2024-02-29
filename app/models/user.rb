class User < ActiveRecord::Base
  has_secure_password

  before_save :downcase_email

  has_many :chatroom_memberships, dependent: :destroy
  has_many :memberships, through: :chatroom_memberships, source: :chatroom

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true # allow_nil: true
  validates :email, format: /@/, if: -> { email.present? }

  def token
    JsonWebToken.encode(user_id: id) if id
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
