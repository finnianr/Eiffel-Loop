note
	description: "Extends `EL_FILE_AND_CONSOLE_LOG_OUTPUT' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-18 11:18:34 GMT (Friday 18th August 2017)"
	revision: "2"

class
	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_CONSOLE_LOG_OUTPUT
		rename
			make as make_file_and_console
		export
			{ANY} extendible
		redefine
			put_file_string
		end

create
	make

feature -- Initialization

	make (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER; a_crc_32: like crc_32)
		do
			crc_32 := a_crc_32
			make_file_and_console (log_path, a_thread_name, a_index)
		end

feature -- Output

	put_file_string (str: STRING)
		do
			Precursor (str); crc_32.add_string_8 (str)
		end

feature {NONE} -- Internal attributes

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end
