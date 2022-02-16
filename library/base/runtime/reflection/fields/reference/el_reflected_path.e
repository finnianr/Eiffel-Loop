note
	description: "Reflected field conforming to type [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 14:20:37 GMT (Wednesday 16th February 2022)"
	revision: "13"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_REFERENCE [EL_PATH]
		redefine
			reset, set_from_readable, set_from_string, to_string, write
		end

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached {EL_PATH} value (a_object) as path then
				Result := path.to_string
			else
				create {STRING} Result.make_empty
			end
		end

feature -- Basic operations

	expand (a_object: EL_REFLECTIVE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.expand
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.wipe_out
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.set_path (a_value.read_string)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.set_path (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.write_to (writeable)
			end
		end

end