require "application_system_test_case"

class SpiderResourcesTest < ApplicationSystemTestCase
  setup do
    @admin_spider_resource = admin_spider_resources(:one)
  end

  test "visiting the index" do
    visit admin_spider_resources_url
    assert_selector "h1", text: "Spider Resources"
  end

  test "creating a Spider resource" do
    visit admin_spider_resources_url
    click_on "New Spider Resource"

    fill_in "Code", with: @admin_spider_resource.code
    fill_in "Css", with: @admin_spider_resource.css
    fill_in "Squish", with: @admin_spider_resource.squish
    fill_in "Xpath", with: @admin_spider_resource.xpath
    click_on "Create Spider resource"

    assert_text "Spider resource was successfully created"
    click_on "Back"
  end

  test "updating a Spider resource" do
    visit admin_spider_resources_url
    click_on "Edit", match: :first

    fill_in "Code", with: @admin_spider_resource.code
    fill_in "Css", with: @admin_spider_resource.css
    fill_in "Squish", with: @admin_spider_resource.squish
    fill_in "Xpath", with: @admin_spider_resource.xpath
    click_on "Update Spider resource"

    assert_text "Spider resource was successfully updated"
    click_on "Back"
  end

  test "destroying a Spider resource" do
    visit admin_spider_resources_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Spider resource was successfully destroyed"
  end
end
