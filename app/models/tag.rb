class Tag < ApplicationRecord
  has_many :skill_tags, dependent: :destroy
  has_many :skills, through: :skill_tags

  validates :name, presence: true, uniqueness: true
end
