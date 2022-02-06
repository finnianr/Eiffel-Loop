note
	description: "Constants for class FOLD_SEQUENCE"
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
