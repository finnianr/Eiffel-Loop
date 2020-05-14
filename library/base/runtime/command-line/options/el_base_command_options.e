note
	description: "Command line options for `base.ecf' accessible vias [$source EL_SHARED_BASE_OPTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 13:48:03 GMT (Thursday 14th May 2020)"
	revision: "5"

class
	EL_BASE_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS

create
	make, make_default

feature -- Options

	no_highlighting: BOOLEAN
		-- turns off logging color highlighting

	silent: BOOLEAN
		-- all console output is suppressed

	zstring_codec: STRING
		-- defaults to ISO-8859-15

feature -- Constants

	Opt_silent: STRING
		once
			Result := "silent"
		end

feature {NONE} -- Constants

	Help_text: STRING = "[
		no_highlighting:
			Turn off color highlighting for console output
		silent:
			Suppress all output to console
		zstring_codec:
			Name of character set used to set once function: `{EL_ZSTRING}.codec'
	]"
end
