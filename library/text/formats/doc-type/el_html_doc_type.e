note
	description: "Parses HTML document for MIME type and encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 9:32:51 GMT (Friday 11th February 2022)"
	revision: "13"

class
	EL_HTML_DOC_TYPE

inherit
	EL_DOC_TYPE
		rename
			make as make_doc_type
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
	make, make_from_file

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
		do
			make (Utf_8)
			set_from_file (a_file_path)
		end

	make (a_encoding: NATURAL)
		require
			valid_encoding: Mod_encoding.is_valid (a_encoding)
		do
			make_machine
			make_doc_type ("html", a_encoding)
		end

feature -- Element change

	set_from_file (a_file_path: FILE_PATH)
		do
			do_once_with_file_lines (agent find_charset, open_lines (a_file_path, Utf_8))
		end

feature {NONE} -- State handlers

	find_charset (line: ZSTRING)
		local
			i: INTEGER
		do
			if line.has_substring (Meta_tag) then
				-- Parse
				--    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				-- OR
				--    <meta charset="UTF-8"/>
				i := line.substring_index (Charset_attrib, 1)
				if i > 0 then
					i := i + Charset_attrib.count
					if line [i] = '"' then
						i := i + 1
					end
					encoding.set_from_name (line.substring (i, line.index_of ('"', i) - 1))
					state := final
				end
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			line.left_adjust
			state.call (line)
		end

feature {NONE} -- Constants

	Charset_attrib: ZSTRING
		once
			Result := "charset="
		end

	Meta_tag: ZSTRING
		once
			Result := "<meta"
		end
end