class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :property, null: false, foreign_key: { to_table: :properties }
      t.references :tenant, null: false, foreign_key: { to_table: :people }
      t.references :owner, null: false, foreign_key: { to_table: :people }
      t.decimal :rent_value
      t.integer :contract_period
      t.date :start_date
      t.date :end_date
      t.date :signature_date
      t.decimal :interest_rate
      t.decimal :fine_rate
      t.string :guarantee
      t.decimal :guarantee_value
      t.date :guarantee_payment_date
      t.integer :guarantee_installments
      t.integer :payment_method
      t.integer :payment_day
      t.date :first_payment_date
      t.decimal :first_payment_value

      t.timestamps
    end
  end
end
