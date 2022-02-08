note
	description: "Generate direction constants code"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:49:36 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	DIRECTION_ROUTINES

inherit
	FS_DIRECTION_CONSTANTS

feature {NONE} -- Implementation

	direction_letter (a_item: NATURAL_64): CHARACTER
		do
			inspect a_item
				when N then
					Result := 'N'
				when S then
					Result := 'S'
				when E then
					Result := 'E'
				when W then
					Result := 'W'
			else
				Result := '?'
			end
		end

	letter_as_natural_64 (d: CHARACTER): NATURAL_64
		do
			inspect d
				when 'N' then
					Result := N
				when 'S' then
					Result := S
				when 'E' then
					Result := E
				when 'W' then
					Result := W
			else
			end
		end

end