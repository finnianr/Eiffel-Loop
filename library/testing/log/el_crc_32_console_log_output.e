note
	description: "${EL_CONSOLE_LOG_OUTPUT} with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

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