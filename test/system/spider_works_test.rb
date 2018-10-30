require "application_system_test_case"

class SpiderWorksTest < ApplicationSystemTestCase
  setup do
    @spider_work = spider_works(:one)
  end

  test "visiting the index" do
    visit spider_works_url
    assert_selector "h1", text: "Spider Works"
  end

  test "creating a Spider work" do
    visit spider_works_url
    click_on "New Spider Work"

    fill_in "Host", with: @spider_work.host
    fill_in "Item Path", with: @spider_work.item_path
    fill_in "List Path", with: @spider_work.list_path
    fill_in "Name", with: @spider_work.name
    fill_in "Page Params", with: @spider_work.page_params
    click_on "Create Spider work"

    assert_text "Spider work was successfully created"
    click_on "Back"
  end

  test "updating a Spider work" do
    visit spider_works_url
    click_on "Edit", match: :first

    fill_in "Host", with: @spider_work.host
    fill_in "Item Path", with: @spider_work.item_path
    fill_in "List Path", with: @spider_work.list_path
    fill_in "Name", with: @spider_work.name
    fill_in "Page Params", with: @spider_work.page_params
    click_on "Update Spider work"

    assert_text "Spider work was successfully updated"
    click_on "Back"
  end

  test "destroying a Spider work" do
    visit spider_works_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Spider work was successfully destroyed"
  end
end
