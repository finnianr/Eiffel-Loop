note
	description: "[
		Line reader that assumes that file is already encoded with the same ISO-8859 encoding
		as used by EL_ASTRING. Set in EL_SHARED_CODEC. ISO-8859-15 by default.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_LATIN_LINE_DECODER [F -> FILE]

inherit
	EL_LINE_DECODER [F]

create
	default_create

feature -- Element change

	set_line (raw_line: STRING)
		do
			create line.make_from_string (raw_line)
		end

end
