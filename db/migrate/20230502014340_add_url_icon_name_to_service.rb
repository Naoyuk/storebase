class AddUrlIconNameToService < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :url, :string
    add_column :services, :icon, :string
  end
end
