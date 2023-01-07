note
	description: "Unix **gedit** command to open a file at specific line number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-07 17:46:41 GMT (Saturday 7th January 2023)"
	revision: "1"

class
	GEDIT_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [line_number, source_path: STRING]]
		redefine
			make
		end

create
	 make

feature {NONE} -- Initialization

	make
		do
			Precursor
			set_forking_mode (True)
		end

feature -- Element change

	set_source_path (source_path: FILE_PATH)
		do
			put_path (var.source_path, source_path)
		end

	set_line_number (line_number: INTEGER)
		do
			put_integer (var.line_number, line_number)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		gedit +$LINE_NUMBER $SOURCE_PATH
	]"

end