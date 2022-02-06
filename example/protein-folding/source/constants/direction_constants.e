note
	description: "Summary description for {DIRECTION_CONSTANTS}."
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
	DIRECTION_CONSTANTS

feature {NONE} -- Directions

	N: NATURAL_8 = 0b1

	S: NATURAL_8 = 0b10

	E: NATURAL_8 = 0b11

	W: NATURAL_8 = 0b100

feature {NONE} -- Directions combined

	N_N: NATURAL_8 = 0b001001

	N_E: NATURAL_8 = 0b001011

	N_W: NATURAL_8 = 0b001100

	S_S: NATURAL_8 = 0b010010

	S_E: NATURAL_8 = 0b010011

	S_W: NATURAL_8 = 0b010100

	E_E: NATURAL_8 = 0b011011

	E_N: NATURAL_8 = 0b011001

	E_S: NATURAL_8 = 0b011010

	W_W: NATURAL_8 = 0b100100

	W_N: NATURAL_8 = 0b100001

	W_S: NATURAL_8 = 0b100010;

end
