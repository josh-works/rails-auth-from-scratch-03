require 'csv'
class StravaRunsController < ApplicationController
  def index
    @runs = get_run_data
  end
  
  private
  
  def get_run_data
    # data = CSV.open('runs.csv', symbolize).read
    # data.to_json
    
    poly = "".to_json
    
    [poly]
  end
end
