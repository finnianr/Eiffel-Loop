note
	description: "Summary description for {EL_UTF_8_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-03 9:45:21 GMT (Wednesday 3rd July 2013)"
	revision: "2"

class
	EL_UTF_8_LINE_DECODER [F -> FILE]

inherit
	EL_LINE_DECODER [F]

create
	default_create

feature -- Element change

	set_line (raw_line: STRING)
		do
			create line.make_from_utf8 (raw_line)
		end

end
