class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.datetime :committed_at
      t.text :message

      t.timestamps
    end
  end
end
