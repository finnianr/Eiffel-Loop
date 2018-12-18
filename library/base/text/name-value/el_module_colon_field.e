note
	description: "Module colon field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

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
