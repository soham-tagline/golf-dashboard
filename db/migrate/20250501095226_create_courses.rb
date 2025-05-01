class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :city
      t.string :state
      t.string :booking_system
      t.boolean :scraper_active, default: false
      t.boolean :has_antibot, default: false
      t.integer :blocked_count, default: 0
      t.timestamps
    end
  end
end
