note
	description: "Application based on repository publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:56:07 GMT (Sunday 23rd January 2022)"
	revision: "7"

deferred class
	REPOSITORY_PUBLISHER_SUB_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("config", "Path to publisher configuration file", << file_must_exist >>),
				required_argument ("version", "Repository version number", No_checks),
				optional_argument ("threads", "Number of threads to use for reading files", No_checks)
			>>
		end

end