note
	description: "[
		Command line interface to test sets
		
			[$source LIMITED_ARRAY_TEST_SET]
			[$source BOOLEAN_GRID_TEST_SET]
			[$source PROTEIN_FOLDING_TEST_SET]
	]"
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
	AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		LIMITED_ARRAY_TEST_SET,
		BOOLEAN_GRID_TEST_SET,
		PROTEIN_FOLDING_TEST_SET
	]
	redefine
		log_filter_set
	end

create
	make

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		MULTI_CORE_PF_COMMAND_2_1 [GRID_2_5],

		PF_COMMAND_2_0 [GRID_2_2], PF_COMMAND_2_0 [GRID_2_3], PF_COMMAND_2_0 [GRID_2_4],
		PF_COMMAND_2_0 [GRID_2_5], PF_COMMAND_2_0 [GRID_2_6], PF_COMMAND_2_0 [GRID_2_7],

		PF_COMMAND_1_0
	]
		do
			create Result.make
		end

end





