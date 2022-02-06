note
	description: "Sets of points around current grid position"

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
	POINT_SET_CONSTANTS

feature {NONE} -- Constants

	Point_N: NATURAL = 0b1000

	Points_E_S: NATURAL = 0b110

	Points_E_S_W: NATURAL = 0b111

	Points_E_W: NATURAL = 0b101

	Points_N_E: NATURAL = 0b1100

	Points_N_E_S: NATURAL = 0b1110

	Points_N_E_W: NATURAL = 0b1101

	Points_N_S: NATURAL = 0b1010

	Points_N_S_W: NATURAL = 0b1011

	Points_N_W: NATURAL = 0b1001

	Points_S_W: NATURAL = 0b11

end
