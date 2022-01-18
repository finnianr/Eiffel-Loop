note
	description: "[$source EL_CONSOLE_LOG_OUTPUT] with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 11:53:53 GMT (Tuesday 18th January 2022)"
	revision: "7"

class
	EL_CRC_32_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
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
			Precursor {EL_CONSOLE_LOG_OUTPUT} (str)
			Precursor {EL_CRC_32_LOG_OUTPUT} (str)
		end

end