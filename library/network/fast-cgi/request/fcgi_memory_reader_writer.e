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
	date: "2021-06-16 8:16:57 GMT (Wednesday 16th June 2021)"
	revision: "4"

class
	FCGI_MEMORY_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER
		rename
			make_big_endian as make
		end

create
	make

feature -- Access

	parameter_length: INTEGER
		local
			i, pos: INTEGER; byte: NATURAL
			done: BOOLEAN
		do
			if attached buffer as buf then
				pos := count
				from i := 1 until done or else i > 4 loop
					byte := buf.read_natural_8 (pos); pos := pos + 1
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
				count := pos
			end
		end

end