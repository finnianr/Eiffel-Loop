note
	description: "Module colon field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MODULE_COLON_FIELD
	
inherit
	EL_MODULE

feature {NONE} -- Constants

	Colon_field: EL_COLON_FIELD_ROUTINES
		once
			create Result
		end
end
