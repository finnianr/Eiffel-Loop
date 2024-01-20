note
	description: "${EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_CRC_32_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		redefine
			write_console
		end

	EL_CRC_32_LOG_OUTPUT
		redefine
			write_console
		end

create
	make

feature {NONE} -- Implementation

	write_console (str: READABLE_STRING_GENERAL)
		do
			Precursor {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} (str)
			Precursor {EL_CRC_32_LOG_OUTPUT} (str)
		end
end