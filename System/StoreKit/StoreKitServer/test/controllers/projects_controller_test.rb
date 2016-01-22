require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_url, params: { project: { downloadable: @project.downloadable, localized_description: @project.localized_description, localized_title: @project.localized_title, price: @project.price, price_locale: @project.price_locale, product_identifier: @project.product_identifier } }
    end

    assert_response 201
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { downloadable: @project.downloadable, localized_description: @project.localized_description, localized_title: @project.localized_title, price: @project.price, price_locale: @project.price_locale, product_identifier: @project.product_identifier } }
    assert_response 200
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_response 204
  end
end
