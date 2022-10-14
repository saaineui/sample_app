source "https://rubygems.org"

ruby '3.1.2'

gem 'bcrypt', '3.1.18'
gem 'jbuilder'
gem 'jquery-rails'
gem 'rails', '7.0.3'
gem 'sass-rails', '6.0.0'
gem 'sdoc', group: :doc
gem 'uglifier'
gem 'ffi', '1.15.5'

group :development do
  gem 'rubocop',        '0.49.1', require: false
end

group :development, :test do
  gem 'spring'
  gem 'sqlite3'
  gem 'listen'
  gem 'jasmine',        '3.99.0'
end

group :test do
  gem 'rails-controller-testing', '1.0.5'
  gem 'simplecov', require: false
end

group :production do
  gem 'pg',             '1.4.3'
  gem 'puma',           '5.6.5'
end
