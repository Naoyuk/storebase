class AddUrlToFeature < ActiveRecord::Migration[7.0]
  def change
    add_column :features, :url, :string
    add_column :features, :emoji, :string
  end
end
