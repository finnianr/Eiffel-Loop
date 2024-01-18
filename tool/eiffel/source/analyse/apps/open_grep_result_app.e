note
	description: "[
		A command line interface to the command ${OPEN_GREP_RESULT_COMMAND}.
	]"
	notes: "[
		**Command Line Usage**
		
			el_eiffel -open_grep_result -result <path to results> -cursor <cursor line number>
			
		**Gedit External Command**
		
			#!/bin/sh
			el_eiffel -open_grep_result -silent -result "$GEDIT_CURRENT_DOCUMENT_PATH" -cursor $GEDIT_CURRENT_LINE_NUMBER
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-07 17:46:27 GMT (Saturday 7th January 2023)"
	revision: "25"

class
	OPEN_GREP_RESULT_APP

inherit
	EL_COMMAND_LINE_APPLICATION [OPEN_GREP_RESULT_COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("result", "Path to grep results file", << file_must_exist >>),
				optional_argument ("cursor", "Current cursor line number", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, 1)
		end

end