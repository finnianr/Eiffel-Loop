note
	description: "Summary description for {EL_STD_IO_ROUTINE_LOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
