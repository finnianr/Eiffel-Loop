note
	description: "Summary description for {EL_STD_IO_ROUTINE_LOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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