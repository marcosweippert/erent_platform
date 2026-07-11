class ContractsController < ApplicationController
  before_action :set_contract, only: %i[show edit update destroy finalize]

  def index
    @active_contracts = Contract.where(status: :active)
    @contracts = Contract.order(:id)
  end

  def show
  end
  
  def contract_pdf
    Rails.logger.debug ">>> params[:id] = #{params[:id].inspect}"
    @contract = Contract.find(params[:id])
    respond_to do |format|
      format.pdf do
        render pdf: "contract_#{@contract.id}",
               template: "contracts/contract",
               formats: [:html],
               layout: "pdf",
               show_as_html: params[:debug].present?
      end
    end
  end
  
  def new
    @contract = Contract.new(status: :active)
    if params[:property_id].present?
      prop = Property.find_by(id: params[:property_id])
      if prop
        @contract.property_id = prop.id
        @contract.owner_id = prop.owner_id
        @contract.rent_value = prop.rent_value
      end
    end
    @tenants = Person.where(person_type: :tenant, status: :available)
  end

  def edit
    @tenants = Person.where(person_type: :tenant, status: :available)
    @properties = Property.where(status: :available)
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.status ||= :active
    @contract.signature_date ||= Date.current if @contract.active? || @contract.reserved?
    @contract.owner_id ||= @contract.property&.owner_id

    if @contract.save
      if @contract.reserved?
        @contract.tenant.update(status: :unavailable)
        @contract.property.update(status: :reserved)
        redirect_to @contract, notice: 'Reserva registrada com sucesso.'
      else
        @contract.tenant.update(status: :unavailable)
        @contract.property.update(status: :rented)
        redirect_to @contract, notice: 'Contrato criado com sucesso.'
      end
    else
      @tenants = Person.where(person_type: :tenant, status: :available)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contract.start_date.present? && @contract.contract_period.present?
      months = case @contract.contract_period
               when "six_months" then 6
               when "twelve_months" then 12
               when "twenty_four_months" then 24
               else 0
               end
      @contract.end_date = @contract.start_date.advance(months: months)
    end

    if @contract.update(contract_params)
      if @contract.reserved?
        @contract.tenant.update(status: :unavailable)
        @contract.property.update(status: :reserved)
      elsif @contract.active?
        @contract.tenant.update(status: :unavailable)
        @contract.property.update(status: :rented)
      end
      redirect_to @contract, notice: 'Contrato atualizado com sucesso.'
    else
      @tenants = Person.where(person_type: :tenant, status: :available)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contract.tenant.update(status: :available)
    @contract.property.update(status: :available)
    @contract.destroy
    redirect_to contracts_path, notice: 'Contrato excluído com sucesso.'
  end

  def finalize
    @contract = Contract.find(params[:id])
    if params[:contract] && params[:contract][:end_date].present?
      if @contract.update(end_date: params[:contract][:end_date], status: :finalized)
        @contract.property.update(status: :available)
        @contract.tenant.update(status: :available)
        redirect_to @contract, notice: 'Contrato finalizado com sucesso.'
      else
        redirect_to @contract, alert: 'Erro ao finalizar o contrato.'
      end
    else
      redirect_to @contract, alert: 'Data de término inválida.'
    end
  end

  def load_property_data
    property = Property.find(params[:property_id])
    render json: {
      owner_id: property.owner_id,
      rent_value: property.rent_value
    }
  end

  def calculate_dates
    start_date = Date.parse(params[:start_date])
    period_key = params[:contract_period]
    months = case period_key
             when "six_months" then 6
             when "twelve_months" then 12
             when "twenty_four_months" then 24
             else 0
             end

    end_date = start_date.advance(months: months)

    render json: {
      end_date: end_date,
      first_payment_date: params[:signature_date],
      guarantee_payment_date: params[:signature_date],
      interest_rate: 2.00,
      fine_rate: 10.00,
      guarantee: "caução",
      guarantee_value: params[:rent_value]
    }
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(
      :property_id, :tenant_id, :owner_id, :rent_value,
      :status,
      :contract_period, :start_date, :end_date, :signature_date,
      :interest_rate, :fine_rate, :guarantee, :guarantee_value,
      :guarantee_payment_date, :guarantee_installments,
      :payment_method, :payment_day,
      :first_payment_date, :first_payment_value
    )
  end
end