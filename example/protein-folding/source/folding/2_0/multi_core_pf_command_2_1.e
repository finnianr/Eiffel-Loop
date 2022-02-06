note
	description: "[
		Implementation of [$source MULTI_CORE_PF_COMMAND] with a grid conforming to [$source GRID_2_X]
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
			done_list: ARRAYED_LIST [like new_folder]
			distributer: like new_distributer
			iteration_count: NATURAL_32; folder: like new_folder
		do
			log.enter ("gen_folds")
			distributer := new_distributer
			create done_list.make (11)

			from until fold.is_last_north loop
				if pool.is_empty then
					folder := new_folder
				else
					folder := pool.item
					pool.remove
				end
				folder.fold.set_data (fold)
				distributer.wait_apply (agent folder.gen_folds)
				distributer.collect (done_list)
				merge_minimum_losses (done_list)

				fold.partial_permute
				iteration_count := iteration_count + 1
				print_progress (iteration_count)
			end
			distributer.do_final
			distributer.collect_final (done_list)
			merge_minimum_losses (done_list)
			log.exit
		end

	merge_minimum_losses (list: ARRAYED_LIST [like new_folder])
		local
			l_fold_list: like fold_list
		do
			from list.start until list.after loop
				l_fold_list := list.item.fold_list
				from l_fold_list.start until l_fold_list.after loop
					if attached {LIMITED_FOLD_ARRAY} l_fold_list.item as l_fold then
						if l_fold.grid_used_has_zero and then l_fold.losses <= minimum_loss and then not fold_list.has (l_fold) then
							update_minimum_loss (l_fold)
						end
--						if Logging.is_active then
--							log_losses (fold_string (l_fold), l_fold.grid_used_has_zero, l_fold.losses, minimum_loss, fold_list.count)
--						end
					end
					l_fold_list.forth
				end
				pool.put (list.item)
				list.remove
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








