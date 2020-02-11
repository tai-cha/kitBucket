class RenameColumnPackageIdToAppId < ActiveRecord::Migration[5.1]
  def change
    rename_column :versions, :package_id, :app_id
  end
end
