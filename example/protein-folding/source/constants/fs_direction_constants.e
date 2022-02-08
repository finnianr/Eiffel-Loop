note
	description: "Constants for class FOLD_SEQUENCE"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

class
	FS_DIRECTION_CONSTANTS

feature {NONE} -- Directions

	N: NATURAL_64 = 0b001

	N_N: NATURAL_64 = 0b001_001

	N_E: NATURAL_64 = 0b001_011

	N_W: NATURAL_64 = 0b001_100

	S: NATURAL_64 = 0b010

	S_E: NATURAL_64 = 0b010_011

	S_W: NATURAL_64 = 0b010_100

	S_S: NATURAL_64 = 0b010_010

	E: NATURAL_64 = 0b011

	E_E: NATURAL_64 = 0b011_011

	E_N: NATURAL_64 = 0b011_001

	E_S: NATURAL_64 = 0b011_010

	W: NATURAL_64 = 0b100

	W_N: NATURAL_64 = 0b100_001

	W_W: NATURAL_64 = 0b100_100

	W_S: NATURAL_64 = 0b100_010

feature {NONE} -- Constants

	Direction_mask: NATURAL_64	= 0b111_111

	Direction_first_mask: NATURAL_64	= 0b111
		-- masks out first direction in double direction

	Bit_count: INTEGER = 6;

end