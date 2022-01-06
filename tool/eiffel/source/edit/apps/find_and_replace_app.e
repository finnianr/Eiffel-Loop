note
	description: "Find and replace operating on a source manifest file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 14:50:47 GMT (Thursday 6th January 2022)"
	revision: "15"

class
	FIND_AND_REPLACE_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [FIND_AND_REPLACE_COMMAND]
		redefine
			Option_name
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				required_argument ("find", "Text to find in source files"),
				required_argument ("replace", "Replacement text")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string)
		end

feature {NONE} -- Constants

	Option_name: STRING = "find_replace"

	Description: STRING = "Finds and replaces text in Eiffel source files"

end