class RemoveColumnFromFeature < ActiveRecord::Migration[7.0]
  def change
    remove_column :features, :url
    remove_column :features, :emoji
    remove_column :features, :name
  end
end
