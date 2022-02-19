require "application_system_test_case"

class PointOfInterestsTest < ApplicationSystemTestCase
  setup do
    @point_of_interest = point_of_interests(:one)
  end

  test "visiting the index" do
    visit point_of_interests_url
    assert_selector "h1", text: "Point of interests"
  end

  test "should create point of interest" do
    visit point_of_interests_url
    click_on "New point of interest"

    fill_in "Description", with: @point_of_interest.description
    fill_in "Latitude", with: @point_of_interest.latitude
    fill_in "Longitude", with: @point_of_interest.longitude
    fill_in "Name", with: @point_of_interest.name
    click_on "Create Point of interest"

    assert_text "Point of interest was successfully created"
    click_on "Back"
  end

  test "should update Point of interest" do
    visit point_of_interest_url(@point_of_interest)
    click_on "Edit this point of interest", match: :first

    fill_in "Description", with: @point_of_interest.description
    fill_in "Latitude", with: @point_of_interest.latitude
    fill_in "Longitude", with: @point_of_interest.longitude
    fill_in "Name", with: @point_of_interest.name
    click_on "Update Point of interest"

    assert_text "Point of interest was successfully updated"
    click_on "Back"
  end

  test "should destroy Point of interest" do
    visit point_of_interest_url(@point_of_interest)
    click_on "Destroy this point of interest", match: :first

    assert_text "Point of interest was successfully destroyed"
  end
end
