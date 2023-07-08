class AddVersionReferenceToMapping < ActiveRecord::Migration[7.0]
  def change
    add_reference :mappings, :version, foreign_key: true
  end
end
