note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-03 12:12:05 GMT (Sunday 3rd September 2023)"
	revision: "15"

class
	UNDEFINE_PATTERN_COUNTER_APP

obsolete
	"Once-off use"

inherit
	SOURCE_MANIFEST_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
		redefine
			option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "undefine_counter"

end