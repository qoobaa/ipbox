class AddTypeToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :type, :integer
  end
end
