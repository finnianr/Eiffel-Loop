note
	description: "Summary description for {EL_PYXIS_ENCODING_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-26 11:56:39 GMT (Wednesday 26th April 2017)"
	revision: "3"

class
	EL_PYXIS_ENCODING

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_ENCODEABLE_AS_TEXT

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
			parts: EL_ZSTRING_LIST
		do
			if line.has_substring (Attribute_encoding) then
				line.right_adjust
				create parts.make_with_separator (line, '"', False)
				set_encoding_from_name (parts [parts.count - 1])
				state := final
			end
		end

feature {NONE} -- Constants

	Attribute_encoding: ZSTRING
		once
			Result := "encoding"
		end


end
