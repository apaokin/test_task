require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"
require "shoulda-matchers"
require "database_cleaner"
require "factory_girl_rails"
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.


# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|


  # ## Mock Framework
  # config.mock_with :rr
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true
  config.order = "random"
  config.infer_base_class_for_anonymous_controllers = false
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with :truncation
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
    #  puts "Seeding data"
    #   Seed.all
    #   Pack::Seed.all
  end
end
