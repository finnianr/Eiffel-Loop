note
	description: "Region of country lookup table for ip number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 14:28:44 GMT (Monday 5th August 2019)"
	revision: "1"

class
	EL_REGION_CACHE_TABLE

inherit
	EL_LOCATION_CACHE_TABLE

create
	make

feature {NONE} -- Constants

	Location_type: STRING = "region"

end
