note
	description: "[
		A command line interface to the command [$source CODEBASE_STATISTICS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:14:50 GMT (Saturday 5th February 2022)"
	revision: "22"

class
	CODEBASE_STATISTICS_APP

inherit
	SOURCE_MANIFEST_SUB_APPLICATION [CODEBASE_STATISTICS_COMMAND]
		redefine
			argument_list, option_name
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor +
				optional_argument ("define", "Define an environment variable: name=<value>", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

feature {NONE} -- Constants

	Option_name: STRING = "codebase_stats"

end