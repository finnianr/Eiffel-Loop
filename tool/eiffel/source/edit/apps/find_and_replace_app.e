note
	description: "Find and replace operating on a source manifest file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:02:14 GMT (Saturday 5th February 2022)"
	revision: "18"

class
	FIND_AND_REPLACE_APP

inherit
	SOURCE_MANIFEST_SUB_APPLICATION [FIND_AND_REPLACE_COMMAND]
		redefine
			argument_list, Option_name
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor +
				required_argument ("find", "Text to find in source files", No_checks) +
				required_argument ("replace", "Replacement text", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, Empty_string, Empty_string)
		end

feature {NONE} -- Constants

	Option_name: STRING = "find_replace"

end