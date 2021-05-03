note
	description: "Field that conforms to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:58:52 GMT (Monday 3rd May 2021)"
	revision: "15"

deferred class
	EL_REFLECTED_STRING [S -> STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_memory, set_from_string, write, write_to_memory
		redefine
			append_to_string, to_string
		end

	EL_CACHEABLE_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_memory, set_from_string, write, write_to_memory
		redefine
			append_to_string, to_string
		end

	STRING_HANDLER undefine is_equal end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (v)
			end
		end

end