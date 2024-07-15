note
	description: "[
		Command line interface to ${EL_LOG_PRUNE_COMMAND} for deleting excess log files
		
		Usage:
		
			command -log_prune -keep <number ot keep>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 11:33:25 GMT (Monday 15th July 2024)"
	revision: "1"

class
	EL_LOG_PRUNE_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_LOG_PRUNE_COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("prefix", "Log name prefix", No_checks),
				optional_argument ("keep", "Number of log files to keep", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("Main", 5)
		end

end