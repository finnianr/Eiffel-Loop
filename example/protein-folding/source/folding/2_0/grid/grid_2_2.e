note
	description: "Two-dimensional [$source BOOLEAN_GRID]"
	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:53:31 GMT (Tuesday 8th February 2022)"
	revision: "4"

class
	GRID_2_2

inherit
	GRID_2_X
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_sequence: like sequence)
		local
			i: INTEGER
		do
			Precursor (a_sequence)
			i := a_sequence.count + 1
			create a.make (- i, i, - i, i)
			create used.make (- i, i, - i, i)
		end

feature -- Measurement

	losses (a_fold: SPECIAL [NATURAL_8]): INTEGER
		local
			i, y, x: INTEGER
		do
			a.go_to (0, 0); used.go_to (0, 0)
			if a.item and then used.item then
				inspect a_fold [0]
					when N then
						Result := Result + a.losses (Points_E_S_W)
						y := y - 1
					when S then
						Result := Result + a.losses (Points_N_E_W)
						y := y + 1
					when W then
						Result := Result + a.losses (Points_N_E_S)
						x := x - 1
					when E then
						Result := Result + a.losses (Points_N_S_W)
						x := x + 1
				else end
			elseif not a.item then
				inspect a_fold [0]
					when N then
						y := y - 1
					when S then
						y := y + 1
					when W then
						x := x - 1
				else
					x := x + 1
				end
			end
			from i := 1 until i = a_fold.count loop
				a.go_to (y, x); used.go_to (y, x)
				if a.item and then used.item then
					if a_fold [i - 1] = N and then a_fold [i] = N then
						Result := Result + a.losses (Points_E_W)
						y := y - 1
					elseif a_fold [i - 1] = N and then a_fold [i] = W then
						Result := Result + a.losses (Points_N_E)
						x := x - 1
					elseif a_fold [i - 1] = W and then a_fold [i] = W then
						Result := Result + a.losses (Points_N_S)
						x := x - 1
					elseif a_fold [i - 1] = E and then a_fold [i] = N then
						Result := Result + a.losses (Points_E_S)
						y := y - 1
					elseif a_fold [i - 1] = N and then a_fold [i] = E then
						Result := Result + a.losses (Points_N_W)
						x := x + 1
					elseif a_fold [i - 1] = W and then a_fold [i] = N then
						Result := Result + a.losses (Points_S_W)
						y := y - 1
					elseif a_fold [i] = S and then a_fold [i - 1] = S then
						Result := Result + a.losses (Points_E_W)
						y := y + 1
					elseif a_fold [i] = S and then a_fold [i - 1] = E then
						Result := Result + a.losses (Points_N_E)
						y := y + 1
					elseif a_fold [i] = E and then a_fold [i - 1] = E then
						Result := Result + a.losses (Points_N_S)
						x := x + 1
					elseif a_fold [i] = W and then a_fold [i - 1] = S then
						Result := Result + a.losses (Points_E_S)
						x := x - 1
					elseif a_fold [i] = S and then a_fold [i - 1] = W then
						Result := Result + a.losses (Points_N_W)
						y := y + 1
					elseif a_fold [i] = E and then a_fold [i - 1] = S then
						Result := Result + a.losses (Points_S_W)
						x := x + 1
					end

				elseif not a.item then
					inspect a_fold [i]
						when N then
							y := y - 1
						when S then
							y := y + 1
						when E then
							x := x + 1
					else
						x := x - 1
					end
				end
				i := i + 1
			end

			i := a_fold.count - 1
			a.go_to (y, x); used.go_to (y, x)
			if a.item and then used.item then
				inspect a_fold [i]
					when N then
						Result := Result + a.losses (Points_N_E_W)
					when S then
						Result := Result + a.losses (Points_E_S_W)
					when E then
						Result := Result + a.losses (Points_N_E_S)
				else
					Result := Result + a.losses (Points_N_S_W)
				end
				if a_fold [i] = N then
				end
			end
		end

feature -- Element change

	embed (seq: BOOL_STRING; a_fold: SPECIAL [NATURAL_8])
		local
			i, y, x: INTEGER
		do
			a.put (seq [1], 0, 0)
			used.put (one, 0, 0)
			from i := 0 until i = a_fold.count loop
				inspect a_fold [i]
					when N then
						y := y - 1
					when S then
						y := y + 1
					when E then
						x := x + 1
				else
					x := x - 1
				end
				if not (used.row_col_item (y, x)) then
					a.put (seq [i + 2], y, x)
					used.put (one, y, x)
				else
					used.initialize (one)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	reset
		do
			used.reset; a.reset
		end

	used_has_zero: BOOLEAN
		do
			Result := used.has (zero)
		end

feature {NONE} -- Internal attributes

	a: BOOLEAN_GRID

	used: BOOLEAN_GRID;

end