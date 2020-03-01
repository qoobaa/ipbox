class AddUuidToProjects < ActiveRecord::Migration[6.0]
  def change
    enable_extension "uuid-ossp"
    add_column :projects, :uuid, :uuid, default: "uuid_generate_v4()"
    add_index :projects, :uuid, unique: true
  end
end
