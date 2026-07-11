class Contract < ApplicationRecord
  belongs_to :property
  belongs_to :tenant, class_name: "Person"
  belongs_to :owner, class_name: "Person"
  has_many :inspections, dependent: :destroy

  enum contract_period: { six_months: 6, twelve_months: 12, twenty_four_months: 24 }
  enum payment_method: { pix: 0, boleto: 1 }
  enum payment_day: { dia_5: 5, dia_10: 10, dia_15: 15, dia_20: 20, dia_25: 25 }
  enum status: { active: 0, finalized: 1, reserved: 2 }

  validates :rent_value, :start_date, :end_date, presence: true
  validates :signature_date, :contract_period, presence: true, unless: :reserved?
  validates :payment_method, :payment_day, :first_payment_date, :first_payment_value, presence: true, if: :active?
  has_many :contract_amendments, dependent: :destroy
end