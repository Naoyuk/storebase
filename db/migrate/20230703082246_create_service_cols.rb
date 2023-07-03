class CreateServiceCols < ActiveRecord::Migration[7.0]
  def change
    create_table :service_cols do |t|
      t.references :service_format, null: false, foreign_key: true
      t.string :ec_column
      t.integer :data_type

      t.timestamps
    end
  end
end
