note
	description: "Summary description for {EL_MODULE_COLON_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-10 8:40:28 GMT (Wednesday 10th August 2016)"
	revision: "1"

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
