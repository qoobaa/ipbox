class AddTosAcceptedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tos_accepted, :boolean
  end
end
