note
	description: "Character 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-20 12:06:06 GMT (Wednesday 20th January 2021)"
	revision: "3"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
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