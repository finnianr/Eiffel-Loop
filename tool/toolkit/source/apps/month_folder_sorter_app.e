note
	description: "[
		Command line interface to ${MONTH_FOLDER_SORTER} to abbreviate month folder names
		and prefix with sort number.
	]"
	notes: "[
		Usage:
			el_toolkit -sort_months -sort_months <dir-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-28 7:28:37 GMT (Tuesday 28th October 2025)"
	revision: "1"

class
	MONTH_FOLDER_SORTER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [MONTH_FOLDER_SORTER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("target", "Directory tree", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (dot.to_string)
		end

feature {NONE} -- Constants

	Option_name: STRING = "sort_months"

end