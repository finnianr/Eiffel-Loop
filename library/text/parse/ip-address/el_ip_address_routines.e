note
	description: "[
		Routines for converting IP.4 addresses from ${STRING_8} to ${NATURAL_32} and vice-versa
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-13 13:57:44 GMT (Thursday 13th February 2025)"
	revision: "13"

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
		local
			part_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create part_list.make_shared_adjusted (address, '.', 0)
			if attached part_list as list and then list.count = 4 then
				Result := True
				from list.start until list.after or not Result loop
					Result := list.item_is_number
					list.forth
				end
			end
		end

feature -- Conversion

	to_number (address: STRING): NATURAL
		require
			valid_format: is_valid (address)
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

	Dot_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
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