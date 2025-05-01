class CreateTeeTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :tee_times do |t|
      t.references :course, null: false, foreign_key: true
      t.references :scrape_event, null: false, foreign_key: true
      t.datetime :time, null: false
      t.integer :min_price_cents, default: 0
      t.integer :max_price_cents, default: 0
      t.boolean :is_hot_deal, default: false
      t.timestamps
    end
  end
end
