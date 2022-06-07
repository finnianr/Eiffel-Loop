note
	description: "[
		Implementation of [$source MULTI_CORE_PF_COMMAND] with a grid conforming to [$source GRID_2_X]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-06-07 11:13:04 GMT (Tuesday 7th June 2022)"
	revision: "4"

class
	MULTI_CORE_PF_COMMAND_2_1 [G -> GRID_2_X create make end]

inherit
	MULTI_CORE_PF_COMMAND [LIMITED_PF_COMMAND_2_0 [G]]
		undefine
			make_one_core
		end

	PF_COMMAND_2_0 [G]
		rename
			make as make_one_core
		undefine
			Description, Iterations_per_dot
		redefine
			gen_folds, new_fold
		end

create
	make, make_one_core

feature {NONE} -- Implementation

	gen_folds
		local
			distributer: like new_distributer
			iteration_count: NATURAL_32; folder: like new_folder
		do
			log.enter ("gen_folds")
			distributer := new_distributer
			from until fold.is_last_north loop
				if pool.is_empty then
					folder := new_folder
				else
					folder := pool.item
					pool.remove
				end
				folder.fold.set_data (fold)
				distributer.wait_apply (agent folder.gen_folds)
				distributer.do_with_completed (agent merge_minimum_losses)

				fold.partial_permute
				iteration_count := iteration_count + 1
				print_progress (iteration_count)
			end
			distributer.do_final
			distributer.do_with_completed (agent merge_minimum_losses)
			log.exit
		end

	merge_minimum_losses (folder: like new_folder)
		do
			if attached folder.fold_list as list then
				from list.start until list.after loop
					if attached {LIMITED_FOLD_ARRAY} list.item as l_fold then
						if l_fold.grid_used_has_zero and then l_fold.losses <= minimum_loss and then not fold_list.has (l_fold) then
							update_minimum_loss (l_fold)
						end
--						if Logging.is_active then
--							log_losses (fold_string (l_fold), l_fold.grid_used_has_zero, l_fold.losses, minimum_loss, fold_list.count)
--						end
					end
				end
			end
		end

feature {NONE} -- Factory

	new_fold: LIMITED_FOLD_ARRAY
		do
			create Result.make (strseq)
		end

	new_folder: like pool.item
		do
			create Result.make (strseq, output_path)
		end

end



