class CreateInspections < ActiveRecord::Migration[7.1]
  def change
    create_table :inspections do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.string :inspection_type
      t.date :inspection_date
      t.text :checklist
      t.text :observations
      t.string :status
      t.string :entry_type
      t.date :landlord_signature_date
      t.date :tenant_signature_date
      t.string :landlord_name
      t.string :tenant_name
      t.string :landlord_document
      t.string :tenant_document

      t.timestamps
    end
  end
end
