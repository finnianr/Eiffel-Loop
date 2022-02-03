note
	description: "Source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 11:04:28 GMT (Tuesday 18th February 2020)"
	revision: "7"

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
