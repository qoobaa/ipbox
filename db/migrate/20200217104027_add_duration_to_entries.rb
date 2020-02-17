class AddDurationToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :duration, :decimal
  end
end
