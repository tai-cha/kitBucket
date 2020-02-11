class RenameTablePackagesToApps < ActiveRecord::Migration[5.1]
  def change
    rename_table :packages, :apps
  end
end
