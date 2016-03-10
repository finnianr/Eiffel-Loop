note
	description: "Summary description for {EL_ENCODED_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-18 13:21:56 GMT (Monday 18th January 2016)"
	revision: "6"

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
			buffer: like Unicode_buffer
			count: INTEGER
		do
			if codec.id = 1 then
				create line.make_from_latin_1 (raw_line)

			elseif Once_string.encoded_with (codec) then
				-- Already the same as default ZSTRING encoding
				create line.make_from_string (raw_line)

			else
				buffer := Unicode_buffer
				count := raw_line.count
				buffer.grow (count)
				buffer.set_count (count)
				codec.decode (count, raw_line.area, buffer.area)
				create line.make_from_unicode (buffer)
			end
		end

feature {NONE} -- Implementation

	codec: EL_ZCODEC

feature {NONE} -- Constants

	Unicode_buffer: STRING_32
		once
			create Result.make_empty
		end

end
