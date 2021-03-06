require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  setup do
    @organization = organizations(:social_security)

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create organization' do
    assert_difference ['Organization.count', 'Department.count'] do
      post :create, organization: {
        name: 'New organization',
        departments_attributes: [name: 'New Department']
      }
    end

    assert_redirected_to organization_url(assigns(:organization))
  end

  test 'should show organization' do
    get :show, id: @organization
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @organization
    assert_response :success
  end

  test 'should update organization' do
    patch :update, id: @organization, organization: { name: 'Updated value' }
    assert_redirected_to organization_url(assigns(:organization))
  end

  test 'should destroy organization' do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization
    end

    assert_redirected_to organizations_path
  end
end
