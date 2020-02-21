class RenameMessageToDescriptionInEntries < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :message, :description
  end
end
