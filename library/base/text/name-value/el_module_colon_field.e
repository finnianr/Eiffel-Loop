note
	description: "Shared instance of class [$source EL_COLON_FIELD_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 9:13:18 GMT (Wednesday   25th   September   2019)"
	revision: "7"

deferred class
	EL_MODULE_COLON_FIELD

inherit
	EL_MODULE

feature {NONE} -- Constants

	Colon_field: EL_COLON_FIELD_ROUTINES
		once
			create Result
		end
end
