note
	description: "Country lookup table for ip number"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_COUNTRY_CACHE_TABLE

inherit
	EL_LOCATION_CACHE_TABLE

create
	make

feature {NONE} -- Constants

	Location_type: STRING = "country_name"

end
