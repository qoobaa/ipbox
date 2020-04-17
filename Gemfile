source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"
gem "backup"
gem "devise"
gem "icalendar"
gem "jbuilder"
gem "kaminari"
gem "octicons"
gem "pg"
gem "puma"
gem "rails"
gem "rails-i18n"
gem "ransack"
gem "redis"
gem "rollbar"
gem "rubyzip", require: "zip"
gem "sass-rails"
gem "sidekiq", require: ["sidekiq", "sidekiq/web"]
gem "sidekiq-scheduler"
gem "sprockets", "~> 3"
gem "stripe"
gem "turbolinks"
gem "webpacker"

gem "bootsnap", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "web-console"
  gem "listen"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
