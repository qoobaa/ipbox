class RenameShaToExternalIdInEntries < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :sha, :external_id
  end
end
