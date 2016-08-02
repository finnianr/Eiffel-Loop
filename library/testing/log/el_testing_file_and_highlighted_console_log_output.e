note
	description: "Extends `EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 13:41:13 GMT (Friday 8th July 2016)"
	revision: "1"

class
	EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		rename
			make as make_file_and_console
		export
			{ANY} extendible
		undefine
			put_file_string
		redefine
			write_string_8
		end

	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT
		redefine
			write_string_8
		end

create
	make

feature {NONE} -- Implementation

	write_string_8 (str: STRING)
		local
			checksum: NATURAL
		do
			checksum := crc_32.checksum
			Precursor {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}(str)
			if checksum = crc_32.checksum then
				crc_32.add_string_8 (str)
			end
		end

end