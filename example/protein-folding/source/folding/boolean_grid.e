note
	description: "2D grid of boolean values"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:48:27 GMT (Tuesday 8th February 2022)"
	revision: "2"

class
	BOOLEAN_GRID

inherit
	SE_ARRAY2 [BOOLEAN]
		rename
			item as row_col_item
		export
			{NONE} all
			{ANY} has, put, initialize, row_col_item, count
		end

	POINT_SET_CONSTANTS
		undefine
			is_equal, copy
		end

	DIRECTION_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make, make_filled

feature -- Access

	item: BOOLEAN

feature -- Access

	fold_losses (a_fold: SPECIAL [NATURAL_8]; used: BOOLEAN_GRID): INTEGER
		local
			i, y, x, l_upper, l_width: INTEGER
			l_area: like area; point_set: NATURAL
		do
			l_area := area; l_width := width; l_upper := a_fold.count

			go_to (0, 0); used.go_to (0, 0)
			if item and then used.item then
				inspect a_fold [0]
					when N then point_set := Points_E_S_W; y := y - 1
					when S then point_set := Points_N_E_W; y := y + 1
					when W then point_set := Points_N_E_S; x := x - 1
					when E then point_set := Points_N_S_W; x := x + 1
				else end
				Result := Result + internal_losses (l_area, zero_index, l_width, point_set)
			elseif not item then
				inspect a_fold [0]
					when N then y := y - 1
					when S then y := y + 1
					when W then x := x - 1
				else
					x := x + 1
				end
			end
			from i := 1 until i = l_upper loop
				go_to (y, x); used.go_to (y, x)
				if item and then used.item then
					point_set := 0
					inspect a_fold [i - 1]
						when N then
							inspect a_fold [i]
								when E then point_set := Points_N_W; x := x + 1
								when N then point_set := Points_E_W; y := y - 1
								when W then point_set := Points_N_E; x := x - 1
						else end
						when S then
							inspect a_fold [i]
								when E then point_set := Points_S_W; x := x + 1
								when S then point_set := Points_E_W; y := y + 1
								when W then point_set := Points_E_S; x := x - 1
						else end
						when E then
							inspect a_fold [i]
								when E then point_set := Points_N_S; x := x + 1
								when N then point_set := Points_E_S; y := y - 1
								when S then point_set := Points_N_E; y := y + 1
						else end
						when W then
							inspect a_fold [i]
								when N then point_set := Points_S_W; y := y - 1
								when S then point_set := Points_N_W; y := y + 1
								when W then point_set := Points_N_S; x := x - 1
						else end
					else end
					if point_set > 0 then
						Result := Result + internal_losses (l_area, zero_index, l_width, point_set)
					end
				elseif not item then
					inspect a_fold [i]
						when N then y := y - 1
						when S then y := y + 1
						when E then x := x + 1
					else
						x := x - 1
					end
				end
				i := i + 1
			end
			go_to (y, x); used.go_to (y, x)
			if item and then used.item then
				inspect a_fold [l_upper - 1]
					when N then point_set := Points_N_E_W
					when S then point_set := Points_E_S_W
					when E then point_set := Points_N_E_S
				else
					point_set := Points_N_S_W
				end
				Result := Result + internal_losses (l_area, zero_index, l_width, point_set)
			end
		end

feature -- Element change

	reset
		do
			initialize (False)
		end

feature -- Cursor movement

	go_to (row, column: INTEGER)
		local
			i: INTEGER
		do
			i := (row - row_offset - 1) * width + (column - column_offset) - 1
			item := area [i]
			zero_index := i
		end

	losses (point_set: NATURAL): INTEGER
		do
			Result := internal_losses (area, zero_index, width, point_set)
		end

feature {NONE} -- Implementation

	internal_losses (a_area: like area; a_index, a_width: INTEGER; point_set: NATURAL): INTEGER
		local
			i, j: INTEGER; direction_bit: NATURAL
		do
			direction_bit := Point_N
			from i := 1 until i > 4 loop
				if (point_set & direction_bit).to_boolean then
					inspect i
						when 1 then j := a_index - a_width 	-- N
						when 2 then j := a_index + 1 			-- E
						when 3 then j := a_index + a_width 	-- S
						when 4 then j := a_index - 1 			-- W
					else end
					if not a_area [j] then
						Result := Result + 1
					end
				end
				direction_bit := direction_bit |>> 1
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	zero_index: INTEGER

end