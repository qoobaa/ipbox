class AddDurationToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :hours, :decimal
  end
end
