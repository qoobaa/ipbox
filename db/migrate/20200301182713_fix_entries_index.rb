class FixEntriesIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :entries, [:external_id, :project_id]
    add_index :entries, [:external_id, :user_id], unique: true
  end
end
