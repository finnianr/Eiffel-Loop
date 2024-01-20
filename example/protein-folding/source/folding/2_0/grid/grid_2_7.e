note
	description: "Two-dimensional ${BOOLEAN_GRID}"
	notes: "[
		Merged `a' and 'used' into one array of NATURAL_8. This method proved to be surprisingly slow.
		TIME: 0 hrs 4 mins 38 secs 532 ms
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	GRID_2_7

inherit
	GRID_2_X
		redefine
			losses, make
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
		end

feature -- Measurement

	losses (a_fold: SPECIAL [NATURAL_8]): INTEGER
		local
			i, y, x: INTEGER
		do
			a.go_to (0, 0)
			if a.is_item_one_and_used then
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
			elseif a.is_item_zero then
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
				a.go_to (y, x)
				if a.is_item_one_and_used then
					inspect a_fold [i - 1]
						when N then
							inspect a_fold [i]
								when E then
									Result := Result + a.losses (Points_N_W)
									x := x + 1
								when N then
									Result := Result + a.losses (Points_E_W)
									y := y - 1
								when W then
									Result := Result + a.losses (Points_N_E)
									x := x - 1
						else end
						when S then
							inspect a_fold [i]
								when E then
									Result := Result + a.losses (Points_S_W)
									x := x + 1
								when S then
									Result := Result + a.losses (Points_E_W)
									y := y + 1
								when W then
									Result := Result + a.losses (Points_E_S)
									x := x - 1
						else end
						when E then
							inspect a_fold [i]
								when E then
									Result := Result + a.losses (Points_N_S)
									x := x + 1
								when N then
									Result := Result + a.losses (Points_E_S)
									y := y - 1
								when S then
									Result := Result + a.losses (Points_N_E)
									y := y + 1
						else end
						when W then
							inspect a_fold [i]
								when N then
									Result := Result + a.losses (Points_S_W)
									y := y - 1
								when S then
									Result := Result + a.losses (Points_N_W)
									y := y + 1
								when W then
									Result := Result + a.losses (Points_N_S)
									x := x - 1
						else end
					else end

				elseif a.is_item_zero then
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
			a.go_to (y, x)
			if a.is_item_one_and_used then
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
			end
		end

feature -- Element change

	embed (seq: BOOL_STRING; a_fold: SPECIAL [NATURAL_8])
		local
			i, y, x: INTEGER
		do
			a.go_to (0, 0); a.set_item (seq [1])
			from i := 0 until i = a_fold.count loop
				inspect a_fold [i - 1]
					when N then
						y := y - 1
					when S then
						y := y + 1
					when E then
						x := x + 1
				else
					x := x - 1
				end
				a.go_to (y, x)
				if not a.is_item_used then
					a.set_item (seq [i + 2])
				else
					a.set_all_used
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	reset
		do
			a.reset
		end

	used_has_zero: BOOLEAN
		do
			Result := a.some_item_is_not_used
		end

feature {NONE} -- Internal attributes

	a: FOLD_GRID

end