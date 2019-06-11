note
	description: "Field that conforms to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 9:24:09 GMT (Tuesday 11th June 2019)"
	revision: "7"

deferred class
	EL_REFLECTED_STRING_GENERAL [S -> STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_string, write
		redefine
			Default_objects, reset, set_from_readable, set_from_string, to_string, write
		end

	EL_STRING_32_CONSTANTS

	EL_ZSTRING_CONSTANTS

feature -- Access

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

feature {NONE} -- Constants

	Default_objects: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<< Empty_string, Empty_string_8, Empty_string_32 >>)
		end

end
