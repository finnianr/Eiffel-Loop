note
	description: "PF_HP Ver 1.0: brute force proteinfolding in the 2D HP Model"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	GRID_1_0

create
	make

feature --Queries:

	a: SE_ARRAY2 [BOOLEAN];

	used: SE_ARRAY2 [BOOLEAN];

	zero: BOOLEAN

	--fold: STRING

	number: INTEGER;

		--Constructor:

	make (i: INTEGER)
		do
				--	create zero.make

				--losses := 9999
			--fold := ""
			--fold.compare_objects
			zero := False

				--create a.make_filled (zero, 2 * i, 2 * i) --i = seq_count+1
			create a.make (- i, i, - i, i)
			a.initialize (zero)
			a.compare_objects
				--a.row_offset := -i
				--a.column_offset := -i
				--a.width := 2*i
				--a.height := 2*i
				--create used.make_filled (zero, 2 * i, 2 * i)
			create used.make (- i, i, - i, i)
			used.initialize (zero)
			used.compare_objects
				--used.row_offset := -i
				--used.column_offset := -i
				--used.width := 2*i
				--used.height := 2*i
		end -- make

feature {ANY}
	--Commands:

	embed (line, col: INTEGER; seq: BOOL_STRING; a_fold: STRING)
		require
			--  line = 0
			--  col = 0
			--  not seq.is_equal (Void)
			--  not fold.is_equal(Void)

		local
			i, x, y: INTEGER;
			b, one: BOOLEAN
		do
				--	create b.make
				--	create one.make

				--	io.put_string ("%N")
				--	io.put_string (line.to_string)
				--	io.put_string ("%N")
				--	io.put_string (col.to_string)
				--	io.put_string ("%N")

			x := col
			y := line
			one := True
			if seq.item (1) then
				b := True
			else
				b := False
			end
			a.put (b, line, col)
				--	a.fill_tagged_out_memory
				--	io.put_string (a.tagged_out_memory)
				--	print_grid
				--	io.put_string ("%N")
				---	io.put_string (y.to_string)
				--	io.put_string ("%N")
				--	io.put_string (x.to_string)
				--	io.put_string ("%N")

			used.put (one, y, x)
				--oBdA. seq.item(1) at (0,0), used
			from
				i := 2
			until
				i = a_fold.count + 2 --was + 2       i=seq.count+1
				---------------------------
				--not accessed: a_fold.item (i), i=a_fold.count +2
				---------------------------
			loop
				--Io.put_integer (i)--debug
				--Io.put_new_line--debug

				if a_fold.item (i - 1).is_equal ('N') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					y := y - 1
						--	io.put_string (used.item(y, x).to_boolean.to_string)--debug
					if not (used.item (y, x)) then
						a.put (b, y, x)
							--  io.put_string (a.item(y,x).to_string)--debug
						used.put (one, y, x)
							--	  io.put_string (used.item(y,x).to_string)--debug
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('S') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					y := y + 1
					if not (used.item (y, x)) then
						a.put (b, y, x)
						used.put (one, y, x)
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('E') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					x := x + 1
					if not (used.item (y, x)) then
						a.put (b, y, x)
						used.put (one, y, x)
					else
						used.initialize (one)
					end
				elseif a_fold.item (i - 1).is_equal ('W') then
					if seq.item (i) then
						b := True
					else
						b := False
					end
					x := x - 1
					if not (used.item (y, x)) then
						a.put (b, y, x)
						used.put (one, y, x)
					else
						used.initialize (one)
					end
				end
				i := i + 1
					-- print_grid

					--	io.put_string ("%N")
					--	io.put_string (y.to_string)
					--	io.put_string ("%N")
					--	io.put_string (x.to_string)
					--	io.put_string ("%N")
			end
		end -- embedd

	calc_losses (line, col: INTEGER; a_fold: STRING): INTEGER
		local
			i, y, x, losses: INTEGER;
		do
			x := col
			y := line
			losses := 0
			if a.item (line, col) and then used.item (line, col) then
				if a_fold.item (1).is_equal ('N') then
					losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line + 1, col)).to_integer + (not a.item (line, col + 1)).to_integer
					y := y - 1
				elseif a_fold.item (1).is_equal ('S') then
					losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line - 1, col)).to_integer + (not a.item (line, col + 1)).to_integer
					y := y + 1
				elseif a_fold.item (1).is_equal ('W') then
					losses := losses + (not a.item (line - 1, col)).to_integer + (not a.item (line, col + 1)).to_integer + (not a.item (line + 1, col)).to_integer
					x := x - 1
				elseif a_fold.item (1).is_equal ('E') then
					losses := losses + (not a.item (line, col - 1)).to_integer + (not a.item (line - 1, col)).to_integer + (not a.item (line + 1, col)).to_integer
					x := x + 1
				end
			elseif not a.item (line, col) then
				if a_fold.item (1).is_equal ('N') then
					y := y - 1
				elseif a_fold.item (1).is_equal ('S') then
					y := y + 1
				elseif a_fold.item (1).is_equal ('W') then
					x := x - 1
				elseif a_fold.item (1).is_equal ('E') then
					x := x + 1
				end
			end
			from
				i := 2
			until
				i = a_fold.count + 1 --        i=seq.count
				---------------------------
				--later evaluated: a_fold.item(a_fold.count + 1)
				---------------------------
			loop
				if a.item (y, x) and then used.item (y, x) then
					if a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('N') then
						losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y, x + 1)).to_integer
						y := y - 1
					elseif a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('W') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y, x + 1)).to_integer
						x := x - 1
					elseif a_fold.item (i - 1).is_equal ('W') and then a_fold.item (i).is_equal ('W') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y + 1, x)).to_integer
						x := x - 1
					elseif a_fold.item (i - 1).is_equal ('E') and then a_fold.item (i).is_equal ('N') then
						losses := losses + (not a.item (y, x + 1)).to_integer + (not a.item (y + 1, x)).to_integer
						y := y - 1
					elseif a_fold.item (i - 1).is_equal ('N') and then a_fold.item (i).is_equal ('E') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y, x - 1)).to_integer
						x := x + 1
					elseif a_fold.item (i - 1).is_equal ('W') and then a_fold.item (i).is_equal ('N') then
						losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y + 1, x)).to_integer
						y := y - 1
					elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('S') then
						losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y, x + 1)).to_integer
						y := y + 1
					elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('E') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y, x + 1)).to_integer
						y := y + 1
					elseif a_fold.item (i).is_equal ('E') and then a_fold.item (i - 1).is_equal ('E') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y + 1, x)).to_integer
						x := x + 1
					elseif a_fold.item (i).is_equal ('W') and then a_fold.item (i - 1).is_equal ('S') then
						losses := losses + (not a.item (y, x + 1)).to_integer + (not a.item (y + 1, x)).to_integer
						x := x - 1
					elseif a_fold.item (i).is_equal ('S') and then a_fold.item (i - 1).is_equal ('W') then
						losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y, x - 1)).to_integer
						y := y + 1
					elseif a_fold.item (i).is_equal ('E') and then a_fold.item (i - 1).is_equal ('S') then
						losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y + 1, x)).to_integer
						x := x + 1
					end
				elseif not a.item (y, x) then
					if a_fold.item (i).is_equal ('N') then
						y := y - 1
					elseif a_fold.item (i).is_equal ('S') then
						y := y + 1
					elseif a_fold.item (i).is_equal ('E') then
						x := x + 1
					elseif a_fold.item (i).is_equal ('W') then
						x := x - 1
					end
				end
				i := i + 1
			end
				--------------------------
				--		io.put_string("%N");
				--		io.put_integer(i);
				--		io.put_string("%N");
				--		io.put_string("Should be: ");
				--		io.put_integer(11);
				--		io.put_string("%N");
			i := a_fold.count + 1 --was + 1
			if a.item (y, x) and then used.item (y, x) then
				if a_fold.item (i - 1).is_equal ('N') then
					losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y - 1, x)).to_integer + (not a.item (y, x + 1)).to_integer
				elseif a_fold.item (i - 1).is_equal ('S') then
					losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y + 1, x)).to_integer + (not a.item (y, x + 1)).to_integer
				elseif a_fold.item (i - 1).is_equal ('E') then
					losses := losses + (not a.item (y - 1, x)).to_integer + (not a.item (y, x + 1)).to_integer + (not a.item (y + 1, x)).to_integer
				elseif a_fold.item (i - 1).is_equal ('W') then
					losses := losses + (not a.item (y, x - 1)).to_integer + (not a.item (y - 1, x)).to_integer + (not a.item (y + 1, x)).to_integer
				end
			end
			Result := losses
		end

end
