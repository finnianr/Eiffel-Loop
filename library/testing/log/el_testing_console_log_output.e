note
	description: "Extends `EL_CONSOLE_LOG_OUTPUT' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 14:35:12 GMT (Friday 8th July 2016)"
	revision: "1"

class
	EL_TESTING_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		rename
			make as make_output
		redefine
			write_string, write_string_8
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

	write_string (str: ZSTRING)
		local
			utf_8: STRING
		do
			utf_8 := str.to_utf_8
			io.put_string (utf_8)
			crc_32.add_string_8 (utf_8)
		end

	write_string_8 (str: STRING)
			-- Write str8 filtering color high lighting control sequences
		do
			if not Escape_sequences.has (str) then
				io.put_string (str)
				crc_32.add_string_8 (str)
			end
		end

feature {NONE} -- Internal attributes

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end