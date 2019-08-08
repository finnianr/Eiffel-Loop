note
	description: "Routines for converting ip addresses from `STRING' to `NATURAL_32' and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 14:04:38 GMT (Monday 5th August 2019)"
	revision: "2"

class
	EL_IP_ADDRESS_ROUTINES

inherit
	EL_SPLIT_STRING_LIST [STRING]
		rename
			make as make_list,
			make_empty as make
		export
			{NONE} all
		end

create
	make

feature -- Conversion

	to_number (address: STRING): NATURAL
		do
			if address ~ Loop_back_one then
				Result := Loop_back_address
			else
				set_string (address, Dot)
				if count = 4 then
					number := 0
					do_all (agent append_byte)
					Result := number
				end
			end
		ensure
			reversible: address /= Loop_back_one implies address ~ to_string (Result)
		end

	to_string (ip_number: NATURAL): STRING
		local
			mem: like Memory
			i: INTEGER
		do
			mem := Memory
			mem.set_for_writing
			mem.reset_count
			mem.write_natural_32 (ip_number)

			mem.reset_count
			mem.set_for_reading

			create Result.make (15)
			from i := 1 until i > 4 loop
				if i > 1 then
					Result.append_character ('.')
				end
				Result.append_natural_8 (mem.read_natural_8)
				i := i + 1
			end
		ensure
			reversible: ip_number = to_number (Result)
		end

feature {NONE} -- Implementation

	append_byte (byte_string: STRING)
		do
			number := number |<< 8 | byte_string.to_natural_32
		end

feature {NONE} -- Internal attributes

	number: NATURAL

feature {NONE} -- Constants

	Dot: STRING = "."

	Loop_back_address: NATURAL = 0x7F_00_00_01

	Loop_back_one: STRING =  "::1"

	Memory: EL_MEMORY_READER_WRITER
		once
			create Result.make
		end

end
