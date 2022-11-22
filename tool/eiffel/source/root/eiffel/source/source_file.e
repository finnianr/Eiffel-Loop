note
	description: "Source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 10:26:02 GMT (Tuesday 22nd November 2022)"
	revision: "9"

class
	SOURCE_FILE

inherit
	EL_PLAIN_TEXT_FILE
		redefine
			make_default
		end

create
	make, make_with_name, make_with_path,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			byte_order_mark.enable
		end

end