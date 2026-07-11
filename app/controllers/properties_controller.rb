require "net/http"
require "json"

class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show edit update destroy]
  before_action :refresh_reserved_statuses, only: %i[index show reserved]

  def index
    @properties = Property.order(:id)
    @tenants = Person.where(person_type: :tenant, status: :available)
  end

  def reserved
    @properties = Property.where(status: :reserved).order(:id)
  end

  def show
    @tenants = Person.where(person_type: :tenant, status: :available)
  end

  def new
    @property = Property.new
  end

  def edit
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      redirect_to @property, notice: "Imóvel criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: "Imóvel atualizado com sucesso."
    else
      Rails.logger.debug ">>> Erros ao atualizar imóvel: #{@property.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_url, notice: "Imóvel excluído com sucesso."
  end

  def address_lookup
    cep = params[:cep].to_s.gsub(/\D/, "")
    url = URI("https://viacep.com.br/ws/#{cep}/json/")

    response = Net::HTTP.get_response(url)
    data = JSON.parse(response.body)

    if data["erro"]
      render json: { error: "CEP não encontrado" }, status: :not_found
    else
      render json: {
        street: data["logradouro"],
        neighborhood: data["bairro"],
        city: data["localidade"],
        state: data["uf"]
      }
    end
  end

  def generate_reference
    type = params[:property_type]

    prefix = case type
             when "studio" then "K"
             when "house" then "C"
             when "warehouse" then "B"
             else "X"
             end

    count = Property.where(property_type: type).count + 1
    formatted = "#{prefix}#{format('%04d', count)}"

    Rails.logger.debug ">>> generate_reference: type=#{type}, reference=#{formatted}"
    render json: { reference: formatted }
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def refresh_reserved_statuses
    Property.refresh_reservation_statuses!
  end

  def property_params
    params.require(:property).permit(
      :reference, :zip_code, :street, :neighborhood, :number,
      :city, :state, :complement, :rent_value,
      :property_type, :category, :status, :owner_id
    )
  end
end
