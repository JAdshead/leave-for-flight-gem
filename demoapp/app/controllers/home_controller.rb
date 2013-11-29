class HomeController < ApplicationController
  def index

    flight_number = params[:flight_number]
    hang_time = params[:hang_time]
    location  = params[:location]

    if flight_number
      @flight = Time2leave.main(flight_number, hang_time,location)
    else
      @flight = nil
    end
  end

  def show

  end
end
