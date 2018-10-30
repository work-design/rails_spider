require 'test_helper'

class SpiderWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spider_work = spider_works(:one)
  end

  test "should get index" do
    get spider_works_url
    assert_response :success
  end

  test "should get new" do
    get new_spider_work_url
    assert_response :success
  end

  test "should create spider_work" do
    assert_difference('SpiderWork.count') do
      post spider_works_url, params: { spider_work: { host: @spider_work.host, item_path: @spider_work.item_path, list_path: @spider_work.list_path, name: @spider_work.name, page_params: @spider_work.page_params } }
    end

    assert_redirected_to spider_work_url(SpiderWork.last)
  end

  test "should show spider_work" do
    get spider_work_url(@spider_work)
    assert_response :success
  end

  test "should get edit" do
    get edit_spider_work_url(@spider_work)
    assert_response :success
  end

  test "should update spider_work" do
    patch spider_work_url(@spider_work), params: { spider_work: { host: @spider_work.host, item_path: @spider_work.item_path, list_path: @spider_work.list_path, name: @spider_work.name, page_params: @spider_work.page_params } }
    assert_redirected_to spider_work_url(@spider_work)
  end

  test "should destroy spider_work" do
    assert_difference('SpiderWork.count', -1) do
      delete spider_work_url(@spider_work)
    end

    assert_redirected_to spider_works_url
  end
end
