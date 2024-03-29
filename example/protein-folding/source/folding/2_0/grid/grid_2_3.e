note
	description: "Two-dimensional ${BOOLEAN_GRID}"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	GRID_2_3

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
					inspect (a_fold [i - 1] |<< 3) | a_fold [i]
						when N_N then
							Result := Result + a.losses (Points_E_W)
							y := y - 1
						when N_W then
							Result := Result + a.losses (Points_N_E)
							x := x - 1
						when W_W then
							Result := Result + a.losses (Points_N_S)
							x := x - 1
						when E_N then
							Result := Result + a.losses (Points_E_S)
							y := y - 1
						when N_E then
							Result := Result + a.losses (Points_N_W)
							x := x + 1
						when W_N then
							Result := Result + a.losses (Points_S_W)
							y := y - 1
						when S_S then
							Result := Result + a.losses (Points_E_W)
							y := y + 1
						when E_S then
							Result := Result + a.losses (Points_N_E)
							y := y + 1
						when E_E then
							Result := Result + a.losses (Points_N_S)
							x := x + 1
						when S_W then
							Result := Result + a.losses (Points_E_S)
							x := x - 1
						when W_S then
							Result := Result + a.losses (Points_N_W)
							y := y + 1
						when S_E then
							Result := Result + a.losses (Points_S_W)
							x := x + 1
					else
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

			i := a_fold.count - 1 --was + 1
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