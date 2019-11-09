class RemoveColumnFileFromVersions < ActiveRecord::Migration[5.1]
  def change
    remove_column :versions, :file
  end
end
