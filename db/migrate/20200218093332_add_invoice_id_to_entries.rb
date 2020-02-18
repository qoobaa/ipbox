class AddInvoiceIdToEntries < ActiveRecord::Migration[6.0]
  def change
    add_reference :entries, :invoice, foreign_key: true
  end
end
