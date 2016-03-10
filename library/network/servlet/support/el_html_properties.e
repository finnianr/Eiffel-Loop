note
	description: "Summary description for {EL_HTML_PROPERTIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_HTML_PROPERTIES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default, call
		end

	EL_ENCODEABLE_AS_TEXT

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			make_utf_8
			create content_type.make_empty
		end

	make (a_file_path: EL_FILE_PATH)
		do
			make_default
			do_once_with_file_lines (agent find_charset, create {EL_FILE_LINE_SOURCE}.make (a_file_path))
		end

feature -- Access

	content_type: STRING

feature {NONE} -- State handlers

	find_charset (line: ASTRING)
		do
			if line.starts_with ("<meta") and then line.has_substring ("content=") then
				content_type := line.split ('"').i_th (4).as_string_8
				set_encoding_from_name (content_type.substring (content_type.index_of ('=', 1) + 1, content_type.count))
				state := agent final
			end
		end

feature {NONE} -- Implementation

	call (line: ASTRING)
		-- call state procedure with item
		do
			line.left_adjust
			state.call ([line])
		end

end
