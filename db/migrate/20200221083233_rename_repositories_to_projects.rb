class RenameRepositoriesToProjects < ActiveRecord::Migration[6.0]
  def change
    rename_table :repositories, :projects
  end
end
