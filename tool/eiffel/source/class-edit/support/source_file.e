note
	description: "Summary description for {EIFFEL_SOURCE_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "3"

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

	set_utf_encoding (a_encoding: like encoding)
		do
			Precursor (a_encoding)
			enable_bom
		end

end
