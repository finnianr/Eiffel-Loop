note
	description: "Summary description for {EL_STD_IO_ROUTINE_LOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-09 14:39:43 GMT (Saturday 9th November 2013)"
	revision: "3"

class
	EL_CONSOLE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG

create
	make

feature {NONE} -- Initialization

	make
		do
			if Log_manager.is_highlighting_enabled then
				create {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} output.make
			else
				create output.make
			end
		end

feature {NONE} -- Implementation

	output: EL_CONSOLE_LOG_OUTPUT

end
