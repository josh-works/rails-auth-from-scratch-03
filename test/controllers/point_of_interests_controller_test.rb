require "test_helper"

class PointOfInterestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @point_of_interest = point_of_interests(:one)
  end

  test "should get index" do
    get point_of_interests_url
    assert_response :success
  end

  test "should get new" do
    get new_point_of_interest_url
    assert_response :success
  end

  test "should create point_of_interest" do
    assert_difference("PointOfInterest.count") do
      post point_of_interests_url, params: { point_of_interest: { description: @point_of_interest.description, latitude: @point_of_interest.latitude, longitude: @point_of_interest.longitude, name: @point_of_interest.name } }
    end

    assert_redirected_to point_of_interest_url(PointOfInterest.last)
  end

  test "should show point_of_interest" do
    get point_of_interest_url(@point_of_interest)
    assert_response :success
  end

  test "should get edit" do
    get edit_point_of_interest_url(@point_of_interest)
    assert_response :success
  end

  test "should update point_of_interest" do
    patch point_of_interest_url(@point_of_interest), params: { point_of_interest: { description: @point_of_interest.description, latitude: @point_of_interest.latitude, longitude: @point_of_interest.longitude, name: @point_of_interest.name } }
    assert_redirected_to point_of_interest_url(@point_of_interest)
  end

  test "should destroy point_of_interest" do
    assert_difference("PointOfInterest.count", -1) do
      delete point_of_interest_url(@point_of_interest)
    end

    assert_redirected_to point_of_interests_url
  end
end
