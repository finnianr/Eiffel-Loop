note
	description: "Character 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:26 GMT (Monday 12th December 2022)"
	revision: "7"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	CHARACTER_PROPERTY

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