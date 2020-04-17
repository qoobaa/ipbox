class Scheduled::HealthCheckJob
  include Sidekiq::Worker

  def perform
    id = ENV["HEALTHCHECK_ID"]

    Net::HTTP.get(URI.parse("https://hc-ping.com/#{id}")) if id.present?
  end
end
