note
	description: "Generate direction constants code"

	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

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
