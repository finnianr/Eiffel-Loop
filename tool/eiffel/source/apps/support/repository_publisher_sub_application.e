note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 12:29:11 GMT (Wednesday 21st February 2018)"
	revision: "1"

deferred class
	REPOSITORY_PUBLISHER_SUB_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

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
