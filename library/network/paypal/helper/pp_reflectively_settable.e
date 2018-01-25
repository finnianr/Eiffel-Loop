note
	description: "Summary description for {PP_REFLECTIVELY_SETTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:17:47 GMT (Thursday 28th December 2017)"
	revision: "3"

class
	PP_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		undefine
			export_name, import_name
		end

	EL_SETTABLE_FROM_ZSTRING

	PP_NAMING_ROUTINES
		undefine
			is_equal
		end

end
