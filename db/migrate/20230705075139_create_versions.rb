class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.references :feature, null: false, foreign_key: true
      t.boolean :current

      t.timestamps
    end
  end
end
