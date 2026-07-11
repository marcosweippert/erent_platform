require "test_helper"

class ContractAmendmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contract_amendment = contract_amendments(:one)
  end

  test "should get index" do
    get contract_amendments_url
    assert_response :success
  end

  test "should get new" do
    get new_contract_amendment_url
    assert_response :success
  end

  test "should create contract_amendment" do
    assert_difference("ContractAmendment.count") do
      post contract_amendments_url, params: { contract_amendment: { amendment_contract_period: @contract_amendment.amendment_contract_period, amendment_end_date: @contract_amendment.amendment_end_date, amendment_rent_value: @contract_amendment.amendment_rent_value, amendment_start_date: @contract_amendment.amendment_start_date, contract_id: @contract_amendment.contract_id } }
    end

    assert_redirected_to contract_amendment_url(ContractAmendment.last)
  end

  test "should show contract_amendment" do
    get contract_amendment_url(@contract_amendment)
    assert_response :success
  end

  test "should get edit" do
    get edit_contract_amendment_url(@contract_amendment)
    assert_response :success
  end

  test "should update contract_amendment" do
    patch contract_amendment_url(@contract_amendment), params: { contract_amendment: { amendment_contract_period: @contract_amendment.amendment_contract_period, amendment_end_date: @contract_amendment.amendment_end_date, amendment_rent_value: @contract_amendment.amendment_rent_value, amendment_start_date: @contract_amendment.amendment_start_date, contract_id: @contract_amendment.contract_id } }
    assert_redirected_to contract_amendment_url(@contract_amendment)
  end

  test "should destroy contract_amendment" do
    assert_difference("ContractAmendment.count", -1) do
      delete contract_amendment_url(@contract_amendment)
    end

    assert_redirected_to contract_amendments_url
  end
end
