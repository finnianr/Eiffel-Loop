note
	description: "Summary description for {EL_STRING_MEDIUM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_LATIN_TEXT_IO_MEDIUM

inherit
	EL_TEXT_IO_MEDIUM
		redefine
			text, last_string
		end

create
	make, make_open_write, make_open_write_to_string, make_open_read_from_string

feature -- Access

	text: EL_ASTRING

	last_string: EL_ASTRING

end