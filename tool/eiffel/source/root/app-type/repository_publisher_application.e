note
	description: "Application based on repository publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-04 12:48:05 GMT (Saturday 4th June 2022)"
	revision: "12"

deferred class
	REPOSITORY_PUBLISHER_APPLICATION [C -> EL_APPLICATION_COMMAND]

inherit
	EL_COMMAND_LINE_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				config_argument ("Path to publisher configuration file"),
				required_argument ("version", "Repository version number", No_checks),
				optional_argument (
					"cpu_percent", "Percentage of CPU processors to use for reading files", << within_range (0 |..| 100) >>
				)
			>>
		end

end