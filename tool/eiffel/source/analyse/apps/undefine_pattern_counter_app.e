note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:45:48 GMT (Tuesday 18th February 2020)"
	revision: "8"

class
	UNDEFINE_PATTERN_COUNTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				optional_argument ("define", "Define an environment variable: name=<value>")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

feature {NONE} -- Constants

	Description: STRING = "[
		Count the number of classes in the source tree manifest that exhibit multiple inheritance of classes
		with an identical pattern of feature undefining.
	]"

	Option_name: STRING = "undefine_counter"

end
