note
	description: "Extends [$source EL_CONSOLE_ONLY_LOG] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_TESTING_CONSOLE_ONLY_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		rename
			make as make_log
		redefine
			new_output
		end

create
	make

feature -- Initialization

	make (a_crc_32: like crc_32)
		do
			crc_32 := a_crc_32
			make_log
		end

feature {NONE} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_TESTING_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (crc_32)
			else
				create {EL_TESTING_CONSOLE_LOG_OUTPUT} Result.make (crc_32)
			end
		end

feature {NONE} -- Internal attributes

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end
