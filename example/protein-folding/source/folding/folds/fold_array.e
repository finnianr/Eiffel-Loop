note
	description: "Sequence of fold directions"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:50:06 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	FOLD_ARRAY

inherit
	ARRAY [NATURAL_8]
		rename
			make as make_array
		end

	DIRECTION_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (strseq: STRING)
		do
			make_filled (N, 1, strseq.count - 1)
		end

feature -- Access

	grid_used_has_zero: BOOLEAN

	losses: INTEGER

feature -- Element change

	set_grid_used_has_zero (a_grid_used_has_zero: like grid_used_has_zero)
		do
			grid_used_has_zero := a_grid_used_has_zero
		end

	set_losses (a_losses: like losses)
		do
			losses := a_losses
		end

	set_data (other: FOLD_ARRAY)
		require
			same_count: count = other.count
		do
			area.copy_data (other.area, 0, 0, count)
		end

feature -- Status query

	is_last_north: BOOLEAN

feature -- Basic operations

	permute (pf: PROTEIN_FOLDING_COMMAND_2_0 [GRID_2_X])
		-- permute over all valid permutations of fold directions
		local
			i, l_count: INTEGER; iteration_count: NATURAL_32
			l_area: like area
		do
			l_area := area; l_count := count
			from until is_done (iteration_count) loop
				i := l_count - 1
				from half_add (i, l_area) until i = 1 loop
					if is_last_north then
						half_add (i - 1, l_area)
					end
					i := i - 1
				end
				if not is_last_north then
					iteration_count := iteration_count + 1
					calc_losses (pf, iteration_count)
				end
			end
		end

	update_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		local
			i, l_count: INTEGER; c: CHARACTER
			l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				inspect l_area [i]
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
				crc.add_character_8 (c)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	calc_losses (pf: PROTEIN_FOLDING_COMMAND_2_0 [GRID_2_X]; iteration_count: NATURAL_32)
		do
			pf.calc_losses (Current, iteration_count)
		end

	half_add (i: INTEGER; a_area: like area)
		do
			is_last_north := False
			inspect a_area.item (i)
				when N then
					a_area.put (E, i)
				when E then
					a_area.put (S, i)
				when S then
					a_area.put (W, i)
			else
				a_area.put (N, i)
				is_last_north := True
			end
		end

	is_done (iteration_count: NATURAL_32): BOOLEAN
		do
			Result := is_last_north
		end

end