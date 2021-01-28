note
	description: "[
		For use with class [$source EL_ZSTRING] which redefines `{READABLE_STRING_GENERAL}.code' as `z_code'.
		A `z_code' is a hybrid of a Latin-x or Windows-x encoding and a UCS4 encoding.
		(We only refer to "latin" from here on)
		
		Occassionaly a unicode character might clash with the range 0 .. 255 reserved for latin encodings.
		To get around this we set the sign bit to 1 to distinguish it. We can do this because the sign bit is
		unused in UCS4 unicode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-28 13:55:55 GMT (Thursday 28th January 2021)"
	revision: "6"

class
	EL_ZCODE_CONVERSION

feature {EL_ZCODEC} -- Implementation

	frozen unicode_to_z_code (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		do
			if unicode <= 0xFF then
				Result := Sign_bit | unicode
			else
				Result := unicode
			end
		end

	frozen z_code_to_unicode (z_code: NATURAL): NATURAL
		-- masks out sign bit used to distinguish UCS4 from latin encoding
		require
			not_for_single_byte: z_code > 0xFF
		do
			Result := z_code & Sign_bit_mask
		end

	frozen area_z_code (a_string_area: SPECIAL [CHARACTER]; unencoded: EL_ZSTRING_INDEXABLE; i: INTEGER): NATURAL
			-- code which can be latin or unicode depending on presence of unencoded characters
		local
			c: CHARACTER
		do
			c := a_string_area [i]
			if c = Unencoded_character then
				Result := unencoded.z_code (i + 1)
			else
				Result := c.natural_32_code
			end
		end

feature {EL_OUTPUT_MEDIUM} -- Constants

	Sign_bit: NATURAL = 0x8000_0000

	Sign_bit_mask: NATURAL = 0x7FFF_FFFF

	Unencoded_character: CHARACTER = '%/026/'
		-- The substitute character SUB
		-- A substitute character (SUB) is a control character that is used in the place of a character that is
		-- recognized to be invalid or in error or that cannot be represented on a given device.
		-- See https://en.wikipedia.org/wiki/Substitute_character

end