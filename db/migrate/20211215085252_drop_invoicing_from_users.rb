class DropInvoicingFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :company_name, :string
    remove_column :users, :address, :string
    remove_column :users, :postal_code, :string
    remove_column :users, :city, :string
    remove_column :users, :vatin, :string
    remove_column :users, :stripe_customer_id, :string
    remove_column :users, :stripe_payment_intent_id, :string
    remove_column :users, :tos_accepted, :boolean
    remove_column :users, :einvoice_accepted, :boolean
    remove_column :users, :payu_order_id, :string
  end
end
