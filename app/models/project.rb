class Project < ApplicationRecord
  belongs_to :user

  has_many :project_skills, dependent: :destroy
  has_many :skills, through: :project_skills

  has_one_attached :image
  has_rich_text :details

  validates :name, presence: true, length: { minimum: 5 }
  validates :image, presence: true
  validates :short_description, presence: true, length: { in: 20..200 }
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }, allow_blank: true
  validates :favorite, inclusion: { in: [true, false] }
  validates :repository, format: URI::DEFAULT_PARSER.make_regexp, allow_blank: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp, allow_blank: true
end
