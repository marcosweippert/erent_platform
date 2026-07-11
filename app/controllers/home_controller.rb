class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @people_count = Person.count
    @properties_count = Property.count
    @contracts_count = Contract.count
    @amendments_count = ContractAmendment.count

    Property.refresh_reservation_statuses!
    @available_properties = Property.available.order(:id).includes(:owner)
    @tenants = Person.where(person_type: :tenant, status: :available)

    # Build last 6 months labels and contract counts
    months = (5).downto(0).map { |i| Time.current - i.months }
    @chart_labels = months.map { |m| m.strftime("%b %Y") }
    @chart_data = months.map do |m|
      start_date = m.beginning_of_month
      end_date = m.end_of_month
      Contract.where(created_at: start_date..end_date).count
    end
  end
end

