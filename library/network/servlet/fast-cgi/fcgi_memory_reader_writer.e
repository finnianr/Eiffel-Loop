note
	description: "[
		Memory reader/writer that can read Name-Value pair length encoded according to the
		Fast-CGI specification.
		
		See: [https://fast-cgi.github.io/spec#34-name-value-pairs]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 12:58:51 GMT (Monday 30th October 2017)"
	revision: "1"

class
	FCGI_MEMORY_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER

create
	make

feature -- Access

	parameter_length: INTEGER
		local
			i: INTEGER; byte: NATURAL
			done: BOOLEAN
		do
			from i := 1 until done or else i > 4 loop
				byte := read_natural_8
				if i = 1 then
					if byte <= 0x7F then
						done := True
					else
						byte := byte & 0x7F -- Mask out hi-order bit
					end
				end
				Result := Result.bit_shift_left (8) | byte.to_integer_32
				i := i + 1
			end
		end
end
