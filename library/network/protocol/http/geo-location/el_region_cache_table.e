note
	description: "Region of country lookup table for ip number"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_REGION_CACHE_TABLE

inherit
	EL_LOCATION_CACHE_TABLE

create
	make

feature {NONE} -- Constants

	Location_type: STRING = "region"

end
