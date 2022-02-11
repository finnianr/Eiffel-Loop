note
	description: "[
		Parses encoding attribute in quotes for markup document.

			<?xml version = "1.0" encoding = "ISO-8859-1"?>
				
		OR
				
			pyxis-doc:
				version = 1.0; encoding = "ISO-8859-1"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 9:12:14 GMT (Friday 11th February 2022)"
	revision: "14"

class
	EL_MARKUP_ENCODING

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_ENCODING_BASE
		rename
			make as make_encoding
		end

create
	make_from_file

convert
	encoding: {NATURAL}

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
		do
			make_machine
			make_encoding (Latin_1)
			do_once_with_file_lines (agent find_encoding, open_lines (a_file_path, Utf_8))
		end

feature {NONE} -- State handlers

	find_encoding (line: ZSTRING)
		local
			start_index: INTEGER
		do
			start_index := line.substring_index (Attribute_encoding, 1)
			if start_index.to_boolean then
				set_from_name (line.substring_between (Double_quote, Double_quote, start_index + Attribute_encoding.count))
				state := final
			end
		end

feature {NONE} -- Constants

	Attribute_encoding: ZSTRING
		once
			Result := "encoding"
		end

	Double_quote: ZSTRING
		once
			Result := "%""
		end

end