class BlikCaptureJob < ApplicationJob
  Error = Class.new(StandardError)

  def perform(order_id)
    capture_order(token: authorize, id: order_id)
  end

  private

  def authorize
    response = Net::HTTP.post_form(
      URI("https://#{ENV.fetch('PAYU_HOST', 'secure.snd.payu.com')}/pl/standard/oauth/authorize"),
      grant_type: "client_credentials",
      client_id: ENV.fetch("CLIENT_ID", "385459"),
      client_secret: ENV.fetch("CLIENT_SECRET", "8e156d07a4e5f0887b727c001e5098fe")
    )

    authorize = JSON.parse(response.body, object_class: OpenStruct)
    raise Error, authorize.error_description if authorize.error

    authorize.access_token
  end

  def capture_order(token:, id:)
    uri = URI("https://#{ENV.fetch('PAYU_HOST', 'secure.snd.payu.com')}/api/v2_1/orders/#{id}/status")
    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer #{token}"
    request["Content-Type"] = "application/json"
    request.body = {orderId: id, orderStatus: "COMPLETED"}.to_json
    response = Net::HTTP.new(uri.hostname, uri.port).tap { |http| http.use_ssl = true }.start { |http| http.request(request) }

    order = JSON.parse(response.body, object_class: OpenStruct)
    raise Error, order.status.statusDesc if order.status.statusCode != "SUCCESS"
  end
end
