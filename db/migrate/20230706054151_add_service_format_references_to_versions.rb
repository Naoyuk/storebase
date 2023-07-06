class AddServiceFormatReferencesToVersions < ActiveRecord::Migration[7.0]
  def change
    add_reference :versions, :service_format, null: false, foreign_key: true
  end
end
