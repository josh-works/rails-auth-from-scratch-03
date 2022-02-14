require 'csv'
class StravaRunsController < ApplicationController
  def index
    @runs = get_run_data
    
  end
  
  private
  
  def get_run_data
    data = CSV.open('runs.csv').read
    data.to_json
  end
end
