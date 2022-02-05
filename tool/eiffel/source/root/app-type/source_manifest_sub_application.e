note
	description: "Command line interface to command conforming to [$source SOURCE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:17:13 GMT (Saturday 5th February 2022)"
	revision: "1"

deferred class
	SOURCE_MANIFEST_SUB_APPLICATION [COMMAND -> SOURCE_MANIFEST_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("sources", "Path to sources manifest file or directory", << file_must_exist >>)
			>>
		end

end