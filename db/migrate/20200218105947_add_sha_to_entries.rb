class AddShaToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :sha, :string
    add_reference :entries, :repository, foreign_key: true
    add_index :entries, [:sha, :repository_id], unique: true
  end
end
