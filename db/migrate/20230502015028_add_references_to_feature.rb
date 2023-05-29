class AddReferencesToFeature < ActiveRecord::Migration[7.0]
  def change
    add_reference :features, :service, foreign_key: true
  end
end
