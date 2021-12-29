note
	description: "Character 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:37:07 GMT (Sunday 26th December 2021)"
	revision: "4"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	CHARACTER_PROPERTY

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

feature {NONE} -- Constants

	Max_ascii_character: CHARACTER_32 = '%/0x7F/'
end