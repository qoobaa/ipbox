class BlikCreateOrderJob < ApplicationJob
  Error = Class.new(StandardError)

  def perform(ip:, code:, email:)
    create_order(token: authorize, ip: ip, code: code, email: email)
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

  def create_order(token:, ip:, code:, email:)
    response = Net::HTTP.post(
      URI("https://#{ENV.fetch('PAYU_HOST', 'secure.snd.payu.com')}/api/v2_1/orders"), {
        buyer: {email: email},
        customerIp: ip,
        merchantPosId: ENV.fetch("MERCHANT_POS_ID", "385459"),
        description: "IPBOX.app",
        currencyCode: "PLN",
        totalAmount: "12177",
        products: [{name: "Rejestracja w serwisie IPBOX.app", unitPrice: "12177", quantity: "1"}],
        setting: {invoiceDisabled: "true"},
        payMethods: {payMethod: {type: "PBL", value: "blik", authorizationCode: code}}
      }.to_json,
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token}"
    )

    order = JSON.parse(response.body, object_class: OpenStruct)
    raise Error, order.status.statusDesc if order.status.statusCode != "SUCCESS"

    order.orderId
  end
end
