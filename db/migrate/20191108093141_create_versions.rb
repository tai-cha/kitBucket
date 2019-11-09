class CreateVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :versions do |t|
      t.integer :package_id
      t.string :name
      t.string :file

      t.index [:package_id, :name], unique: true
      t.timestamps
    end
    add_foreign_key :versions, :packages
    remove_column :packages, :version
    remove_column :packages, :file
  end
end
