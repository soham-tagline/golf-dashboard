class Course < ApplicationRecord
  has_many :scrape_events, dependent: :destroy
  has_many :tee_times, dependent: :destroy
  has_many :scrape_errors, through: :scrape_events
end