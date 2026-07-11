require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  setup do
    @person = people(:one)
  end

  test "visiting the index" do
    visit people_url
    assert_selector "h1", text: "People"
  end

  test "should create person" do
    visit people_url
    click_on "New person"

    fill_in "City", with: @person.city
    fill_in "Complement", with: @person.complement
    fill_in "Cpf", with: @person.cpf
    fill_in "Email", with: @person.email
    fill_in "Marital status", with: @person.marital_status
    fill_in "Name", with: @person.name
    fill_in "Nationality", with: @person.nationality
    fill_in "Neighborhood", with: @person.neighborhood
    fill_in "Number", with: @person.number
    fill_in "Observations", with: @person.observations
    fill_in "Person type", with: @person.person_type
    fill_in "Phone", with: @person.phone
    fill_in "Rg", with: @person.rg
    fill_in "State", with: @person.state
    fill_in "Status", with: @person.status
    fill_in "Street", with: @person.street
    fill_in "Zip code", with: @person.zip_code
    click_on "Create Person"

    assert_text "Person was successfully created"
    click_on "Back"
  end

  test "should update Person" do
    visit person_url(@person)
    click_on "Edit this person", match: :first

    fill_in "City", with: @person.city
    fill_in "Complement", with: @person.complement
    fill_in "Cpf", with: @person.cpf
    fill_in "Email", with: @person.email
    fill_in "Marital status", with: @person.marital_status
    fill_in "Name", with: @person.name
    fill_in "Nationality", with: @person.nationality
    fill_in "Neighborhood", with: @person.neighborhood
    fill_in "Number", with: @person.number
    fill_in "Observations", with: @person.observations
    fill_in "Person type", with: @person.person_type
    fill_in "Phone", with: @person.phone
    fill_in "Rg", with: @person.rg
    fill_in "State", with: @person.state
    fill_in "Status", with: @person.status
    fill_in "Street", with: @person.street
    fill_in "Zip code", with: @person.zip_code
    click_on "Update Person"

    assert_text "Person was successfully updated"
    click_on "Back"
  end

  test "should destroy Person" do
    visit person_url(@person)
    click_on "Destroy this person", match: :first

    assert_text "Person was successfully destroyed"
  end
end
