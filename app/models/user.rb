class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable

  has_many :skills, dependent: :destroy

  validate :only_one_user_allowed, on: :create
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  private

  def only_one_user_allowed
    errors.add(:base, I18n.t('errors.messages.only_one_user')) if User.count >= 1
  end
end
