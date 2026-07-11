class AddInspectorNameToInspections < ActiveRecord::Migration[7.1]
  def change
    add_column :inspections, :inspector_name, :string
  end
end
