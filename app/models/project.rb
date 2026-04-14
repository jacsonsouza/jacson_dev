class Project < ApplicationRecord
  enum :category, { web: 0, mobile: 1 }

  belongs_to :user

  has_many :project_skills, dependent: :destroy
  has_many :skills, through: :project_skills

  has_one_attached :image
  has_rich_text :details

  validates :name, presence: true, length: { minimum: 3 }
  validates :image, presence: true
  validates :short_description, presence: true, length: { in: 20..200 }
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :favorite, inclusion: { in: [true, false] }
  validates :repository, format: URI::DEFAULT_PARSER.make_regexp, allow_blank: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp, allow_blank: true

  scope :by_category, ->(category) { where(category: category) if category.present? }

  def related_projects
    Project.includes(:image_attachment)
           .joins(:skills)
           .where(skills: { id: skill_ids })
           .where.not(id: id)
           .distinct
  end

  def self.category_options
    Project.categories.keys.map do |key|
      [I18n.t("activeRecord.attributes.project.categories.#{key}"), key]
    end
  end

  def category_human
    I18n.t("activeRecord.attributes.project.categories.#{category}")
  end

  def timeline
    if end_date.present?
      "#{start_date.strftime('%b %Y')} - #{end_date.strftime('%b %Y')}"
    else
      "#{start_date.strftime('%b %Y')} - #{I18n.t('time.present')}"
    end
  end
end
