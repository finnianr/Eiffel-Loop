note
	description: "Fast lookup of code in unencoded intervals array"
	notes: "Can be optimized by using an array of indices into `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-30 17:21:47 GMT (Saturday 30th January 2021)"
	revision: "5"

class
	EL_UNENCODED_CHARACTERS_INDEX

inherit
	EL_EXTENDABLE_AREA [INTEGER]
		rename
			area as index_stack
		end

	EL_ZCODE_CONVERSION undefine copy, is_equal, out end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_area: like area)
		do
			index_stack := Empty_area
			set_area (a_area)
		end

	make_default
		do
			index_stack := Empty_area
			create area.make_empty (0)
		end

feature -- Access

	code (index: INTEGER): NATURAL
		require
			valid_index: valid_index (index)
		local
			i, i_final, lower, upper, last_index: INTEGER; stack: like index_stack
			l_area: like area
		do
			i := area_index
			stack := index_stack; l_area := area; i_final := l_area.count
			lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
			if index < lower then
				from until index >= lower or else stack.count = 0 loop
					i := stack [stack.count - 1]
					stack.remove_tail (1)
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				end
			elseif index > upper then
				from until index <= upper or else i = i_final loop
					stack := big_enough (stack, 1)
					stack.extend (i)
					i := i + upper - lower + 3
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				end
			end
			Result := l_area [2 + i + index - lower]
			area_index := i
		end

	index_of (unicode: NATURAL; start_index: INTEGER): INTEGER
		-- untested
		local
			lower, upper, i, i_final, j: INTEGER
			l_area: like area; found: BOOLEAN
		do
			l_area := area; i_final := l_area.count
			-- find `start_index'
			from i := 0 until found or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= start_index then
					found := True
				else
					i := i + upper - lower + 3
				end
			end
			if found then
				from until Result > 0 or else i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					from j := lower until j > upper loop
						if l_area [i + 2 + j - lower] = unicode then
							Result := j
						end
						j := j + 1
					end
					i := i + upper - lower + 3
				end
			end
		end

	z_code (i: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (i))
		end

feature -- Measurement

	occurrences (unicode: NATURAL): INTEGER
		-- untested
		local
			i, j, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				from j := lower until j > upper loop
					if l_area [2 + i + j - lower] = unicode then
						Result := Result + 1
					end
					j := j + 1
				end
				i := i + upper - lower + 3
			end
		end

feature -- Status query

	valid_index (index: INTEGER): BOOLEAN
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until Result or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= index and then index <= upper then
					Result := True
				else
					i := i + upper - lower + 3
				end
			end
		end

feature -- Element change

	set_area (a_area: like area)
		do
			wipe_out
			area_index := 0
			area := a_area
		end

	wipe_out
		do
			index_stack.wipe_out
		end

feature {NONE} -- Implementation

	lower_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i).to_integer_32
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i + 1).to_integer_32
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [NATURAL]
		-- unencoded character area

	area_index: INTEGER

feature {NONE} -- Constants

	Empty_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end
end