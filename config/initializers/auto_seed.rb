if Rails.env.development?
  Rails.application.config.after_initialize do
    puts "⏳ Running seeds..."
    load(Rails.root.join('db', 'seeds.rb'))
  end
end
