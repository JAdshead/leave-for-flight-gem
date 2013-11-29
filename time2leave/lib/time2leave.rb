require "time2leave/version"
require "mechanize"
require "open-uri"

module Time2leave

  def self.scrape_flight(flight_num)
    agent = Mechanize.new
    page = agent.get("https://flightaware.com/")
    form = page.form("track")
    form.ident = flight_num.to_s
    result_page = agent.submit(form, form.buttons.first)

    # scrape for departure details
    dep_airport = (agent.get(result_page).search(".track-panel-departure .hint")).children.to_s
    dep_time = (((agent.get(result_page).search(".track-panel-actualtime:nth-child(1) .nolink")).children.to_s).scan /\d{2}:\d{2}\D{2}.?\w{1,5}/)[0]

    #scrape for arrival details
    arr_airport = (agent.get(result_page).search(".track-panel-arrival .hint")).children.to_s
    arr_time = (((agent.get(result_page).search(".track-panel-actualtime+ .track-panel-actualtime .nolink")).children.to_s).scan /\d{2}:\d{2}\D{2}.?\w{1,5}/)[0]

    return [dep_airport, dep_time, arr_airport, arr_time]
  end

  def self.travel_time(dep_airport, current_location)

    dep = dep_airport.split(" ").join("+")
    current = current_location.split(" ").join("+")
    contents = open("http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{current}&destinations=#{dep}&sensor=false").read
    jsonContents = JSON.parse(contents)

    time = jsonContents["rows"][0]["elements"][0]["duration"]["text"]
  end

  def self.local_time(location, time)
    location = location.split(" ").join("+")
    time = time.to_i

    lat_lng = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{location}&sensor=false").read)
    lat = lat_lng["results"][0]["geometry"]["location"]["lat"]
    lng = lat_lng["results"][0]["geometry"]["location"]["lng"]

    timezone = JSON.parse(open("https://maps.googleapis.com/maps/api/timezone/json?location=#{lat},#{lng}&timestamp=#{time}&sensor=false").read)

    dstOffset = timezone["dstOffset"]
    rawOffset = timezone["rawOffset"]
    timezoneName = timezone["timeZoneName"]

    timeOffset = dstOffset + rawOffset

    local_time = Time.at(time + timeOffset)
  end

  def self.main(flight_number, hang_time, start_location)

    flight_info = scrape_flight(flight_number)
    time_2_airport = travel_time(flight_info[0], start_location)

    utc = Time.parse(flight_info[1])

    hours_mins = time_2_airport.split("hours ")
    hours = hours_mins[0].to_i
    mins = hours_mins[1].to_i

    time_to_add_2_journey = ((hours * 60) + mins)*60
    time_2_leave = (utc - time_to_add_2_journey.to_i) - (hang_time.to_i * 60)

    local_time = local_time(flight_info[0], time_2_leave)

    return {leave_at_utc: time_2_leave, leave_at_local: local_time, flight_from: flight_info[0], flight_dep_time: flight_info[1],flight_to: flight_info[2], flight_arr_time: flight_info[3], travel_time_2_airport: time_2_airport}
  end

end
