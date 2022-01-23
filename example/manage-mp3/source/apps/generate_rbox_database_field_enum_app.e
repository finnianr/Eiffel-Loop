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
	date: "2022-01-23 12:01:31 GMT (Sunday 23rd January 2022)"
	revision: "6"

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
				required_argument ("source", "Path to rhythmdb.c", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end