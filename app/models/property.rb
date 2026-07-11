class Property < ApplicationRecord
  belongs_to :owner, class_name: "Person"
  has_many :inspections, dependent: :destroy

  enum property_type: { studio: 0, house: 1, warehouse: 2 }
  enum category: { commercial: 0, residential: 1 }
  enum status: { available: 0, rented: 1, reserved: 2 }
  has_many :contracts, dependent: :nullify
  has_many :reserved_contracts, -> { where(status: :reserved) }, class_name: "Contract"

  def self.refresh_reservation_statuses!
    where(status: :reserved).find_each(&:refresh_reservation_status!)
  end

  def refresh_reservation_status!
    return unless reserved?

    return if current_reserved_contract.present?

    reserved_contracts.where("end_date < ?", Date.current).find_each do |contract|
      tenant = contract.tenant
      if tenant.present? && tenant.contracts.where(status: [:active, :reserved]).where.not(id: contract.id).none?
        tenant.update(status: :available)
      end
    end

    update(status: :available)
  end

  def current_reserved_contract
    reserved_contracts.where("start_date <= ? AND end_date >= ?", Date.current, Date.current).order(start_date: :asc).first ||
      reserved_contracts.where("end_date >= ?", Date.current).order(start_date: :asc).first
  end

  def reserved_tenant_name
    current_reserved_contract&.tenant&.name
  end

end