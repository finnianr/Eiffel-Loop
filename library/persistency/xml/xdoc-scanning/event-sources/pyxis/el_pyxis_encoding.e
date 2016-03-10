note
	description: "Summary description for {EL_PYXIS_ENCODING_READER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			source_lines: EL_UTF_8_FILE_LINES
		do
			make_machine
			create source_lines.make (a_file_path)
			do_once_with_file_lines (agent find_encoding, source_lines)
		end

feature {NONE} -- State handlers

	find_encoding (line: ASTRING)
		local
			parts: EL_ASTRING_LIST
		do
			if line.has_substring (once "encoding") then
				line.right_adjust
				create parts.make_with_separator (line, '"', False)
				set_encoding_from_name (parts [parts.count - 1])
				state := agent final
			end
		end

end
