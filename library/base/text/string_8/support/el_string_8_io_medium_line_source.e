note
	description: "IO medium ${STRING_8} line source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:21:36 GMT (Tuesday 20th August 2024)"
	revision: "5"

class
	EL_STRING_8_IO_MEDIUM_LINE_SOURCE

inherit
	EL_FILE_GENERAL_LINE_SOURCE [STRING_8]
		rename
			file as medium
		export
			{NONE} delete_file
		redefine
			Default_file
		end

	EL_ZSTRING_CONSTANTS

create
	make_default, make

feature {NONE} -- Implementation

	on_encoding_update
		do
		end

	update_item
		do
			item := medium.last_string
		end

feature {NONE} -- Constants

	Default_file: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (0)
		end

end