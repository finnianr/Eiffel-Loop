note
	description: "[
		PF_HP Ver 1.0: brute force proteinfolding in the 2D HP Model
		Multi-core model (threads)
	]"

	usage: "[
		pf_hp -pf2_mt [-logging] [-threads <number of threads>] [-sequence <protein sequence as binary number>] [-out <output path>]
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
	MULTI_CORE_PF_HP_2_1_APP

inherit
	PROTEIN_FOLDING_APPLICATION [MULTI_CORE_PF_COMMAND_2_1 [GRID_2_5]]
		redefine
			Option_name, default_make, argument_list, new_command
		end

create
	make

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor + optional_argument ("threads", "Maximum number of threads to use", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Default_sequence, default_output_path, 4)
		end

	new_command (sequence: STRING; output_path: FILE_PATH): like command
		do
			create Result.make (sequence, output_path, 8)
		end

feature {NONE} -- Constants

	Option_name: STRING = "pf2_mt"

end


