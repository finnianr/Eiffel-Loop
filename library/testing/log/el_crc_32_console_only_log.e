note
	description: "Extends ${EL_CONSOLE_ONLY_LOG} for CRC-32 regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_CRC_32_CONSOLE_ONLY_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		redefine
			new_output
		end

create
	make

feature {EL_LOG_HANDLER} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_CRC_32_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create {EL_CRC_32_CONSOLE_LOG_OUTPUT} Result.make
			end
		end

end