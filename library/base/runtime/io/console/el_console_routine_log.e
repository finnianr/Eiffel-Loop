note
	description: "Console routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-14 9:44:44 GMT (Saturday 14th November 2020)"
	revision: "6"

class
	EL_CONSOLE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			make_default
			output := a_output
		end

feature {NONE} -- Implementation

	output: EL_CONSOLE_LOG_OUTPUT

end