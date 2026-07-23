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

	STRING_HANDLER
		undefine
			default_create, copy, is_equal, out
		end

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

	add_string (str: STRING_8)
		do
			add_characters (str.area, 0, str.count - 1)
		end
end
