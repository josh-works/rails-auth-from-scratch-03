require 'csv'

class StravaRunsController < ApplicationController
  def index
    @polylines = all_polylines
  end
  
  private
  
  def all_polylines
    @all_polylines ||= get_run_data
    
  end
  
  def get_run_data
    p "getting data"
    rows = CSV.open('runs.csv', "r", headers: true, header_converters: :symbol) 
    rows.map do |row|
      p row 
      StravaRun.new(row[:id], row[:polyline])
    end
    
  end
  

  
end
