note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:24:48 GMT (Wednesday   25th   September   2019)"
	revision: "7"

class
	UNDEFINE_PATTERN_COUNTER_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{UNDEFINE_PATTERN_COUNTER_APP}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

	Option_name: STRING = "undefine_counter"

end
