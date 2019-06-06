note
	description: "Field conforming to [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 8:08:24 GMT (Thursday 6th June 2019)"
	revision: "6"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_REFERENCE [EL_PATH]
		rename
			default_value as default_path
		redefine
			reset, set_from_readable, set_from_string, Default_objects, to_string, write
		end

	EL_ZSTRING_ROUTINES

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
				path.set_parent_path (Empty_string)
				path.base.wipe_out
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.make (a_value.read_string)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.make (new_zstring (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			if attached {EL_PATH} value (a_object) as path then
				writeable.write_string (path.to_string)
			end
		end

feature {NONE} -- Constants

	Default_objects: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<<
				create {EL_DIR_PATH},
				create {EL_DIR_URI_PATH},
				create {EL_FILE_PATH},
				create {EL_FILE_URI_PATH}
			>>)
		end

end
