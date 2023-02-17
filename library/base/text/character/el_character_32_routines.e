note
	description: "Character 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-17 13:36:15 GMT (Friday 17th February 2023)"
	revision: "9"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_UNICODE_PROPERTY

	EL_SHARED_UTF_8_SEQUENCE

feature -- Status query

	is_ascii_area (area: SPECIAL [CHARACTER_32]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `area' are in the ASCII character set range: 0 .. 127
		local
			i: INTEGER
		do
			Result := True
			from i := start_index until not Result or else i > end_index loop
				if area [i] > Max_ascii_character then
					Result := False
				else
					i := i + 1
				end
			end
		end

	same_caseless_sub_array (
		area_1, area_2: SPECIAL [CHARACTER_32]; offset_1, offset_2, comparison_count: INTEGER
	): BOOLEAN
		require
			valid_offset_1: area_1.valid_index (offset_1 + comparison_count - 1)
			valid_offset_2: area_2.valid_index (offset_2 + comparison_count - 1)
		local
			i: INTEGER
		do
			Result := True
			from i := 0 until not Result or i = comparison_count loop
				Result := to_lower (area_1 [offset_1 + i]) = to_lower (area_2 [offset_2 + i])
				i := i + 1
			end
		end

feature -- Basic operations

	write_utf_8 (uc: CHARACTER_32; writeable: EL_WRITABLE)
		local
			sequence: like Utf_8_sequence
		do
			sequence := Utf_8_sequence
			sequence.set (uc)
			sequence.write (writeable)
		end

feature {NONE} -- Constants

	Max_ascii_character: CHARACTER_32 = '%/0x7F/'
end