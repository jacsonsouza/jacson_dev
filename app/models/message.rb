class Message < ApplicationRecord
  validates :identity, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { minimum: 5, maximum: 255 }
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }

  scope :filter_by_read, ->(read) { where(read: read) if read.present? }
end
