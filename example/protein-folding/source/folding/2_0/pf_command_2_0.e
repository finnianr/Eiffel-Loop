note
	description: "[
		Implementation of [$source PROTEIN_FOLDING_COMMAND_2_0] with a grid conforming to [$source GRID_2_X]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:50:49 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	PF_COMMAND_2_0 [G -> GRID_2_X create make end]

inherit
	PROTEIN_FOLDING_COMMAND_2_0 [G]

create
	make, default_create

feature -- Constants

	description: STRING
		do
			Result := "[
				Test optimised calculation of HP sequences in two-dimensional grid using single thread
			]"
		end

feature {NONE} -- Implemenation

	calc_losses (a_fold: like new_fold; iteration_count: NATURAL_32)
		do
			print_progress (iteration_count)
			grid.calculate (a_fold)
			update_minimum_loss (a_fold)
--			log_losses (fold_string (a_fold), fold.grid_used_has_zero, fold.losses, minimum_loss, fold_list.count)
		end

	gen_folds
		do
			log.enter ("gen_folds")
			fold.permute (Current)
			log.exit
		end

	initialize
		do
			fold := new_fold; grid := new_grid
			grid.calculate (fold)
			calc_losses (fold, 1)
		end

feature {PROTEIN_FOLDING_COMMAND} -- Internal attributes

	fold: like new_fold

	grid: GRID_2_X

end