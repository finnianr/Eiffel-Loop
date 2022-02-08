note
	description: "Sets of points around current grid position"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

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