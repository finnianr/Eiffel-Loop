note
	description: "Field conforming to [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-30 10:24:58 GMT (Monday 30th April 2018)"
	revision: "1"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_REFERENCE
		rename
			default_value as default_path
		redefine
			default_path, default_defined, reset, set_from_string, initialize_default, to_string
		end

	EL_ZSTRING_ROUTINES

create
	make

feature -- Status query

	default_defined: BOOLEAN
		do
			if not Default_value_table.has (type_id) and then Path_types.has (type_id) then
				Result := True
			end
		end

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

feature {NONE} -- Implementation

	initialize_default
		local
			types: like Path_types
		do
			types := Path_types
			if types.has_key (type_id) and then attached {EL_PATH} types.found_item as path then
				default_path := path
			end
		end

feature {NONE} -- Internal attributes

	default_path: EL_PATH

feature {NONE} -- Constants

	Path_types: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<<
				create {EL_DIR_PATH},
				create {EL_DIR_URI_PATH},
				create {EL_FILE_PATH},
				create {EL_FILE_URI_PATH}
			>>)
		end

end
