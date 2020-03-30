class AddEinvoiceAcceptedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :einvoice_accepted, :boolean
  end
end
