note
	description: "[
		Caculates minimum losses for a partial set of fold direction permutations.
		These limited permutations can be assigned to a thread for losses caculations.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:51:05 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	LIMITED_PF_COMMAND_2_0 [G -> GRID_2_X create make end]

inherit
	PF_COMMAND_2_0 [G]
		export
			{PROTEIN_FOLDING_COMMAND} fold, fold_list, minimum_loss
		redefine
			new_fold, gen_folds, calc_losses, print_progress
		end

create
	make

feature -- Basic operations

	gen_folds
		do
			fold.permute (Current)
		end

feature {NONE} -- Implementation

	new_fold: LIMITED_FOLD_ARRAY
		do
			create Result.make (strseq)
		end

	calc_losses (a_fold: like new_fold; iteration_count: NATURAL_32)
		do
			grid.calculate (a_fold)
			update_minimum_loss (a_fold)
		end

	print_progress (iteration_count: NATURAL_32)
		do
		end

end