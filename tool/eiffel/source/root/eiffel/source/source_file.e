note
	description: "Eiffel source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 7:26:33 GMT (Friday 13th September 2024)"
	revision: "12"

class
	SOURCE_FILE

inherit
	EL_PLAIN_TEXT_FILE
		redefine
			make_default, set_default_encoding
		end

create
	make, make_with_name, make_with_path, make_create_read_write,
	make_open_read, make_open_write, make_open_append,	make_open_read_write,
	make_open_read_append

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			byte_order_mark.enable
		end

feature -- Access

	editable_lines: EDITABLE_SOURCE_LINES
		do
			create Result.make_from (lines)
		end

feature {NONE} -- Implementation

	set_default_encoding
		-- Latin-1 is default encoding for Eiffel
		do
			set_latin_encoding (1)
		end

end