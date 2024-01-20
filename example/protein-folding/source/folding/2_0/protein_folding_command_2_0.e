note
	description: "[
		Prediction of protein-folding in the 2D HP Model for grids conforming to ${GRID_2_X}.
		Version 2.0
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	PROTEIN_FOLDING_COMMAND_2_0 [G -> GRID_2_X create make end]

inherit
	PROTEIN_FOLDING_COMMAND
		export
			{FOLD_ARRAY} print_progress
		redefine
			make
		end

	BOOLEAN_CONSTANTS

	DIRECTION_CONSTANTS

feature {EL_COMMAND_LINE_APPLICATION} -- Initialization

	initialize
		deferred
		end

	make (a_strseq: like strseq; a_output_path: FILE_PATH)
		do
			Precursor (a_strseq, a_output_path)

			minimum_loss := 9999

			create fold_list.make
			create seq.make (strseq.count)

			seq := convert_str_bool_string (strseq)
			seq_count := seq.count
			initialize
		end

feature -- Basic operations

	gen_folds
		deferred
		end

	print_folds
		do
			output.put_new_line
			output.put_new_line
		end

	print_indices
		do
			output.put_new_line
			output.put_new_line
		end

	print_item (fold: STRING; index: INTEGER)
		do
			output.put_character_8 ('#')
			output.put_integer (index)
			output.put_character_8 (' ')
			output.put_string_8 (fold)
			output.put_new_line
		end

	print_losses
		do
			output.put_new_line
			output.put_new_line
		end

	print_min_fold
		do
			sorted_fold_list.do_all_with_index (agent print_item)
		end

feature {FOLD_ARRAY} -- Basic operations

	calc_losses (fold: like new_fold; iteration_count: NATURAL_32)
		deferred
		end

feature {NONE} -- Implementation

	add_fold_crc (fold: like new_fold)
		do
			fold.update_crc (crc)
		end

	convert_str_bool_string (a_strseq: STRING): PF_BOOL_STRING
			--Given a bit string of values '0's and '1's return a sequence of values False and True
		local
			i: INTEGER
		do
			create Result.make (a_strseq.count)
			from
				i := 1
			until
				i = a_strseq.count
			loop
				i := i + 1
			end
			from
				i := 1
			until
				i = a_strseq.count + 1
			loop
				if a_strseq.item (i).is_equal ('1') then
					Result.put (True, i)
				else
					Result.put (False, i)
				end
				i := i + 1
			end
		end

	fold_string (a_fold: like new_fold): STRING
		local
			i: INTEGER; c: CHARACTER
		do
			create Result.make (a_fold.count)
			from i := 1 until i > a_fold.count loop
				inspect a_fold [i]
					when N then
						c := 'N'
					when S then
						c := 'S'
					when E then
						c := 'E'
					when W then
						c := 'W'
				else
				end
				Result.append_character (c)
				i := i + 1
			end
		end

	sorted_fold_list: EL_SORTABLE_ARRAYED_LIST [STRING]
		do
			create Result.make (fold_list.count)
			across fold_list as fold loop
				Result.extend (fold_string (fold.item))
			end
			Result.compare_objects
			Result.ascending_sort
		end

	update_minimum_loss (fold: like new_fold)
		do
			if fold.grid_used_has_zero then
				if fold.losses = minimum_loss then
					fold_list.extend (fold.twin)
					check
						fold_list.has (fold)
					end
				elseif fold.losses < minimum_loss then
					fold_list.wipe_out
					fold_list.extend (fold.twin)
					check
						fold_list.has (fold)
					end
					minimum_loss := fold.losses
				end
			end
		end

feature {FOLD_ARRAY} -- Factory

	new_fold: FOLD_ARRAY
		do
			create Result.make (strseq)
		end

	new_grid: GRID_2_X
		do
			create {G} Result.make (seq)
		end

feature {PROTEIN_FOLDING_COMMAND} -- Internal attributes

	fold_list: FOLD_ARRAY_LIST

	seq: PF_BOOL_STRING

	seq_count: INTEGER

end