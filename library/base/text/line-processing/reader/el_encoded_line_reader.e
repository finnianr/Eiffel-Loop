note
	description: "Summary description for {EL_ENCODED_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-03 12:34:09 GMT (Saturday 3rd March 2018)"
	revision: "5"

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
				line.append_string_general (codec.as_unicode (raw_line, False))
			end
		end

	codec: EL_ZCODEC

end
