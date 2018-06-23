note
	description: "Application based on repository publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 11:11:26 GMT (Tuesday 19th June 2018)"
	revision: "4"

deferred class
	REPOSITORY_PUBLISHER_SUB_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Path to publisher configuration file", << file_must_exist >>),
				required_argument ("version", "Repository version number"),
				optional_argument ("threads", "Number of threads to use for reading files")
			>>
		end

end
