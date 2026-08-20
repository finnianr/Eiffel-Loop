note
	description: "Routines to query memory at pointer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-07-27 10:09:20 GMT (Monday 27th July 2026)"
	revision: "15"

class
	EL_MEMORY_ROUTINES

feature -- Status query

	frozen is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

feature {NONE} -- Measurement

	frozen c_string_length (c_str: POINTER; character_width: INTEGER): INTEGER
		local
			n_8: NATURAL_8; n_16: NATURAL_16; n_32: NATURAL_32
			found: BOOLEAN; i: INTEGER
		do
			from until found loop
				inspect character_width
					when {PLATFORM}.Natural_8_bytes then
						($n_8).memory_copy (c_str + i, character_width)
						found := n_8 = 0

					when {PLATFORM}.Natural_16_bytes then
						($n_16).memory_copy (c_str + i, character_width)
						found := n_16 = 0

					when {PLATFORM}.Natural_32_bytes then
						($n_32).memory_copy (c_str + i, character_width)
						found := n_32 = 0
				else
					found := True
				end
				i := i + character_width
			end
			Result := i // character_width - 1
		end

	frozen c_byte_is_one (a_bytes: POINTER; a_offset: INTEGER): BOOLEAN
			-- Is the byte at `a_offset` in the byte array `a_bytes` equal to 1?
		require
			pointer_attached: is_attached (a_bytes)
		external
			"C inline"
		alias
			"[
				return (EIF_BOOLEAN) (((unsigned char *) $a_bytes) [$a_offset] == 1);
			]"
		end

	frozen c_set_boolean_item (bool_array: POINTER; a_offset: INTEGER; a_value: BOOLEAN)
			-- Set the item at `a_offset` in the boolean array `bool_array` to `a_value`
		require
			pointer_attached: is_attached (bool_array)
		external
			"C inline"
		alias
			"((EIF_BOOLEAN *) $bool_array) [$a_offset] = $a_value;"
		end

end
