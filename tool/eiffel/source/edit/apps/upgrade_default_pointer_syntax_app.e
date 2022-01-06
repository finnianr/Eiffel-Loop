note
	description: "[
		Command line interface to [$source UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 17:10:44 GMT (Thursday 6th January 2022)"
	revision: "12"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "upgrade_default_pointer_syntax"

	Description: STRING = "[
		Change syntax of default_pointer references: 
		
			ptr /= default_pointer TO is_attached (ptr)
			ptr = default_pointer TO not is_attached (ptr)
	]"

end