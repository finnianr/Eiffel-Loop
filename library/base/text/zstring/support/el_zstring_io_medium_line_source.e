note
	description: "${ZSTRING} IO medium line source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:24:03 GMT (Sunday 25th August 2024)"
	revision: "8"

class
	EL_ZSTRING_IO_MEDIUM_LINE_SOURCE

inherit
	EL_FILE_GENERAL_LINE_SOURCE [ZSTRING]
		rename
			file as medium
		export
			{NONE} delete_file
		redefine
			Default_file
		end

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

	Default_file: EL_ZSTRING_IO_MEDIUM
		once
			create Result.make (0)
		end
end