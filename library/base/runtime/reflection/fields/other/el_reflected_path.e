note
	description: "Field conforming to [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-04 17:55:42 GMT (Friday 4th May 2018)"
	revision: "2"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_REFERENCE [EL_PATH]
		rename
			default_value as default_path
		redefine
			reset, set_from_string, Default_objects, to_string
		end

	EL_ZSTRING_ROUTINES

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

	reset (a_object: EL_REFLECTIVE)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.set_parent_path (Empty_string)
				path.base.wipe_out
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_PATH} value (a_object) as path then
				path.make (as_zstring (string))
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
