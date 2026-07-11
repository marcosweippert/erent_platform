class AddMasterToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :master, :boolean, default: false, null: false
  end
end
