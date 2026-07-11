class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :name
      t.string :cpf
      t.string :rg
      t.string :marital_status
      t.string :nationality
      t.string :phone
      t.string :email
      t.string :zip_code
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :complement
      t.integer :status
      t.integer :person_type
      t.text :observations

      t.timestamps
    end
  end
end
