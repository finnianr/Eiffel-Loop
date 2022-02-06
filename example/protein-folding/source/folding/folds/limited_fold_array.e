note
	description: "[
		Fold array that permutes a limited number of times up to `upper_iteration_count'
		This object represents a "chunk of work" that a worker thread will have to do.
		`upper_iteration_count' defines how many iterations the thread will perform. 
		If it is set too low the  routine `{EL_WORK_DISTRIBUTER}.do_final' might hang.
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
	LIMITED_FOLD_ARRAY

inherit
	FOLD_ARRAY
		redefine
			is_done
		end

create
	make

feature -- Basic operations

	partial_permute
		-- permute over all valid permutations of fold directions `upper_iteration_count' times
		local
			i, l_count: INTEGER; j: NATURAL
			l_area: like area
		do
			l_area := area; l_count := count
			from j := 1 until is_last_north or else j > upper_iteration_count loop
				i := l_count - 1
				from half_add (i, l_area) until i = 1 loop
					if is_last_north then
						half_add (i - 1, l_area)
					end
					i := i - 1
				end
				j := j + 1
			end
		end

feature {NONE} -- Implementation

	is_done (iteration_count: NATURAL_32): BOOLEAN
		do
			Result := is_last_north or else iteration_count = upper_iteration_count
		end

feature -- Constants

	upper_iteration_count: NATURAL_32 = 100_000

end
