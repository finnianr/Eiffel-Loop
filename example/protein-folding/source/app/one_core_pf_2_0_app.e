note
	description: "[
		PF_HP Ver 1.0: brute force proteinfolding in the 2D HP Model
		Single-core model (thread)
	]"

	usage: "[
		pf_hp -pf2 [-logging] [-sequence <protein sequence as binary number>] [-out <output path>]
	]"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	ONE_CORE_PF_2_0_APP

inherit
	PROTEIN_FOLDING_APPLICATION [PF_COMMAND_2_0 [GRID_2_5]]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Constants

	Option_name: STRING = "pf2"

end



