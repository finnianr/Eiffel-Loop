note
	description: "Summary description for {EL_UTF_8_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 13:20:32 GMT (Sunday 3rd September 2017)"
	revision: "2"

class
	EL_UTF_8_ENCODED_LINE_READER [F -> FILE]

inherit
	EL_LINE_READER [F]

	EL_MODULE_UTF

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		local
			buffer: like Unicode_buffer
		do
			buffer := Unicode_buffer
			buffer.wipe_out
			UTF.utf_8_string_8_into_string_32 (raw_line, buffer)
			line.append_string_general (buffer)
		end

feature {NONE} -- Constants

	Unicode_buffer: STRING_32
		once
			create Result.make_empty
		end
end
