note
	description: "Summary description for {EL_ENCODED_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 10:34:55 GMT (Thursday 25th May 2017)"
	revision: "3"

class
	EL_ENCODED_LINE_READER  [F -> FILE]

inherit
	EL_LINE_READER [F]

	STRING_HANDLER
		undefine
			default_create
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_codec: like codec)
		do
			default_create
			codec := a_codec
		end

feature -- Element change

	set_line (raw_line: STRING)
		local
			buffer: STRING_32
		do
			if codec.id = 1 then
				line := raw_line

			elseif Once_string.encoded_with (codec) then
				-- Already the same as default ZSTRING encoding
				create line.make_from_string (raw_line)

			else
				create buffer.make_filled ('%U', raw_line.count)
				codec.decode (raw_line.count, raw_line.area, buffer.area, 0)
				create line.make_from_general (buffer)
			end
		end

feature {NONE} -- Implementation

	codec: EL_ZCODEC

end
