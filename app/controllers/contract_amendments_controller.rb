class ContractAmendmentsController < ApplicationController
  before_action :set_contract_amendment, only: %i[ show edit update destroy ]

  # GET /contract_amendments or /contract_amendments.json
  def index
    @contract_amendments = ContractAmendment.all
  end

  # GET /contract_amendments/1 or /contract_amendments/1.json
  def show
  end

  # GET /contract_amendments/new
  def new
    @contract_amendment = ContractAmendment.new
  end

  # GET /contract_amendments/1/edit
  def edit
  end

  # POST /contract_amendments or /contract_amendments.json
  def create
    @contract_amendment = ContractAmendment.new(contract_amendment_params)

    respond_to do |format|
      if @contract_amendment.save
        format.html { redirect_to @contract_amendment, notice: "Contract amendment was successfully created." }
        format.json { render :show, status: :created, location: @contract_amendment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract_amendment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contract_amendments/1 or /contract_amendments/1.json
  def update
    respond_to do |format|
      if @contract_amendment.update(contract_amendment_params)
        format.html { redirect_to @contract_amendment, notice: "Contract amendment was successfully updated." }
        format.json { render :show, status: :ok, location: @contract_amendment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contract_amendment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contract_amendments/1 or /contract_amendments/1.json
  def destroy
    @contract_amendment.destroy!

    respond_to do |format|
      format.html { redirect_to contract_amendments_path, status: :see_other, notice: "Contract amendment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract_amendment
      @contract_amendment = ContractAmendment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contract_amendment_params
      params.require(:contract_amendment).permit(:contract_id, :amendment_start_date, :amendment_end_date, :amendment_rent_value, :amendment_contract_period)
    end
end
