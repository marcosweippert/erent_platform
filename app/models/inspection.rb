class Inspection < ApplicationRecord
  belongs_to :contract
  belongs_to :property

  enum inspection_type: { entry: 0, exit: 1 }
  enum entry_type: { standard: 0, with_defects: 1, with_photos: 2 }
  enum status: { draft: 0, signed: 1, completed: 2, with_reservations: 3, cancelled: 4 }

  validates :contract, :property, presence: true
  validates :inspection_type, :inspection_date, :entry_type, :status, presence: true
  validates :landlord_name, :tenant_name, :landlord_document, :tenant_document, presence: true, if: :signed?

  serialize :checklist, coder: YAML

  def checklist=(value)
    super(normalize_checklist(value))
  end

  def checklist_items
    checklist.to_h.presence || default_checklist
  end

  def selected_checklist_items
    checklist_items.select { |_, item| ActiveModel::Type::Boolean.new.cast(item["value"]) }
  end

  def self.status_for_action(action)
    case action
    when "completed"
      :completed
    when "with_reservations"
      :with_reservations
    when "cancelled"
      :cancelled
    else
      :draft
    end
  end

  def default_checklist
    {
      "portas_e_janelas" => { "label" => "Portas e janelas", "value" => false, "status" => "ok", "observation" => nil },
      "paredes_e_teto" => { "label" => "Paredes e teto", "value" => false, "status" => "ok", "observation" => nil },
      "pisos" => { "label" => "Pisos", "value" => false, "status" => "ok", "observation" => nil },
      "banheiro" => { "label" => "Banheiro", "value" => false, "status" => "ok", "observation" => nil },
      "cozinha" => { "label" => "Cozinha", "value" => false, "status" => "ok", "observation" => nil },
      "eletricidade" => { "label" => "Instalações elétricas", "value" => false, "status" => "ok", "observation" => nil },
      "hidraulica" => { "label" => "Instalações hidráulicas", "value" => false, "status" => "ok", "observation" => nil },
      "mobília" => { "label" => "Mobília e acessórios", "value" => false, "status" => "ok", "observation" => nil }
    }
  end

  before_validation :set_default_status

  private

  def normalize_checklist(value)
    case value
    when nil
      {}
    when Hash
      value.each_with_object({}) do |(key, child), memo|
        memo[key.to_s] = normalize_checklist(child)
      end
    when Array
      value.map { |child| normalize_checklist(child) }
    else
      value
    end
  end

  def set_default_status
    self.status ||= "draft"
  end
end
