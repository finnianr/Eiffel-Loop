note
	description: "Application based on repository publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 17:08:18 GMT (Sunday 6th February 2022)"
	revision: "10"

deferred class
	REPOSITORY_PUBLISHER_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_COMMAND_LINE_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				config_argument ("Path to publisher configuration file"),
				required_argument ("version", "Repository version number", No_checks),
				optional_argument ("threads", "Number of threads to use for reading files", No_checks)
			>>
		end

end