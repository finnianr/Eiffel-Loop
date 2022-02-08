note
	description: "Two-dimensional [$source BOOLEAN_GRID] using nested inspect for double direction loss calc"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:51:50 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	GRID_2_6

inherit
	GRID_2_2
		redefine
			losses
		end

create
	make

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
			end
		end

end