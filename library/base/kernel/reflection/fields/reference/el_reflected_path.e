note
	description: "Reflected field conforming to type ${EL_PATH}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-15 16:01:37 GMT (Saturday 15th July 2023)"
	revision: "20"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_HASHABLE_REFERENCE [EL_PATH]
		redefine
			is_abstract, reset, set_from_readable, set_from_string, to_string, write
		end

	EL_ZSTRING_ROUTINES_IMP
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
			if attached value (a_object) as path then
				Result := path.to_string
			else
				create {STRING} Result.make_empty
			end
		end

feature -- Basic operations

	expand (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as path then
				path.expand
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as path then
				path.wipe_out
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			if attached value (a_object) as path then
				path.set_path (a_value.read_string)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached value (a_object) as path then
				path.set_path (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			if attached value (a_object) as path then
				writeable.write_string (path.parent_string (False))
				writeable.write_string (path.base)
			end
		end

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

end