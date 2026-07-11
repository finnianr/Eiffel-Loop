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
		redefine
			default_create
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

feature -- Element change

	add_bytes (byte_array: POINTER; count: INTEGER)
		local
			value: NATURAL
		do
			inspect item
				when CRC_initial then
					value := c_crc_32_seed
			else
				value := item.to_natural_32
			end
			set_item (c_crc_32 (value, byte_array, count))
		end

	add_characters (area: SPECIAL [CHARACTER]; lower, upper: INTEGER)
		do
			set_item (characters_crc_32 (item, area, lower, upper))
		end

	add_string (str: STRING_8)
		do
			set_item (characters_crc_32 (item, str.area, 0, str.count - 1))
		end
end
