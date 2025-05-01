class ScrapeEvent < ApplicationRecord
  belongs_to :course
  has_many :scrape_errors, dependent: :destroy
  has_many :tee_times, dependent: :destroy
end