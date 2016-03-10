note
	description: "Summary description for {EL_UTF_8_FILE_LINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 11:32:44 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_UTF_8_FILE_LINES

inherit
	EL_FILE_LINE_SOURCE
		redefine
			make, is_utf8
		end

create
	default_create, make, make_from_file

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			Precursor (a_file_path)
			set_encoding (Encoding_utf, 8)
		end

feature -- Status query

	is_utf8: BOOLEAN
		do
			Result := True
		end

end