note
	description: "Summary description for {EL_MODULE_COLON_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 10:39:28 GMT (Wednesday 21st February 2018)"
	revision: "2"

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
