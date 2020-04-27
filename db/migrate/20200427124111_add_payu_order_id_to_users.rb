class AddPayuOrderIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :payu_order_id, :string
  end
end
