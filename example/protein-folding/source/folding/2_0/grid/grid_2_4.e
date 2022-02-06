note
	description: "Two-dimensional [$source BOOLEAN_GRID]"
	notes: "[
		Failed experiment to use dispatch table `loss_calculators' in place of `inspect' for loss calculations
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
	GRID_2_4

inherit
	GRID_2_2
		redefine
			losses, make
		end

create
	make

feature {NONE} -- Initialization

	make (a_sequence: like sequence)
		do
			Precursor (a_sequence)
			create loss_calculators.make_filled (create {DEFAULT_LOSS_CALCULATOR}.make (a, 0, 1, 0), N_N, W_W)
			loss_calculators [N_N] := new_calculator (0, -1, Points_E_W)
			loss_calculators [N_W] := new_calculator (-1, 0, Points_N_E)
			loss_calculators [W_W] := new_calculator (-1, 0, Points_N_S)
			loss_calculators [E_N] := new_calculator (0, -1, Points_E_S)
			loss_calculators [N_E] := new_calculator (1, 0,  Points_N_W)
			loss_calculators [W_N] := new_calculator (0, -1, Points_S_W)
			loss_calculators [S_S] := new_calculator (0, 1,  Points_E_W)
			loss_calculators [E_S] := new_calculator (0, 1,  Points_N_E)
			loss_calculators [E_E] := new_calculator (1, 0,  Points_N_S)
			loss_calculators [S_W] := new_calculator (-1, 0, Points_E_S)
			loss_calculators [W_S] := new_calculator (0, 1,  Points_N_W)
			loss_calculators [S_E] := new_calculator (1, 0,  Points_S_W)
		ensure then
			correct_calculator_count: calculator_count.item = 12
		end

feature -- Measurement

	losses (a_fold: SPECIAL [NATURAL_8]): INTEGER
		local
			i, y, x: INTEGER; calculator: LOSS_CALCULATOR
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
					calculator := loss_calculators [(a_fold [i - 1] |<< 3) | a_fold [i]]
					if not calculator.is_default then
						calculator.find_losses
						Result := Result + calculator.losses
						if calculator.is_x_delta then
							x := x + calculator.delta
						else
							y := y + calculator.delta
						end
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
				if a_fold [i] = N then
				end
			end
		end

feature {NONE} -- Implementation

	new_calculator (delta_x, delta_y: INTEGER; a_point_set: NATURAL_32): LOSS_CALCULATOR
		do
			create Result.make (a, delta_x, delta_y, a_point_set)
		end

	calculator_count: INTEGER_REF
		do
			create Result
			loss_calculators.do_all (
				agent (calculator: LOSS_CALCULATOR; count: INTEGER_REF)
					do
						if not attached {DEFAULT_LOSS_CALCULATOR} calculator then
							count.set_item (count.item + 1)
						end
					end (?, Result)
			)
		end

feature {NONE} -- Internal attributes

	loss_calculators: ARRAY [LOSS_CALCULATOR]

end
