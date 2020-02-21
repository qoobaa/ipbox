class RenameRepositoryIdToProjectIdInEntries < ActiveRecord::Migration[6.0]
  def change
    rename_column :entries, :repository_id, :project_id
  end
end
