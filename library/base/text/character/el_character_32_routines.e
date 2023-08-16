note
	description: "Expanded class of [$source CHARACTER_32] routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 9:34:26 GMT (Monday 7th August 2023)"
	revision: "12"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
	EL_CHARACTER_ROUTINES [CHARACTER_32]

	EL_32_BIT_IMPLEMENTATION

	EL_EXPANDED_ROUTINES

	EL_UNICODE_PROPERTY

	EL_SHARED_UTF_8_SEQUENCE

feature -- Basic operations

	write_utf_8 (uc: CHARACTER_32; writeable: EL_WRITABLE)
		local
			sequence: like Utf_8_sequence
		do
			sequence := Utf_8_sequence
			sequence.set (uc)
			sequence.write (writeable)
		end

feature -- Area query

	is_i_th_eiffel_identifier (area: SPECIAL [CHARACTER_32]; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		local
			uc: CHARACTER_32
		do
			uc := area [i]
			if uc.is_character_8 then
				Result := is_valid_eiffel_case (uc.to_character_8, case_code, first_i)
			end
		end

feature {NONE} -- Implementation

	same_caseless_character (a, b: CHARACTER_32): BOOLEAN
		do
			Result := to_lower (a) = to_lower (b)
		end

feature {NONE} -- Constants

	Max_ascii_character: CHARACTER_32 = '%/0x7F/'
end