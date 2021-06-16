note
	description: "Routines for converting IP addresses from [$source STRING_8] to [$source NATURAL_32] and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-16 8:47:47 GMT (Wednesday 16th June 2021)"
	revision: "5"

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

	PLATFORM
		export
			{NONE} all
		undefine
			copy, default_create, is_equal, out
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
			mem.put_natural_32 (ip_number, 0)

			create Result.make (15)
			from i := 1 until i > 4 loop
				if i > 1 then
					Result.append_character ('.')
				end
				Result.append_natural_8 (mem.read_natural_8 (i - 1))
				i := i + 1
			end
		ensure
			reversible: ip_number = to_number (Result)
		end

feature -- Constants

	Loop_back_address: NATURAL = 0x7F_00_00_01

feature {NONE} -- Implementation

	append_byte (byte_string: STRING)
		do
			number := number |<< 8 | byte_string.to_natural_32
		end

feature {NONE} -- Internal attributes

	number: NATURAL

feature {NONE} -- Constants

	Dot: STRING = "."

	Loop_back_one: STRING =  "::1"

	Memory: MANAGED_POINTER
		once
			if is_little_endian then
				create {EL_REVERSE_MANAGED_POINTER} Result.make (4)
			else
				create Result.make (4)
			end
		end

end