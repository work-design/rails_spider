require 'test_helper'

class Admin::SpiderResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_spider_resource = admin_spider_resources(:one)
  end

  test "should get index" do
    get admin_spider_resources_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_spider_resource_url
    assert_response :success
  end

  test "should create admin_spider_resource" do
    assert_difference('SpiderResource.count') do
      post admin_spider_resources_url, params: { admin_spider_resource: { code: @admin_spider_resource.code, css: @admin_spider_resource.css, squish: @admin_spider_resource.squish, xpath: @admin_spider_resource.xpath } }
    end

    assert_redirected_to admin_spider_resource_url(SpiderResource.last)
  end

  test "should show admin_spider_resource" do
    get admin_spider_resource_url(@admin_spider_resource)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_spider_resource_url(@admin_spider_resource)
    assert_response :success
  end

  test "should update admin_spider_resource" do
    patch admin_spider_resource_url(@admin_spider_resource), params: { admin_spider_resource: { code: @admin_spider_resource.code, css: @admin_spider_resource.css, squish: @admin_spider_resource.squish, xpath: @admin_spider_resource.xpath } }
    assert_redirected_to admin_spider_resource_url(@admin_spider_resource)
  end

  test "should destroy admin_spider_resource" do
    assert_difference('SpiderResource.count', -1) do
      delete admin_spider_resource_url(@admin_spider_resource)
    end

    assert_redirected_to admin_spider_resources_url
  end
end
