class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :reference
      t.string :zip_code
      t.string :street
      t.string :neighborhood
      t.string :number
      t.string :city
      t.string :state
      t.string :complement
      t.decimal :rent_value
      t.integer :property_type
      t.integer :category
      t.integer :status
      t.references :owner, null: false, foreign_key: { to_table: :people }

      t.timestamps
    end
  end
end
