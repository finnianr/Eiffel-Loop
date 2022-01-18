note
	description: "[$source EL_CONSOLE_AND_FILE_LOG] with CRC-32 checksum in log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 12:28:52 GMT (Tuesday 18th January 2022)"
	revision: "2"

class
	EL_CRC_32_CONSOLE_AND_FILE_LOG

inherit
	EL_CONSOLE_AND_FILE_LOG
		redefine
			new_output
		end

create
	make

feature {NONE} -- Implementation

	new_output: EL_CRC_32_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_CRC_32_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create Result.make
			end
		end

end