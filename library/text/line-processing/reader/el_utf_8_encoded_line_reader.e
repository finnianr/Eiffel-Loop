note
	description: "Summary description for {EL_UTF_8_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-11-04 9:48:44 GMT (Wednesday 4th November 2015)"
	revision: "6"

class
	EL_UTF_8_ENCODED_LINE_READER [F -> FILE]

inherit
	EL_LINE_READER [F]

create
	default_create

feature -- Element change

	set_line (raw_line: STRING)
		do
			create line.make_from_utf_8 (raw_line)
		end

end
