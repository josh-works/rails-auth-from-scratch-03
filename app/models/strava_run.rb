class StravaRun
  include HTTParty
  base_uri 'https://www.strava.com/api/v3'
  attr_reader :id, :polyline
  def initialize(data)
    @id = data[:id]
    @polyline = data[:polyline]
  end
  
  def self.download_activites
    page = 1
    token = "2c430a49f1616ffef177887d1111c425f0a26774"
    headers = {'Authorization': "Bearer #{token}"}
    r = HTTParty.get("https://www.strava.com/api/v3/athlete/activities?page={#{page}}", headers = headers)
    
    response = JSON.parse(r)
    if response.length == 0
      return
    else
      response.each do |r|
        p r
        r = requests.get("https://www.strava.com/api/v3/activities/{0}?include_all_efforts=true".format(activity["id"]), headers = headers)
        polyline = r.json()["map"]["polyline"]
        writer.writerow([activity["id"], polyline])
        
      end
    end
    # File.open('runs.csv', "w") do |f|
    #   f.write ["id", "polyline"]
    # end
  end
end


# with open("runs.csv", "w") as runs_file:
#     writer = csv.writer(runs_file, delimiter=",")
#     writer.writerow()
# 
#     page = 1
#     while True:
#         r = requests.get("https://www.strava.com/api/v3/athlete/activities?page={0}".format(page), headers = headers)
#         response = r.json()
# 
#         if len(response) == 0:
#             break
#         else:
#             for activity in response:
#                 print(response)
#                 r = requests.get("https://www.strava.com/api/v3/activities/{0}?include_all_efforts=true".format(activity["id"]), headers = headers)
#                 polyline = r.json()["map"]["polyline"]
#                 writer.writerow([activity["id"], polyline])
            # page += 1