note
	description: "Prediction of protein-folding in the 2D HP Model version 1.0"
	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:50:42 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	PF_COMMAND_1_0

inherit
	PROTEIN_FOLDING_COMMAND
		redefine
			make
		end

create
	make

feature {EL_COMMAND_LINE_APPLICATION} -- Initialization

	make (a_strseq: like strseq; a_output_path: like output_path)
		do
			Precursor (a_strseq, a_output_path)

			create tool.make
			minimum_loss := 9999; loss := 9999
			number := 0

			create folds.make
			folds.compare_objects
			--create losses.make
			--losses.compare_objects
			--create indices.make --from_collection(losses)

			create fold.make (strseq.count - 1) --was - 1
			fold.compare_objects
			create seq.make (strseq.count)

				--create zero.make

				--create Bit sequence seq:
			seq := tool.convert_str_bool_string (strseq)
				--create first fold:
			fold := tool.generate_first_fold (strseq)
			zero := False
			one := True
			seq_count := seq.count

			create grid.make (seq_count + 1)
			grid := tool.embed (grid, 0, seq, fold)
			loss := tool.calc_losses (grid, 0, seq, fold)
			folds := tool.compare_loss_min_add_fold (grid, loss, minimum_loss, fold, folds)
		end

feature -- Constants

	Description: STRING = "Test distributed calculation of HP sequences in two-dimensional grid"

feature -- Basic operations

	gen_folds
		local
			k, j: INTEGER; iteration_count: NATURAL_32
			c: BOOLEAN
		do
			log.enter ("gen_folds")
			c := False; j := 0

			if loss < minimum_loss then
				minimum_loss := loss
				check folds.has (fold) end
			end
			from
				k := 0
			until
				j = 1
			loop
				if fold.count > 1 then
					from
						k := fold.count - 1
						c := half_add (fold.count)
					until
						k = 1 --was 1
					loop
						if c.is_equal (one) then
							c := half_add (k)
						end
						k := k - 1
					end
				end
				if c.is_equal (one) then
					j := 1
				end
					--brute force enumeration of folds:
				if j = 0 then
					iteration_count := iteration_count + 1
					print_progress (iteration_count)

					create grid.make (seq_count + 1)
					grid := tool.embed (grid, 0, seq, fold)
					loss := tool.calc_losses (grid, 0, seq, fold)
					folds := tool.compare_loss_min_add_fold (grid, loss, minimum_loss, fold, folds)
					if loss < minimum_loss then
						minimum_loss := loss
						check folds.has (fold) end
						check folds.count = 1 end
					end
					log_losses (fold, grid.used.has (zero), loss, minimum_loss, folds.count)
				end
			end
			log.exit
		end

	half_add (count: INTEGER): BOOLEAN
		local
			b: BOOLEAN
		do
				--create b.make(1)
			b := False
			if fold.item (count) = 'N' then
				fold.put ('E', count)
					--   b.put_0(1)
				b := False
				Result := b
			elseif fold.item (count) = 'E' then
				fold.put ('S', count)
					-- b.put_0(1)
				b := False
				Result := b
			elseif fold.item (count) = 'S' then
				fold.put ('W', count)
					--b.put_0(1)
				b := False
				Result := b
			elseif fold.item (count) = 'W' then
				fold.put ('N', count)
					--b.put_1(1)
				b := True
				Result := b
			end
		end

	print_folds
		do
			output.put_new_line
				--folds.fill_tagged_out_memory
				--io.put_string(folds.out)
			output.put_new_line
		end -- print_folds

	print_indices
		do
			output.put_new_line
				-- indices.fill_tagged_out_memory
				--io.put_string(indices)
			output.put_new_line
		end -- print_indices

	print_item (item: STRING)
		do
			number := number + 1
			output.put_character_8 ('#')
			output.put_integer (number)
			output.put_character_8 (' ')
			output.put_string (item.string)
			output.put_character_8 ('%N')
		end -- print_item

	print_losses
		do
			output.put_new_line
				--losses.fill_tagged_out_memory
				--io.put_string(losses)
			output.put_new_line
		end -- print_losses

	print_min_fold
		local
			sorted: EL_SORTABLE_ARRAYED_LIST [STRING]
		do
			create sorted.make_sorted (folds)
			sorted.do_all (agent print_item)
		end

feature {NONE} -- Implementation

	fold_as_string: STRING
		do
			Result := fold
		end

feature {NONE} -- Internal attributes

	fold: STRING

	folds: LINKED_LIST [STRING]

	--losses: LINKED_LIST [INTEGER];

	grid: GRID_1_0

	iseq: INTEGER

	loss: INTEGER;
	number: INTEGER
		--Constructor:

	seq: PF_BOOL_STRING

	seq_count: INTEGER

	tool: TOOL_1_0

	zero, one: BOOLEAN

end