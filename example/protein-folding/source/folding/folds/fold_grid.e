note
	description: "Summary description for {FOLD_GRID}."

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
	FOLD_GRID

inherit
	SE_ARRAY2 [NATURAL_8]
		rename
			item as row_col_item
		export
			{NONE} all
			{ANY} has, initialize, count
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

feature -- Status query

	is_item_one_and_used: BOOLEAN
		do
			Result := item = One_and_used
		end

	is_item_used: BOOLEAN
		do
			Result := item & Item_mask > 0
		end

	is_item_zero: BOOLEAN
		do
			Result := item & Used_mask = 0
		end

	some_item_is_not_used: BOOLEAN
		local
			l_area: like area; i, l_count: INTEGER
		do
			l_area := area; l_count := count
			from i := 0 until Result or else i = l_count loop
				Result := l_area.item (i) & Item_mask = 0
				i := i + 1
			end
		end

feature -- Access

	fold_losses (a_x, a_y: INTEGER; a_fold: FOLD_ARRAY): INTEGER
		local
			i, y, x, l_upper, l_width: INTEGER
			l_area: like area
		do
			l_area := area; l_width := width
			x := a_x; y := a_y
			l_upper := a_fold.count + 1
			from i := 2 until i = l_upper loop
				go_to (y, x)
				if is_item_one_and_used then
					inspect a_fold [i - 1]
						when N then
							inspect a_fold [i]
								when E then
									Result := Result + internal_losses (l_area, zero_index, l_width, Points_N_W)
									x := x + 1
								when N then
									Result := Result + losses (Points_E_W)
									y := y - 1
								when W then
									Result := Result + losses (Points_N_E)
									x := x - 1
						else end
						when S then
							inspect a_fold [i]
								when E then
									Result := Result + losses (Points_S_W)
									x := x + 1
								when S then
									Result := Result + losses (Points_E_W)
									y := y + 1
								when W then
									Result := Result + losses (Points_E_S)
									x := x - 1
						else end
						when E then
							inspect a_fold [i]
								when E then
									Result := Result + losses (Points_N_S)
									x := x + 1
								when N then
									Result := Result + losses (Points_E_S)
									y := y - 1
								when S then
									Result := Result + losses (Points_N_E)
									y := y + 1
						else end
						when W then
							inspect a_fold [i]
								when N then
									Result := Result + losses (Points_S_W)
									y := y - 1
								when S then
									Result := Result + losses (Points_N_W)
									y := y + 1
								when W then
									Result := Result + losses (Points_N_S)
									x := x - 1
						else end
					else end

				elseif is_item_zero then
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
		end

feature -- Element change

	reset
		do
			initialize (0)
		end

	set_all_used
		local
			l_area: like area; i, l_count: INTEGER
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				l_area.put (l_area.item (i) | Item_mask, i)
				i := i + 1
			end
		end

	set_item (b: BOOLEAN)
		-- set item to `b' and used bit to True
		do
			item := Item_mask | (b.to_integer.to_natural_8)
			area [zero_index] := item
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
						when 1 then
							j := a_index - a_width -- N
						when 2 then
							j := a_index + 1 -- E
						when 3 then
							j := a_index + a_width -- S
						when 4 then
							j := a_index - 1 -- W
					else end
					if a_area.item (j) & Used_mask = 0 then
						Result := Result + 1
					end
				end
				direction_bit := direction_bit |>> 1
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	item: NATURAL_8

	zero_index: INTEGER

feature {NONE} -- Constants

	Item_mask: NATURAL_8 = 0b10

	One_and_used: NATURAL_8 = 0b11

	Used_mask: NATURAL_8 = 0b01;

end
