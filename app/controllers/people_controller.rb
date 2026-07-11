  require "net/http"
  require "uri"
  require "json"
  
class PeopleController < ApplicationController

  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.order(:id)
  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_path, status: :see_other, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /people/address_lookup?cep=00000000
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

  def upload_files
    @person = Person.find(params[:id])
    if params[:person][:documents]
      @person.documents.attach(params[:person][:documents])
      flash[:notice] = "Arquivos enviados com sucesso."
    end
    redirect_to @person
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :cpf, :rg, :marital_status, :nationality, :phone, :email, :zip_code, :street, :number, :neighborhood, :city, :state, :complement, :status, :person_type, :observations, documents: [])
    end
end
