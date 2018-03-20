note
	description: "Parses HTML document for MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 11:44:45 GMT (Friday 2nd March 2018)"
	revision: "5"

class
	EL_HTML_DOC_TYPE

inherit
	EL_DOC_TYPE
		rename
			make_default as make_default_encoding
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			out
		redefine
			call
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			make_default
			do_once_with_file_lines (agent find_charset, create {EL_FILE_LINE_SOURCE}.make (a_file_path))
		end

	make_default
		do
			make_utf_8 ("html")
			make_machine
		end

feature {NONE} -- State handlers

	find_charset (line: ZSTRING)
		do
			if line.starts_with (Meta_tag) and then line.has_substring (Content_equals) then
				type := line.split ('"').i_th (4).as_string_8
				set_encoding_from_name (type.substring (type.index_of ('=', 1) + 1, type.count))
				state := final
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			line.left_adjust
			state.call ([line])
		end

feature {NONE} -- Constants

	Content_equals: ZSTRING
		once
			Result := "content="
		end

	Meta_tag: ZSTRING
		once
			Result := "<meta"
		end
end
