note
	description: "Source file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-02 9:27:06 GMT (Sunday 2nd June 2019)"
	revision: "6"

class
	SOURCE_FILE

inherit
	EL_PLAIN_TEXT_FILE
		redefine
			set_utf_encoding
		end

create
	make, make_with_name, make_with_path,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature -- Element change

	set_utf_encoding (id: INTEGER)
		do
			Precursor (id)
			byte_order_mark.enable
		end

end
