require "application_system_test_case"

class ContractAmendmentsTest < ApplicationSystemTestCase
  setup do
    @contract_amendment = contract_amendments(:one)
  end

  test "visiting the index" do
    visit contract_amendments_url
    assert_selector "h1", text: "Contract amendments"
  end

  test "should create contract amendment" do
    visit contract_amendments_url
    click_on "New contract amendment"

    fill_in "Amendment contract period", with: @contract_amendment.amendment_contract_period
    fill_in "Amendment end date", with: @contract_amendment.amendment_end_date
    fill_in "Amendment rent value", with: @contract_amendment.amendment_rent_value
    fill_in "Amendment start date", with: @contract_amendment.amendment_start_date
    fill_in "Contract", with: @contract_amendment.contract_id
    click_on "Create Contract amendment"

    assert_text "Contract amendment was successfully created"
    click_on "Back"
  end

  test "should update Contract amendment" do
    visit contract_amendment_url(@contract_amendment)
    click_on "Edit this contract amendment", match: :first

    fill_in "Amendment contract period", with: @contract_amendment.amendment_contract_period
    fill_in "Amendment end date", with: @contract_amendment.amendment_end_date
    fill_in "Amendment rent value", with: @contract_amendment.amendment_rent_value
    fill_in "Amendment start date", with: @contract_amendment.amendment_start_date
    fill_in "Contract", with: @contract_amendment.contract_id
    click_on "Update Contract amendment"

    assert_text "Contract amendment was successfully updated"
    click_on "Back"
  end

  test "should destroy Contract amendment" do
    visit contract_amendment_url(@contract_amendment)
    accept_confirm { click_on "Destroy this contract amendment", match: :first }

    assert_text "Contract amendment was successfully destroyed"
  end
end
