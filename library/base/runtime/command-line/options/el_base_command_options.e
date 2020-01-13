note
	description: "Command line options for `base.ecf' accessible vias [$source EL_SHARED_BASE_OPTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 17:49:03 GMT (Monday 13th January 2020)"
	revision: "3"

class
	EL_BASE_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS

create
	make, make_default

feature -- Access

	no_highlighting: BOOLEAN
		-- turns off logging color highlighting

	silent: BOOLEAN
		-- all console output is suppressed

	Opt_silent: STRING
		once
			Result := "silent"
		end

feature {NONE} -- Implementation

	new_default: like Current
		do
			create Result.make_default
		end

feature {NONE} -- Constants

	Help_text: STRING = "[
		no_highlighting:
			Turn off color highlighting for console output
		silent:
			Suppress all output to console
	]"
end
