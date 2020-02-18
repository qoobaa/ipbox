class AddManualToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :manual, :boolean, default: false, null: true
  end
end
