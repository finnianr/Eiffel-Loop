note
	description: "Reflected field that conforms to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 12:30:34 GMT (Monday 24th May 2021)"
	revision: "18"

deferred class
	EL_REFLECTED_STRING [S -> STRING_GENERAL create make end]

inherit
	EL_REFLECTED_REFERENCE [S]
		rename
			set_from_string as set_from_string_general
		undefine
			reset, set_from_readable, set_from_memory, write, write_to_memory
		redefine
			append_to_string, to_string, set_from_string_general
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

	set_from_string_general (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {S} string as str then
				set (a_object, str)
			else
				if attached value (a_object) as str then
					str.append (string)
				else
					set (a_object, new_string (string))
				end
			end
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): S
		do
			create Result.make (general.count)
			Result.append (general)
		end

end