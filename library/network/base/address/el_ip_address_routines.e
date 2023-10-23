note
	description: "Routines for converting IP addresses from [$source STRING_8] to [$source NATURAL_32] and vice-versa"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-15 7:43:22 GMT (Sunday 15th October 2023)"
	revision: "9"

class
	EL_IP_ADDRESS_ROUTINES

inherit
	PLATFORM
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

feature -- Contract Support

	is_valid (address: STRING): BOOLEAN
		do
			if attached address.split ('.') as list and then list.count = 4 then
				Result := across list as part all part.item.count <= 3 end
			end
		end

feature -- Conversion

	to_number (address: STRING): NATURAL
		do
			if address ~ Loop_back_one then
				Result := Loop_back_address

			elseif address.occurrences ('.') = 3 then
				Dot_split.set_target (address)
				number := 0
				across Dot_split as list loop
					append_byte (list.item)
				end
				Result := number
			end
		ensure
			reversible: address /= Loop_back_one implies address ~ to_string (Result)
		end

	to_string (ip_number: NATURAL): STRING
		do
			create Result.make (15)
			append_to_string (ip_number, Result)
		ensure
			reversible: ip_number = to_number (Result)
		end

feature -- Basic operations

	append_to_string (ip_number: NATURAL; output: STRING)
		-- append `ip_number' to `output' string as IP 4 format
		local
			mem: like Memory; i: INTEGER
		do
			mem := Memory
			mem.put_natural_32 (ip_number, 0)
			from i := 1 until i > 4 loop
				if i > 1 then
					output.append_character ('.')
				end
				output.append_natural_8 (mem.read_natural_8 (i - 1))
				i := i + 1
			end
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

	Dot_split: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make (Empty_string_8, '.')
		end

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