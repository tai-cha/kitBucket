class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|
      t.string :package_id
      t.string :name
      t.string :version
      t.string :author
      t.string :file

      t.index :package_id, unique: true
      t.timestamps
    end
  end
end
