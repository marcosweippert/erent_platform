# This file should ensure the existence of records required to run the application in every environment.
# The seed data is intentionally idempotent so it can be re-run safely.

puts "Seeding core data for the rental management system..."


def create_or_update_person(attrs, person_type, status)
  person = Person.find_or_initialize_by(cpf: attrs[:cpf])
  person.assign_attributes(attrs.merge(person_type: person_type, status: status))
  person.save!
  person
end


def create_or_update_property(attrs, owner)
  property = Property.find_or_initialize_by(reference: attrs[:reference])
  property.assign_attributes(attrs.merge(owner: owner))
  property.save!
  property
end


def create_or_update_contract(attrs)
  contract = Contract.find_or_initialize_by(
    property: attrs[:property],
    tenant: attrs[:tenant],
    owner: attrs[:owner],
    start_date: attrs[:start_date],
    end_date: attrs[:end_date]
  )
  contract.assign_attributes(attrs.except(:property, :tenant, :owner, :start_date, :end_date))
  contract.save!
  contract
end


def create_or_update_amendment(attrs)
  amendment = ContractAmendment.find_or_initialize_by(
    contract: attrs[:contract],
    amendment_start_date: attrs[:amendment_start_date],
    amendment_end_date: attrs[:amendment_end_date]
  )
  amendment.assign_attributes(attrs.except(:contract, :amendment_start_date, :amendment_end_date))
  amendment.save!
  amendment
end

puts "Creating tenants..."
tenants = [
  {
    name: "Jorge Cláudio Bernardo Assunção",
    cpf: "251.772.984-00",
    rg: "18.297.848-5",
    email: "jorgeclaudioassuncao@advogadostb.com.br",
    zip_code: "85900-000",
    street: "Rua A",
    number: "100",
    neighborhood: "Centro",
    city: "Toledo",
    state: "PR",
    phone: "(41) 99999-0001",
    complement: "Ap 101",
    marital_status: "Solteiro",
    nationality: "Brasileira",
    observations: "Signo: Touro, Tipo sanguíneo: O+"
  },
  {
    name: "Filipe Filipe Teixeira",
    cpf: "519.450.433-00",
    rg: "38.502.154-9",
    email: "filipe-teixeira83@academiagolf.com.br",
    zip_code: "85900-001",
    street: "Rua B",
    number: "101",
    neighborhood: "Centro",
    city: "Toledo",
    state: "PR",
    phone: "(41) 99999-0002",
    complement: "Ap 102",
    marital_status: "Casado",
    nationality: "Brasileira",
    observations: "Signo: Leão, Tipo sanguíneo: A+"
  },
  {
    name: "Vinicius Matheus Mateus Carvalho",
    cpf: "953.127.137-24",
    rg: "39.409.374-4",
    email: "vinicius.matheus.carvalho@asconinternet.com.br",
    zip_code: "85900-002",
    street: "Rua C",
    number: "102",
    neighborhood: "Centro",
    city: "Toledo",
    state: "PR",
    phone: "(41) 99999-0003",
    complement: "Ap 103",
    marital_status: "Solteiro",
    nationality: "Brasileira",
    observations: "Signo: Peixes, Tipo sanguíneo: B+"
  },
  {
    name: "Luís Enrico da Silva",
    cpf: "968.110.962-76",
    rg: "45.984.364-3",
    email: "luis_enrico_dasilva@caesarbusiness.com.br",
    zip_code: "85900-003",
    street: "Rua D",
    number: "103",
    neighborhood: "Centro",
    city: "Toledo",
    state: "PR",
    phone: "(41) 99999-0004",
    complement: "Ap 104",
    marital_status: "Divorciado",
    nationality: "Brasileira",
    observations: "Signo: Gêmeos, Tipo sanguíneo: AB-"
  },
  {
    name: "Elias Enzo Theo da Conceição",
    cpf: "841.690.696-33",
    rg: "37.951.683-4",
    email: "elias_enzo_daconceicao@unilever.com",
    zip_code: "85900-004",
    street: "Rua E",
    number: "104",
    neighborhood: "Centro",
    city: "Toledo",
    state: "PR",
    phone: "(41) 99999-0005",
    complement: "Ap 105",
    marital_status: "Casado",
    nationality: "Brasileira",
    observations: "Signo: Libra, Tipo sanguíneo: O-"
  }
]

created_tenants = tenants.map { |attrs| create_or_update_person(attrs, :tenant, :available) }
puts "Tenants created."

puts "Creating owners..."
owners_data = [
  {
    name: "Kevin Otávio Bernardo Castro",
    cpf: "332.778.978-93",
    rg: "20.169.926-6",
    email: "kevin-castro88@balaiofilmes.com.br",
    zip_code: "59080-085",
    street: "Travessa Nossa Senhora Aparecida",
    number: 746,
    neighborhood: "Capim Macio",
    city: "Natal",
    state: "RN",
    phone: "(84) 98868-7848",
    complement: "",
    marital_status: "Viúvo",
    nationality: "Brasileira",
    observations: "Signo: Áries, Tipo sanguíneo: AB-"
  },
  {
    name: "Vicente Henrique Noah Duarte",
    cpf: "973.200.473-81",
    rg: "44.528.157-1",
    email: "vicentehenriqueduarte@pobox.com",
    zip_code: "79010-071",
    street: "Travessa das Paineiras",
    number: 165,
    neighborhood: "Monte Castelo",
    city: "Campo Grande",
    state: "MS",
    phone: "(67) 98446-7035",
    complement: "",
    marital_status: "Divorciado",
    nationality: "Brasileira",
    observations: "Signo: Peixes, Tipo sanguíneo: B-"
  },
  {
    name: "Daniela Eloá Assunção",
    cpf: "920.585.109-41",
    rg: "34.811.631-7",
    email: "daniela_assuncao@valdulion.com.br",
    zip_code: "77015-585",
    street: "Quadra 403 Sul Alameda 23",
    number: 993,
    neighborhood: "Plano Diretor Sul",
    city: "Palmas",
    state: "TO",
    phone: "(63) 98750-7619",
    complement: "",
    marital_status: "Casada",
    nationality: "Brasileira",
    observations: "Signo: Áries, Tipo sanguíneo: B+"
  }
]

created_owners = owners_data.map { |attrs| create_or_update_person(attrs, :owner, :available) }
puts "Owners created."

puts "Creating properties..."
property_data = [
  {
    reference: "REF00001",
    street: "Rua G",
    number: 653,
    neighborhood: "Jóia",
    city: "Timon",
    state: "MA",
    zip_code: "65632-335",
    rent_value: 1200.0,
    property_type: :studio,
    category: :residential,
    status: :available
  },
  {
    reference: "REF00002",
    street: "Rua Plácido Affonso Rausis",
    number: 550,
    neighborhood: "Nova Brasília",
    city: "Joinville",
    state: "SC",
    zip_code: "89213-600",
    rent_value: 1800.0,
    property_type: :house,
    category: :residential,
    status: :rented
  },
  {
    reference: "REF00003",
    street: "Rua Areolino de Abreu 1349",
    number: 679,
    neighborhood: "Centro",
    city: "Teresina",
    state: "PI",
    zip_code: "64000-917",
    rent_value: 2200.0,
    property_type: :warehouse,
    category: :commercial,
    status: :reserved
  },
  {
    reference: "REF00004",
    street: "Rua Doutor Alfredo Nader",
    number: 129,
    neighborhood: "Prado",
    city: "Recife",
    state: "PE",
    zip_code: "50830-070",
    rent_value: 950.0,
    property_type: :studio,
    category: :residential,
    status: :available
  },
  {
    reference: "REF00005",
    street: "Rua Antares",
    number: 901,
    neighborhood: "Jardim Primavera",
    city: "Boa Vista",
    state: "RR",
    zip_code: "69314-196",
    rent_value: 1450.0,
    property_type: :house,
    category: :residential,
    status: :available
  },
  {
    reference: "REF00006",
    street: "Rua A",
    number: 1000,
    neighborhood: "Soledade",
    city: "Aracaju",
    state: "SE",
    zip_code: "49089-150",
    rent_value: 1700.0,
    property_type: :warehouse,
    category: :commercial,
    status: :available
  },
  {
    reference: "REF00007",
    street: "Avenida Vereador Adelício Gonzaga",
    number: 914,
    neighborhood: "Urbis II",
    city: "Teixeira de Freitas",
    state: "BA",
    zip_code: "45991-014",
    rent_value: 2100.0,
    property_type: :house,
    category: :residential,
    status: :available
  },
  {
    reference: "REF00008",
    street: "Praça Estéfano Turok",
    number: 263,
    neighborhood: "Santa Cruz",
    city: "Guarapuava",
    state: "PR",
    zip_code: "85015-580",
    rent_value: 1300.0,
    property_type: :studio,
    category: :residential,
    status: :available
  },
  {
    reference: "REF00009",
    street: "Rua Romualdo Marchis",
    number: 466,
    neighborhood: "Santo Inácio",
    city: "Esteio",
    state: "RS",
    zip_code: "93290-300",
    rent_value: 2400.0,
    property_type: :warehouse,
    category: :commercial,
    status: :available
  },
  {
    reference: "REF00010",
    street: "Ladeira do Marista",
    number: 630,
    neighborhood: "Poço",
    city: "Maceió",
    state: "AL",
    zip_code: "57025-678",
    rent_value: 1600.0,
    property_type: :house,
    category: :residential,
    status: :available
  }
]

created_properties = property_data.map.with_index do |attrs, index|
  create_or_update_property(attrs, created_owners[index % created_owners.length])
end
puts "Properties created."

puts "Creating contracts..."
active_contract = create_or_update_contract(
  property: created_properties[1],
  tenant: created_tenants[0],
  owner: created_owners[0],
  start_date: Date.new(2025, 1, 1),
  end_date: Date.new(2025, 12, 31),
  rent_value: 1800.0,
  contract_period: :twelve_months,
  signature_date: Date.new(2024, 12, 20),
  interest_rate: 1.0,
  fine_rate: 0.5,
  guarantee: "Fiador",
  guarantee_value: 1800.0,
  guarantee_payment_date: Date.new(2024, 12, 20),
  guarantee_installments: 1,
  payment_method: :pix,
  payment_day: :dia_10,
  first_payment_date: Date.new(2025, 1, 10),
  first_payment_value: 1800.0,
  status: :active
)

reserved_contract = create_or_update_contract(
  property: created_properties[2],
  tenant: created_tenants[1],
  owner: created_owners[1],
  start_date: Date.new(2026, 2, 1),
  end_date: Date.new(2026, 7, 31),
  rent_value: 2200.0,
  status: :reserved
)

finalized_contract = create_or_update_contract(
  property: created_properties[3],
  tenant: created_tenants[2],
  owner: created_owners[2],
  start_date: Date.new(2024, 3, 1),
  end_date: Date.new(2024, 8, 31),
  rent_value: 950.0,
  contract_period: :six_months,
  signature_date: Date.new(2024, 2, 15),
  interest_rate: 1.0,
  fine_rate: 0.5,
  guarantee: "Seguro fiança",
  guarantee_value: 950.0,
  guarantee_payment_date: Date.new(2024, 2, 15),
  guarantee_installments: 1,
  payment_method: :boleto,
  payment_day: :dia_5,
  first_payment_date: Date.new(2024, 3, 5),
  first_payment_value: 950.0,
  status: :finalized
)
puts "Contracts created."

puts "Creating contract amendments..."
create_or_update_amendment(
  contract: active_contract,
  amendment_start_date: Date.new(2025, 4, 1),
  amendment_end_date: Date.new(2025, 6, 30),
  amendment_rent_value: 1900.0,
  amendment_contract_period: "Ajuste de valor"
)

create_or_update_amendment(
  contract: finalized_contract,
  amendment_start_date: Date.new(2024, 6, 1),
  amendment_end_date: Date.new(2024, 7, 31),
  amendment_rent_value: 1000.0,
  amendment_contract_period: "Renegociação"
)
puts "Contract amendments created."

puts "Creating inspection records..."
inspection_defaults = {
  "portas_e_janelas" => { "label" => "Portas e janelas", "value" => true, "status" => "ok", "observation" => "Item em ordem" },
  "paredes_e_teto" => { "label" => "Paredes e teto", "value" => true, "status" => "ok", "observation" => nil },
  "pisos" => { "label" => "Pisos", "value" => true, "status" => "ok", "observation" => nil },
  "banheiro" => { "label" => "Banheiro", "value" => true, "status" => "ok", "observation" => nil },
  "cozinha" => { "label" => "Cozinha", "value" => true, "status" => "ok", "observation" => nil },
  "eletricidade" => { "label" => "Instalações elétricas", "value" => true, "status" => "ok", "observation" => nil },
  "hidraulica" => { "label" => "Instalações hidráulicas", "value" => true, "status" => "ok", "observation" => nil },
  "mobília" => { "label" => "Mobília e acessórios", "value" => true, "status" => "ok", "observation" => nil }
}

Inspection.find_or_initialize_by(contract: active_contract, inspection_type: :entry).tap do |inspection|
  inspection.assign_attributes(
    inspection_type: :entry,
    property: active_contract.property,
    inspection_date: active_contract.start_date,
    entry_type: :standard,
    status: :completed,
    observations: "Imóvel entregue em boas condições.",
    landlord_name: active_contract.owner.name,
    tenant_name: active_contract.tenant.name,
    landlord_document: active_contract.owner.cpf,
    tenant_document: active_contract.tenant.cpf,
    checklist: inspection_defaults
  )
  inspection.save!
end

Inspection.find_or_initialize_by(contract: finalized_contract, inspection_type: :exit).tap do |inspection|
  inspection.assign_attributes(
    inspection_type: :exit,
    property: finalized_contract.property,
    inspection_date: finalized_contract.end_date,
    entry_type: :with_defects,
    status: :completed,
    observations: "Vistoria de saída registrada com pequenos ajustes pendentes.",
    landlord_name: finalized_contract.owner.name,
    tenant_name: finalized_contract.tenant.name,
    landlord_document: finalized_contract.owner.cpf,
    tenant_document: finalized_contract.tenant.cpf,
    checklist: inspection_defaults.merge(
      "pisos" => inspection_defaults["pisos"].merge("status" => "defect", "observation" => "Piso arranhado em área de circulação")
    )
  )
  inspection.save!
end
puts "Inspection records created."

puts "Creating superadmin user..."
user = User.find_or_initialize_by(email: "marcos.weippert@gmail.com")
user.name = "Marcos Weippert"
user.password = "Senhas@810"
user.password_confirmation = "Senhas@810"
user.master = true
user.must_change_password = false
user.save!
puts "Superadmin user ready: marcos.weippert@gmail.com"

puts "Seed completed successfully."
