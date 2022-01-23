note
	description: "[
		Command line interface to [$source UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:56:06 GMT (Sunday 23rd January 2022)"
	revision: "14"

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
				required_argument ("sources", "Path to sources manifest file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "upgrade_default_pointer_syntax"

end