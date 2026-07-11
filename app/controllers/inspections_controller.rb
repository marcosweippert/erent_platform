class InspectionsController < ApplicationController
  before_action :set_contract
  before_action :set_inspection, only: %i[show]

  def new
    @inspection = @contract.inspections.build(
      property: @contract.property,
      inspection_date: Date.current,
      inspection_type: :entry,
      entry_type: :standard,
      status: :draft,
      landlord_name: @contract.owner.name,
      tenant_name: @contract.tenant.name,
      landlord_document: @contract.owner.cpf,
      tenant_document: @contract.tenant.cpf,
      checklist: {}
    )
  end

  def create
    permitted_params = inspection_params

    action = params[:commit]&.downcase
    status = Inspection.status_for_action(action)

    inspection_attributes = permitted_params.to_h.except(:checklist).merge(
      property: @contract.property,
      status: status,
      checklist: build_checklist(permitted_params[:checklist]),
      landlord_name: permitted_params[:landlord_name].presence || @contract.owner.name,
      tenant_name: permitted_params[:tenant_name].presence || @contract.tenant.name,
      landlord_document: permitted_params[:landlord_document].presence || @contract.owner.cpf,
      tenant_document: permitted_params[:tenant_document].presence || @contract.tenant.cpf
    )

    @inspection = @contract.inspections.build(inspection_attributes)

    if @inspection.save
      redirect_to [@contract, @inspection], notice: "Vistoria registrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def pdf
    @inspection = @contract.inspections.find(params[:id])

    respond_to do |format|
      format.pdf do
        render pdf: "inspection_#{@inspection.id}",
               template: "inspections/pdf",
               formats: [:html],
               layout: "pdf",
               show_as_html: params[:debug].present?
      end
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:contract_id])
  end

  def set_inspection
    @inspection = @contract.inspections.find(params[:id])
  end

  def inspection_params
    params.require(:inspection).permit(
      :inspection_type,
      :inspection_date,
      :entry_type,
      :status,
      :observations,
      :landlord_name,
      :tenant_name,
      :landlord_document,
      :tenant_document,
      :landlord_signature_date,
      :tenant_signature_date,
      :inspector_name,
      checklist: {}
    )
  end

  def build_checklist(raw_checklist)
    return {} if raw_checklist.blank?

    checklist_hash = if raw_checklist.is_a?(ActionController::Parameters)
                       raw_checklist.to_unsafe_h
                     elsif raw_checklist.respond_to?(:to_h)
                       raw_checklist.to_h
                     else
                       raw_checklist
                     end

    checklist_hash.each_with_object({}) do |(key, values), memo|
      normalized_values = if values.is_a?(ActionController::Parameters)
                            values.to_unsafe_h
                          elsif values.respond_to?(:to_h)
                            values.to_h
                          else
                            values
                          end

      memo[key.to_s] = {
        "label" => normalized_values["label"].presence || key.to_s.humanize,
        "value" => ActiveModel::Type::Boolean.new.cast(normalized_values["value"]),
        "status" => normalized_values["status"].presence || "ok",
        "observation" => normalized_values["observation"].presence
      }
    end
  end
end
