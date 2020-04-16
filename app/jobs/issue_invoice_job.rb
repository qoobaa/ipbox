class IssueInvoiceJob < ApplicationJob
  def perform
    uri = URI("https://kubakuzma.fakturownia.pl/invoices.json")
    request = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")

    request.body = {
      api_token: "FJRZiIvwdUvp3129QkhB/kubakuzma",
      invoice: {
        kind: "vat",
	# number: nil,
	sell_date: "2020-04-16",
	# issue_date: "2020-04-16",
	# payment_to: "2020-04-23",
	# seller_name: "Seller SA",
	# seller_tax_no: "5252445767",
	buyer_name: "Client1 SA",
	buyer_tax_no: "5252445767",
	positions: [
	  {
            name: "Rejestracja w serwisie IPBOX.APP",
            tax: 23,
            total_price_gross: 121.77,
            quantity: 1
          }
	]
      }
    }.to_json

    Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
  end
end
