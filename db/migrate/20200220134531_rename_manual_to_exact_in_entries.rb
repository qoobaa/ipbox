class RenameManualToExactInEntries < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :manual, :exact
  end
end
