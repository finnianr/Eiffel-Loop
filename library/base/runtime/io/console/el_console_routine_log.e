note
	description: "Console routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

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