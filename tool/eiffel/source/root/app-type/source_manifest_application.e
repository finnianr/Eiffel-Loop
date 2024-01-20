note
	description: "Command line interface to command conforming to ${SOURCE_MANIFEST_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	SOURCE_MANIFEST_APPLICATION [COMMAND -> SOURCE_MANIFEST_COMMAND]

inherit
	EL_COMMAND_LINE_APPLICATION [COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("sources", "Path to sources manifest file or directory", << file_must_exist >>)
			>>
		end

end