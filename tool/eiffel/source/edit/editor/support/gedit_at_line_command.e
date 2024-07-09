note
	description: "Unix **gedit** command to open a file at specific line number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:22:55 GMT (Tuesday 9th July 2024)"
	revision: "3"

class
	GEDIT_AT_LINE_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [line_number, source_path: STRING]]
		redefine
			default_template, make
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

	Default_template: STRING = "[
		gedit +$LINE_NUMBER $SOURCE_PATH
	]"

end