note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_COMPLEX_COLUMN_VECTOR [G -> NUMERIC]

inherit
	EL_COLUMN_VECTOR [G]
		rename
			make_from_pointer as make_real_from_pointer
--			set_from_array as set_from_array_reals
		redefine
			make, product
		end

create
	make, make_from_pointer, make_from_other

feature {NONE} -- Initialization

	make (max_index: INTEGER)
			--
		do
			Precursor (max_index)
			create imaginary.make (max_index)
		end

	make_from_other (other: like current)
			--
		do
			make_from_array (other)
			create imaginary.make_from_array (other.imaginary)
		end

	make_from_pointer (ptr_real, ptr_imaginery: POINTER; max_index, element_bytes: INTEGER)
			--
		do
			make_real_from_pointer (ptr_real, max_index, element_bytes)
			create imaginary.make_from_pointer (ptr_imaginery, max_index, element_bytes)
		end

feature -- Access

	imaginary: EL_COLUMN_VECTOR [G]

feature -- Duplication

	conjugate: EL_COMPLEX_COLUMN_VECTOR [G]
			--
		local
			i: INTEGER
		do
			create Result.make_from_other (Current)
			from i := 1 until i > count loop
				Result.imaginary [i] := - imaginary [i]
				i := i + 1
			end
		end

	product alias "|*" (other: like Current): like Current
			-- Complex product
			-- (a + bi)(c + di) = (ac - bd) + (bc + ad)i
		local
			a, b, c, d: G
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				a := item (i); b := imaginary [i]
				c := other [i]; d := other.imaginary [i]
				Result [i] := a * c - b * d
				Result.imaginary [i] := b * c + a * d
				i := i + 1
			end
		end

end
