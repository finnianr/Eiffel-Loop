note
	description: "[
		Implement `-define' command option to allow user to define an environment variable
		as a command argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-19 15:03:12 GMT (Tuesday 19th March 2024)"
	revision: "1"

class
	EL_DEFINE_VARIABLE_COMMAND_OPTION

inherit
	EL_COMMAND_LINE_OPTIONS

create
	make, make_default

feature -- Access

	define: ZSTRING
		-- Define an environment variable: name=<value>

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := "[
				define:
					Define an environment variable: -define name=<value>
			]"
		end

end