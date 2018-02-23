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

	EL_ZCODEC_FACTORY

create
	make

feature {NONE} -- Initialization

	make (line_source: EL_ENCODEABLE_AS_TEXT)
		do
			codec := new_codec (line_source)
		end

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		do
			if line.encoded_with (codec) then
				raw_line.prune_all ('%/026/') -- Reserved by `EL_ZSTRING' as Unicode placeholder
				line.append_raw_string_8 (raw_line)
			else
				line.append_string_general (codec.as_unicode (raw_line))
			end
		end

	codec: EL_ZCODEC

end
