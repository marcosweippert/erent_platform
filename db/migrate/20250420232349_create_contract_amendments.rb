class CreateContractAmendments < ActiveRecord::Migration[7.1]
  def change
    create_table :contract_amendments do |t|
      t.references :contract, null: false, foreign_key: { to_table: :contracts }
      t.date :amendment_start_date
      t.date :amendment_end_date
      t.decimal :amendment_rent_value
      t.string :amendment_contract_period

      t.timestamps
    end
  end
end
