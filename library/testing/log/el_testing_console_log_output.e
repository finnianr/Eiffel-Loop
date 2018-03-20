note
	description: "Extends [$source EL_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:30:25 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_TESTING_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		rename
			make as make_output
		redefine
			write_console
		end

create
	make

feature -- Initialization

	make (a_crc_32: like crc_32)
		do
			crc_32 := a_crc_32
			make_output
		end

feature {NONE} -- Implementation

	write_console (str: READABLE_STRING_GENERAL)
		local
			l_encoded: STRING
		do
			l_encoded := console_encoded (str)
			std_output.put_string (l_encoded)
			crc_32.add_string_8 (l_encoded)
		end

feature {NONE} -- Internal attributes

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end
