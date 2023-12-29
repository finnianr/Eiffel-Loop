note
	description: "[
		For use with class [$source ZSTRING] which redefines `{READABLE_STRING_GENERAL}.code' as `z_code'.
		A `z_code' is a hybrid of a Latin-x or Windows-x encoding and a UCS4 encoding.
		(We only refer to "latin" from here on)
		
		Occassionaly a unicode character might clash with the range 0 .. 255 reserved for latin encodings.
		To get around this we set the sign bit to 1 to distinguish it. We can do this because the sign bit is
		unused in UCS4 unicode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-29 11:01:16 GMT (Friday 29th December 2023)"
	revision: "19"

class
	EL_ZCODE_CONVERSION

feature {EL_ZCODEC} -- Implementation

	frozen unicode_to_z_code (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		do
			if unicode < 0x100 then
				Result := Sign_bit | unicode
			else
				Result := unicode
			end
		ensure
			reversbile: z_code_to_unicode (Result) = unicode
		end

	frozen z_code_to_unicode (z_code: NATURAL): NATURAL
		-- masks out sign bit used to distinguish UCS4 from latin encoding
		require
			not_for_single_byte: z_code > 0xFF
		do
			Result := z_code & Sign_bit_mask
		end

feature {EL_OUTPUT_MEDIUM} -- Constants

	Control_0: CHARACTER = '%U'
		-- first ASCII character

	Control_25: CHARACTER = '%/025/'
		-- `Substitute - 1'

	Control_27: CHARACTER = '%/027/'
		-- `Substitute + 1'

	Max_ascii_code: INTEGER = 0x7F
		-- last ASCII character
		-- After this point different Latin and Window character sets start to diverge
		-- (Apart from some control characters)

	Max_ascii: CHARACTER = '%/0x7F/'
		-- After this point different Latin and Window character sets start to diverge
		-- (Apart from some control characters)

	Max_8_bit_code: INTEGER = 0xFF

	One_bit: NATURAL = 1

	Replacement_character: CHARACTER_32 = '%/0xFFFD/'
		-- used to replace an unknown, unrecognized, or unrepresentable character

	Sign_bit: NATURAL = 0x8000_0000

	Sign_bit_mask: NATURAL = 0x7FFF_FFFF

	Substitute_code: INTEGER = 26

	Substitute: CHARACTER = '%/026/'
		-- The substitute character SUB
		-- A substitute character (SUB) is a control character that is used in the place of a character that is
		-- recognized to be invalid or in error or that cannot be represented on a given device.
		-- See https://en.wikipedia.org/wiki/Substitute_character

end