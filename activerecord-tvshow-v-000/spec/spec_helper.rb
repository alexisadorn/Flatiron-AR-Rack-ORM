ENV["ACTIVE_RECORD_ENV"] = "test"

require_relative '../config/environment'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
    DatabaseCleaner.clean
    system("rake db:migrate")
  end

end
