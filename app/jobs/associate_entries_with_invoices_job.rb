class AssociateEntriesWithInvoicesJob < ApplicationJob
  def perform
    Invoice.find_each do |invoice|
      invoice.send(:associate_entries)
    end
  end
end
