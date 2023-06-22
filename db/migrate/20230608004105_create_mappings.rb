class CreateMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :mappings do |t|
      t.references :feature, null: false, foreign_key: true
      t.string :user_column
      t.string :ec_column
      t.integer :data_type

      t.timestamps
    end
  end
end
