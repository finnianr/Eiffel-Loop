note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:12:19 GMT (Saturday 5th February 2022)"
	revision: "11"

class
	UNDEFINE_PATTERN_COUNTER_APP

inherit
	SOURCE_MANIFEST_SUB_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
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