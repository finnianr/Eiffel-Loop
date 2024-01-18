note
	description: "Command line interface to command conforming to ${SOURCE_MANIFEST_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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