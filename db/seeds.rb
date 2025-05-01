# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear existing data
Course.destroy_all
ScrapeEvent.destroy_all
TeeTime.destroy_all
ScrapeError.destroy_all

puts "Creating courses..."
10.times do
  Course.create!(
    name: Faker::Company.name + " Golf Club",
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    booking_system: ["EZLinks", "GolfNow", "TeeOff", "ClubCaddie"].sample,
    scraper_active: [true, false].sample,
    has_antibot: [true, false].sample,
    blocked_count: rand(0..5)
  )
end

courses = Course.all

puts "Creating scrape events..."
10.times do
  start_time = Faker::Time.between(from: 1.month.ago, to: Time.current)
  scrape_event = ScrapeEvent.create!(
    course: courses.sample,
    scrape_start: start_time,
    scrape_end: [start_time + rand(10..300).seconds, nil].sample,
    tee_time_count: rand(0..50),
    has_error: [true, false].sample
  )

  if scrape_event.has_error
    rand(1..3).times do
      ScrapeError.create!(
        scrape_event: scrape_event,
        error_type: ["Timeout", "Antibot Blocked", "Connection Failed", "Parser Error"].sample,
        error_message: Faker::Lorem.sentence,
        created_at: scrape_event.scrape_start + rand(1..60).seconds
      )
    end
  end
end

scrape_events = ScrapeEvent.all

puts "Creating tee times..."
10.times do
  date = Faker::Date.between(from: Date.today, to: 1.month.from_now)
  time = Faker::Time.between(from: date.beginning_of_day + 6.hours, to: date.beginning_of_day + 18.hours)

  TeeTime.create!(
    course: courses.sample,
    scrape_event: scrape_events.sample,
    time: time,
    min_price_cents: rand(5000..15000),
    max_price_cents: rand(15000..30000),
    is_hot_deal: [true, false].sample
  )
end

puts "Seeding completed successfully!"
puts "#{Course.count} courses created"
puts "#{ScrapeEvent.count} scrape events created"
puts "#{TeeTime.count} tee times created"
puts "#{ScrapeError.count} scrape errors created"