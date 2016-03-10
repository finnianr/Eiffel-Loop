note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_COLUMN_VECTOR [G -> NUMERIC]

inherit
	ARRAY [G]
		rename
			make as array_make
		redefine
			make_from_array
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make, make_from_array, make_from_pointer

feature -- Initialization

	make (max_index: INTEGER)
			--
		do
			array_make (1, max_index)
		end

	make_from_pointer (ptr_data: POINTER; max_index, element_bytes: INTEGER)
			--
		do
			make (max_index)
			($area).memory_copy (ptr_data, max_index * element_bytes)
		end

	make_from_array (a: ARRAY [G])
			-- Initialize from the items of `a'.
		do
			area := a.area
			lower := 1
			upper := a.count
		end

feature -- Status setting

	initialize
			--
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				put (item (i).zero, i)
				i := i + 1
			end
		end

	increment (other: like Current)
			--
		require
			same_dimension: count = other.count
		local
			i: INTEGER
		do
			from i := lower until i > upper loop
				put (item (i) + other.item (i), i)
				i := i + 1
			end
		end

	divide (divisor: like item)
			--
		local
			i: INTEGER
		do
			from i := lower until i > upper loop
				put (item (i) / divisor, i)
				i := i + 1
			end
		end

	scale (scalar: like item)
			--
		local
			i: INTEGER
		do
			from i := lower until i > upper loop
				put (item (i) * scalar, i)
				i := i + 1
			end
		end

feature -- Basic operations

	add alias "+" (other: like Current): like Current
			--
		require
			same_dimension: count = other.count
		do
			create Result.make_from_array (Current)
			Result.increment (other)
		end

	scaled alias "*" (scalar: like item): like Current
			--
		do
			create Result.make_from_array (Current)
			Result.scale (scalar)
		end

	divided alias "/" (divisor: like item): like Current
			--
		do
			create Result.make_from_array (Current)
			Result.divide (divisor)
		end

	product alias "|*" (other: like Current): like Current
			--
		require
			same_number_of_elements: count = other.count
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result [i] := item (i) * other.item (i)
				i := i + 1
			end
		end

feature -- Measurement

	sum: G
			--
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				Result := Result + item (i)
				i := i + 1
			end
		end

end
