require "test_helper"

class StravaRunsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get strava_runs_index_url
    assert_response :success
  end
end
