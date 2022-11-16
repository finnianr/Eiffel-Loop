note
	description: "Extends [$source EL_CONSOLE_ONLY_LOG] for CRC-32 regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_CRC_32_CONSOLE_ONLY_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		redefine
			new_output
		end

create
	make

feature {NONE} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_CRC_32_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create {EL_CRC_32_CONSOLE_LOG_OUTPUT} Result.make
			end
		end

end