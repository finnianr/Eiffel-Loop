note
	description: "Summary description for {EL_UTF_8_FILE_LINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_UTF_8_FILE_LINES

inherit
	EL_FILE_LINE_SOURCE
		redefine
			make
		end

create
	default_create, make, make_from_file

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			Precursor (a_file_path)
			set_utf_encoding (8)
		end

end
