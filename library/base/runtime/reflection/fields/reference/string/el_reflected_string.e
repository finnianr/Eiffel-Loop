note
	description: "Field that conforms to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-13 13:40:08 GMT (Saturday 13th February 2021)"
	revision: "12"

deferred class
	EL_REFLECTED_STRING [S -> STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_memory, set_from_string, write
		redefine
			to_string
		end

	EL_CACHEABLE_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_memory, set_from_string, write
		redefine
			to_string
		end

	STRING_HANDLER undefine is_equal end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

end