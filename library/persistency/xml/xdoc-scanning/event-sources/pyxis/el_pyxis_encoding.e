note
	description: "Pyxis encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "7"

class
	EL_PYXIS_ENCODING

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_ENCODING

create
	make_from_file

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			make_machine
			make_latin_1
			create source_lines.make (a_file_path)
			do_once_with_file_lines (agent find_encoding, source_lines)
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
