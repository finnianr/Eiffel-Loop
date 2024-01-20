note
	description: "Command line options for `base.ecf' accessible vias ${EL_SHARED_BASE_OPTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

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