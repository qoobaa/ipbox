require_relative 'boot'

require 'rails/all'
require_relative "../lib/middleware/import_content_type"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ipbox
  class Application < Rails::Application
    config.load_defaults 6.0

    config.time_zone = "Europe/Warsaw"
    config.i18n.default_locale = :pl
    config.i18n.available_locales = :pl
    config.middleware.insert_before ActionDispatch::Executor, ::Middleware::ImportContentType
  end
end
