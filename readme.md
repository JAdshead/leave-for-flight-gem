## Time2leave gem



####Time2leave gem takes: 
	Flight number
	Hang_time in mins (time you think you need at the airport i.e. 120 for international)
	Start location
	
####And Returns:
	Time you must leave(UTC) to make your flight
	Time you must leave(Local Time to Departure Airport) to make your flight
	Flight departure airport
	Flight departure time
	Flight arrival airport
	Flight arrival time
	Time it will take you to get to the airport


Example 
	
	Time2leave.main("flightNumber", "hang-time", "your location")
	
	