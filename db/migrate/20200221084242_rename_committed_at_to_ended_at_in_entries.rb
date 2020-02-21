class RenameCommittedAtToEndedAtInEntries < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :committed_at, :ended_at
  end
end
