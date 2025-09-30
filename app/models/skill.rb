class Skill < ApplicationRecord
  has_one_attached :icon
  has_rich_text :description

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
