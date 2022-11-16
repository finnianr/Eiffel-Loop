note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	UNDEFINE_PATTERN_COUNTER_APP

inherit
	SOURCE_MANIFEST_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
		redefine
			argument_list, option_name
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("define", "Define an environment variable: name=<value>", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH}, create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

feature {NONE} -- Constants

	Option_name: STRING = "undefine_counter"

end