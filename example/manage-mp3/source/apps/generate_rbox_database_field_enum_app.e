note
	description: "[
		Sub-application to generate class [$source RBOX_DATABASE_FIELD_ENUM] from C source file `rhythmdb.c'
	]"
	notes: "[
		**Usage:**
		
			el_rhythmbox -generate_rbox_database_field_enum -source <path>

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-08 12:54:50 GMT (Wednesday 8th April 2020)"
	revision: "2"

class
	GENERATE_RBOX_DATABASE_FIELD_ENUM_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [GENERATE_RBOX_DATABASE_FIELD_ENUM]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Path to rhythmdb.c", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end


feature {NONE} -- Constants

	Description: STRING = "Generate class RBOX_DATABASE_FIELDS from C source file `rhythmdb.c'"
end
