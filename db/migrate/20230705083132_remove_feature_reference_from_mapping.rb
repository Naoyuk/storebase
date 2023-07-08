class RemoveFeatureReferenceFromMapping < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :mappings, :features
    remove_reference :mappings, :feature, index: true
  end
end
