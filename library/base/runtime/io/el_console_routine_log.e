note
	description: "Summary description for {EL_STD_IO_ROUTINE_LOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 11:37:05 GMT (Friday 8th July 2016)"
	revision: "5"

class
	EL_CONSOLE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			output := a_output
		end

feature {NONE} -- Implementation

	output: EL_CONSOLE_LOG_OUTPUT

end
