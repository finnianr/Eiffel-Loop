note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 10:09:10 GMT (Saturday 11th March 2023)"
	revision: "14"

class
	UNDEFINE_PATTERN_COUNTER_APP

obsolete
	"Once-off use"

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