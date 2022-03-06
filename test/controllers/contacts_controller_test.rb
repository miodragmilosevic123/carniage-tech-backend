require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  fixtures :contacts

  test 'Create Must work' do
    params = {
      name: 'second_contact',
      number: '12345678910'
    }

    first_user = users(:first_user)
    token = JsonWebToken.encode(id: first_user.id)

    post api_user_contacts_path(user_id: first_user.id), params: params, headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_equal 'second_contact', response['name']
    assert_equal '12345678910', response['number']
  end

  test 'Index Must work' do
    first_user = users(:first_user)
    token = JsonWebToken.encode(id: first_user.id)

    get api_user_contacts_path(user_id: first_user.id), headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_equal 1, response['contacts'].length
    assert_equal 'first_contact', response['contacts'][0]['name']
    assert_equal '123456789', response['contacts'][0]['number']
  end

  test 'Show Must work' do
    first_user = users(:first_user)
    first_contact = contacts(:first_contact)
    token = JsonWebToken.encode(id: first_user.id)

    get api_user_contact_path(user_id: first_user.id, id: first_contact.id), headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_equal 'first_contact', response['name']
    assert_equal '123456789', response['number']
  end

  test 'Update Must work' do
    first_user = users(:first_user)
    first_contact = contacts(:first_contact)
    token = JsonWebToken.encode(id: first_user.id)

    put api_user_contact_path(user_id: first_user.id, id: first_contact.id), params: { name: 'second_contact', number: '12345678910'}, headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_equal 'second_contact', response['name']
    assert_equal '12345678910', response['number']
  end

  test 'Destroy must work' do
    first_user = users(:first_user)
    first_contact = contacts(:first_contact)
    token = JsonWebToken.encode(id: first_user.id)

    delete api_user_contact_path(user_id: first_user.id, id: first_contact.id), headers: { "Authorization": token }, as: :json
    assert_response :success
  end
end