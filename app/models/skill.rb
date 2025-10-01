class Skill < ApplicationRecord
  has_one_attached :icon
  has_rich_text :description

  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, presence: true
end
