note
	description: "Digest for CRC-32/ISO-HDLC"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	date: "2026-06-29 6:31:14 GMT (Monday 29th June 2026)"
	revision: "1"

class
	EL_CRC_32_DIGEST

inherit
	NATURAL_64_REF
		export
			{NONE} all
		redefine
			default_create, out
		end

	EL_ZLIB_CRC_32_API
		export
			{NONE} all
		undefine
			default_create, copy, is_equal, out
		end

	PLATFORM
		export
			{NONE} all
		undefine
			default_create, copy, is_equal, out
		end

	STRING_HANDLER
		undefine
			default_create, copy, is_equal, out
		end

	EL_CRC_32_CONSTANTS

create
	default_create

convert
	to_integer_32: {INTEGER_32}

feature {NONE} -- Initialization

	default_create
		do
			set_item (CRC_initial)
		end

feature -- Access

	out: STRING
			-- Printable representation of value.
		do
			create Result.make (20)
			Result.append_natural_32 (value)
		end

	value: NATURAL
		do
			inspect item
				when CRC_initial then
					Result := 0
			else
				Result := item.to_natural_32
			end
		end

feature -- Element change

	add_boolean (flag: BOOLEAN)
		do
			add_bytes ($flag, Boolean_bytes)
		end

	add_bytes (byte_array: POINTER; count: INTEGER)
		local
			l_value: NATURAL
		do
			if count > 0 then
				inspect item
					when CRC_initial then
						l_value := c_crc_32_seed
				else
					l_value := item.to_natural_32
				end
				set_item (c_crc_32 (l_value, byte_array, count))
			end
		end

	add_characters (area: SPECIAL [CHARACTER]; lower, upper: INTEGER)
		do
			if upper >= lower then
				set_item (characters_crc_32 (item, area, lower, upper))
			end
		end

	add_character_buffer (buffer: EL_CHARACTER_8_BUFFER; lower, upper: INTEGER)
		do
			add_managed_pointer (buffer, lower, upper)
		end

	add_managed_pointer (area: MANAGED_POINTER; lower, upper: INTEGER)
		do
			if upper >= lower then
				set_item (managed_pointer_crc_32 (item, area, lower, upper))
			end
		end

	add_integer_32 (integer: INTEGER_32)
		do
			add_bytes ($integer, Integer_32_bytes)
		end

	add_string (str: STRING_8)
		do
			add_characters (str.area, 0, str.count - 1)
		end

	reset
		do
			set_item (Crc_initial)
		end

feature {NONE} -- Implementation

	characters_crc_32 (a_value: NATURAL_64; area: SPECIAL [CHARACTER]; lower, upper: INTEGER): NATURAL
		-- continue adding to a previously calculated CRC-32/ISO-HDLC `value'
		require
			lower_non_negative: lower >= 0
			lower_in_bound: lower < area.count
			lower_not_too_big: lower <= upper + 1
			upper_valid: upper < area.count
		local
			l_value: NATURAL
		do
			inspect a_value
				when CRC_initial then
					l_value := c_crc_32_seed
			else
				l_value := a_value.to_natural_32
			end
			Result := c_crc_32 (l_value, area.item_address (lower), upper - lower + 1)
		end

	managed_pointer_crc_32 (a_value: NATURAL_64; memory: MANAGED_POINTER; lower, upper: INTEGER): NATURAL
		-- continue adding to a previously calculated CRC-32/ISO-HDLC `value'
		require
			lower_non_negative: lower >= 0
			lower_in_bound: lower < memory.count
			lower_not_too_big: lower <= upper + 1
			upper_valid: upper < memory.count
		local
			l_value: NATURAL
		do
			inspect a_value
				when CRC_initial then
					l_value := c_crc_32_seed
			else
				l_value := a_value.to_natural_32
			end
			Result := c_crc_32 (l_value, memory.item + lower, upper - lower + 1)
		end

end
