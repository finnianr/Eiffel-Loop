note
	description: "Country lookup table for ip number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 14:29:02 GMT (Monday 5th August 2019)"
	revision: "1"

class
	EL_COUNTRY_CACHE_TABLE

inherit
	EL_LOCATION_CACHE_TABLE

create
	make

feature {NONE} -- Constants

	Location_type: STRING = "country_name"

end
