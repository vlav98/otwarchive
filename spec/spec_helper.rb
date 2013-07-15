require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.

end
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
#require File.expand_path('../../features/support/factories.rb', __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'database_cleaner'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

FactoryGirl.find_definitions
FactoryGirl.definition_file_paths = %w(factories)

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.include FactoryGirl::Syntax::Methods
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  BAD_EMAILS = ['Abc.example.com','A@b@c@example.com','a\"b(c)d,e:f;g<h>i[j\k]l@example.com','just"not"right@example.com','this is"not\allowed@example.com','this\ still\"not/\/\allowed@example.com']
  INVALID_URLS = ['no_scheme.com', 'ftp://ftp.address.com','http://www.b@d!35.com','https://www.b@d!35.com','http://b@d!35.com','https://www.b@d!35.com']
  VALID_URLS = ['http://rocksalt-recs.livejournal.com/196316.html','https://rocksalt-recs.livejournal.com/196316.html']
  INACTIVE_URLS = ['https://www.iaminactive.com','http://www.iaminactive.com','https://iaminactive.com','http://iaminactive.com']
end
