note
	description: "Summary description for {EL_ENCODED_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 13:09:52 GMT (Sunday 3rd September 2017)"
	revision: "4"

class
	EL_ENCODED_LINE_READER  [F -> FILE]

inherit
	EL_LINE_READER [F]

	STRING_HANDLER

	EL_SHARED_ONCE_STRINGS

create
	make

feature {NONE} -- Initialization

	make (a_codec: like codec)
		do
			codec := a_codec
		end

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		local
			count: INTEGER
		do
			if Once_string.encoded_with (codec) then
				-- Already the same as default ZSTRING encoding
				count := raw_line.count
				line.grow (count)
				line.area.copy_data (raw_line.area, 0, 0, count)
				line.set_count (count)
			else
				line.append_string_general (codec.as_unicode (raw_line))
			end
		end

	codec: EL_ZCODEC

end
