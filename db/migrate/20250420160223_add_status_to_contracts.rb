class AddStatusToContracts < ActiveRecord::Migration[7.1]
  def change
    add_column :contracts, :status, :integer, default: 0
  end
end
