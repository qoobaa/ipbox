class IssueInvoiceJob < ApplicationJob
  Error = Class.new(StandardError)

  def perform(user, type)
    endpoint = "https://kubakuzma.fakturownia.pl/invoices.json"
    uri = URI.parse(endpoint)

    json_params = {
      api_token: ENV.fetch("FAKTUROWNIA_API_TOKEN"),
      invoice: {
	kind: "vat",
	sell_date: user.created_at.to_date.to_s,
        payment_to: user.created_at.to_date.to_s,
        payment_type: type,
        paid: "121.77",
	buyer_name: user.company_name,
        buyer_post_code: user.postal_code,
        buyer_city: "Warszawa",
        buyer_street: user.address,
        buyer_country: "PL",
        buyer_email: user.email,
	buyer_tax_no: user.vatin,
	positions: [
	  {
            name: "Rejestracja w serwisie IPBOX.app",
            tax: 23,
            total_price_gross: 121.77,
            quantity: 1
	  }
        ]
      }}

    request = Net::HTTP::Post.new(uri.path)
    request.body = JSON.generate(json_params)
    request["Content-Type"] = "application/json"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.start { |h| h.request(request) }

    if response.code == "201"
      JSON.parse(response.body)
    else
      raise Error, JSON.parse(response.body).dig("message")
    end
  end
end
