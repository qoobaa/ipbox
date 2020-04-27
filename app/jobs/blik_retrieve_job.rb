class BlikRetrieveJob < ApplicationJob
  Error = Class.new(StandardError)

  def perform(order_id)
    retrieve_order(token: authorize, id: order_id)
  end

  private

  def authorize
    response = Net::HTTP.post_form(
      URI("https://#{ENV.fetch('PAYU_HOST', 'secure.snd.payu.com')}/pl/standard/oauth/authorize"),
      grant_type: "client_credentials",
      client_id: ENV.fetch("PAYU_CLIENT_ID", "385459"),
      client_secret: ENV.fetch("PAYU_CLIENT_SECRET", "8e156d07a4e5f0887b727c001e5098fe")
    )

    authorize = JSON.parse(response.body, object_class: OpenStruct)
    raise Error, authorize.error_description if authorize.error

    authorize.access_token
  end

  def retrieve_order(token:, id:)
    uri = URI("https://#{ENV.fetch('PAYU_HOST', 'secure.snd.payu.com')}/api/v2_1/orders/#{id}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{token}"

    response = Net::HTTP.new(uri.hostname, uri.port).tap { |http| http.use_ssl = true }.start { |http| http.request(request) }

    order = JSON.parse(response.body, object_class: OpenStruct)
    raise Error, order.status.statusDesc if order.status.statusCode != "SUCCESS"

    order.dig("orders", 0, "status")
  end
end
