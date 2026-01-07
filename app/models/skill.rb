class Skill < ApplicationRecord
  has_one_attached :icon
  has_rich_text :description
  has_many :skill_tags, dependent: :destroy
  has_many :tags, through: :skill_tags

  belongs_to :user

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 50 }

  validates :icon, :description, presence: true
  validates :color, format: { with: /\A#([A-Fa-f0-9]{6})\z/ }
  validates :short_description, length: { minimum: 10 }
  validates :proficiency, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def tag_list
    tags.pluck(:name).join(', ')
  end

  def tag_list=(tag_names)
    return if tag_names.blank?

    new_tags = parse_tag_names(tag_names).map do |tag_name|
      Tag.find_or_create_by(name: tag_name)
    end

    self.tags = new_tags.uniq
  end

  private

  def parse_tag_names(names)
    names.to_s
         .split(',')
         .map { |name| name.strip.downcase }
         .compact_blank
  end
end
