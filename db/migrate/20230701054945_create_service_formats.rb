class CreateServiceFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :service_formats do |t|
      t.references :service, null: false, foreign_key: true
      t.string :version
      t.boolean :active
      t.boolean :current

      t.timestamps
    end
  end
end
