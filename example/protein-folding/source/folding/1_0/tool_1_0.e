note
	description: "Refactored utility methods from class PF_HP"
	author: "Gerrit Leder"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	TOOL_1_0

create
	make

feature {ANY} -- Initialization

	calc_losses (grid: GRID_1_0; i: INTEGER; seq: PF_BOOL_STRING; fold: STRING): INTEGER
			--check grid at position (i, i) set to (0, 0) for losses at each position of the folded sequence
			--Gives sum of losses at each position
		local
			loss: INTEGER
		do
			loss := 9999
			if grid.used.has (zero) then
				loss := grid.calc_losses (i, i, fold)
			end
			Result := loss
		end

	compare_loss_min_add_fold (grid: GRID_1_0; loss, min: INTEGER; fold: STRING; folds: LINKED_LIST [STRING]): LINKED_LIST [STRING]
			--Based on comparison of loss and minimal losses, eventually clear all folds, and add fold to folds
		local
			local_folds: LINKED_LIST [STRING]
		do
			create local_folds.make
			local_folds.compare_objects
			local_folds := folds.twin
			if grid.used.has (zero) then
				if loss = min then
					local_folds.extend (fold.twin)
						--local_folds := folds.twin
					check
						local_folds.has (fold.twin)
					end
						--losses.extend (loss)
				end
				if loss < min then
						--create folds.make
						--create losses.make
					create local_folds.make
					local_folds.compare_objects
					local_folds.extend (fold.twin)
					check
						local_folds.has (fold.twin)
					end
						--losses.extend (loss)
						--min := loss
				end
			end
			Result := local_folds
		end

	convert_str_bool_string (a_strseq: STRING): PF_BOOL_STRING
			--Given a bit string of values '0's and '1's return a sequence of values False and True
		local
			a_seq: PF_BOOL_STRING
			i: INTEGER
		do
			create a_seq.make (a_strseq.count)
			from
				i := 1
			until
				i = a_strseq.count
			loop
					--io.put_string (i.out)
					--io.put_string ("%N")
				i := i + 1
			end
			from
				i := 1
			until
				i = a_strseq.count + 1
			loop
					--io.put_string (i.out)
					--io.put_string ("%N")
				if a_strseq.item (i).is_equal ('1') then
					a_seq.put (True, i)
				else
					a_seq.put (False, i)
				end
				i := i + 1
			end
				--	io.put_string ("%N")
				--	io.put_string (a_fold + "%N")
			Result := a_seq
		end

	embed (grid: GRID_1_0; i: INTEGER; seq: PF_BOOL_STRING; fold: STRING): GRID_1_0
			--Starting at position (i, i) set to (0, 0) of two-dimensional grid,
			--put values of sequence seq according to directions in fold.
		local
			--a_grid : GRID

		do
				--create a_grid.make (seq.count + 1)
				--	 io.put_string ("%N")
				--	 io.put_string (seq.to_string)
				--	 io.put_string ("%N")
			grid.embed (i, i, seq, fold)
				--a_grid := grid.twin

			Result := grid --was a_grid

				--	grid.print_grid

		end -- embedd

	generate_first_fold (strseq: STRING): STRING
			--Give a string of the form 'N...N'
		local
			i: INTEGER
			fold: STRING
		do
			create fold.make (strseq.count - 1)
			fold.compare_objects
			from
				i := 1
			until
				i = strseq.count
			loop
				debug ("TOOL")
					io.put_string (i.out)
					io.put_new_line
				end
				fold.append_character ('N')
				i := i + 1
			end
			Result := fold
		end

	make
			-- Initialization for `Current'.
		do
			zero := False
			one := True
		end

	zero, one: BOOLEAN
		--The values False and True

end
