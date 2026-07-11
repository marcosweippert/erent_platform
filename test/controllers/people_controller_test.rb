require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should get new" do
    get new_person_url
    assert_response :success
  end

  test "should create person" do
    assert_difference("Person.count") do
      post people_url, params: { person: { city: @person.city, complement: @person.complement, cpf: @person.cpf, email: @person.email, marital_status: @person.marital_status, name: @person.name, nationality: @person.nationality, neighborhood: @person.neighborhood, number: @person.number, observations: @person.observations, person_type: @person.person_type, phone: @person.phone, rg: @person.rg, state: @person.state, status: @person.status, street: @person.street, zip_code: @person.zip_code } }
    end

    assert_redirected_to person_url(Person.last)
  end

  test "should show person" do
    get person_url(@person)
    assert_response :success
  end

  test "should get edit" do
    get edit_person_url(@person)
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: { city: @person.city, complement: @person.complement, cpf: @person.cpf, email: @person.email, marital_status: @person.marital_status, name: @person.name, nationality: @person.nationality, neighborhood: @person.neighborhood, number: @person.number, observations: @person.observations, person_type: @person.person_type, phone: @person.phone, rg: @person.rg, state: @person.state, status: @person.status, street: @person.street, zip_code: @person.zip_code } }
    assert_redirected_to person_url(@person)
  end

  test "should destroy person" do
    assert_difference("Person.count", -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end
end
