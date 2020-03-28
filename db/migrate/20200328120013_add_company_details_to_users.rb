class AddCompanyDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :company_name, :string
    add_column :users, :address, :string
    add_column :users, :postal_code, :string
    add_column :users, :city, :string
    add_column :users, :vatin, :string
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_payment_intent_id, :string
  end
end
