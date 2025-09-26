class Skill < ApplicationRecord
  has_one_attached :icon

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
