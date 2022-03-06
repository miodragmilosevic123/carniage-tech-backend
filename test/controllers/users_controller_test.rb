require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'Create Must work' do
    params = {
      username: 'Pera',
      email: 'pera@pera.com',
      password_digest: '1234567'
    }

    post api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_not_nil response['id']
    assert_equal 'Pera', response['username']
    assert_equal 'pera@pera.com', response['email']
    assert_not_nil response['token']
  end

  test 'Create Return 422 when param email missing' do
    params = {
      username: 'Pera',
      password_digest: '1234567'
    }

    post api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unprocessable_entity', response['status']
    assert_equal 422, response['error']
    assert_equal "Validation failed: Email can't be blank, Email is invalid", response['message']
  end

  test 'Create Return 422 when param password missing' do
    params = {
      username: 'Pera',
      email: 'pera@pera.com'
    }

    post api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unprocessable_entity', response['status']
    assert_equal 422, response['error']
    assert_equal "Password can't be blank", response['message']
  end

  test 'Create Return 422 when param password is less then 6 characters' do
    params = {
      username: 'Pera',
      email: 'pera@pera.com',
      password_digest: '1234'
    }

    post api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unprocessable_entity', response['status']
    assert_equal 422, response['error']
    assert_equal "Password need to have more than 6 characters", response['message']
  end

  test 'Create Return 422 when param username missing' do
    params = {
      email: 'pera@pera.com',
      password_digest: '1234567'
    }

    post api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unprocessable_entity', response['status']
    assert_equal 422, response['error']
    assert_equal "Validation failed: Username can't be blank", response['message']
  end

  test 'Login Must Work' do
    first_user = users(:first_user)
    params = {
      username: first_user.username,
      password_digest: '1234567'
    }

    post login_api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_not_nil response['id']
    assert_equal 'User', response['username']
    assert_equal 'user@user.com', response['email']
    assert_not_nil response['token']
  end

  test 'Login Return 401 When Credentials are invalid' do
    params = {
      username: 'User',
      password_digest: '123456789'
    }

    post login_api_users_path, params: params, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unauthorized', response['status']
    assert_equal 401, response['error']
    assert_equal "Invalid username or password", response['message']
  end

  test 'Show must work' do
    first_user = users(:first_user)
    token = JsonWebToken.encode(id: first_user.id)

    get api_user_path(id: first_user.id), headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_response :success
    assert_not_nil response['id']
    assert_equal 'User', response['username']
    assert_equal 'user@user.com', response['email']
    assert_equal 1, response['contacts'].length
    assert_equal 'first_contact', response['contacts'][0]['name']
    assert_equal '123456789', response['contacts'][0]['number']
  end

  test 'Try to Authorize User Not Exist' do
    token = JsonWebToken.encode(id: 12)

    get api_user_path(id: 12), headers: { "Authorization": token }, as: :json
    response = ::JSON.parse(body)
    assert_equal 'unauthorized', response['status']
    assert_equal 401, response['error']
    assert_equal "User don't exist", response['message']
  end
end