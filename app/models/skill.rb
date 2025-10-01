class Skill < ApplicationRecord
  enum :proficiency, { beginner: 0, intermediate: 1, advanced: 2 }

  has_one_attached :icon
  has_rich_text :description

  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :icon, presence: true
  validates :description, presence: true
  validates :proficiency, presence: true, inclusion: { in: proficiencies }

  def proficiencies
    [:beginner, :intermediate, :advanced]
  end
end
