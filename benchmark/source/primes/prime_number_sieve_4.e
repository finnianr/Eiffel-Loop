note
	description: "Implementation using bit shifting"

	author: "Alexander Kogtenkov"
	copyright: "Copyright (c) 2001-2021 Alexander Kogtenkov"
	contact: "kwaxer at eiffel dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-01 13:47:26 GMT (Thursday 1st April 2021)"
	revision: "4"

class
	PRIME_NUMBER_SIEVE_4

inherit
	PRIME_NUMBER_COMMAND

	SINGLE_MATH
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		local
			i: INTEGER
			count: INTEGER
		do
			sieve_size := n
				-- Compute the number of elements.
			count := n |>> index_shift + (n & index_mask > 0).to_integer
				-- Exclude even items right from the beginning.
			create area.make_filled (0xAAAAAAAA, count)
				-- Clear bit 1.
			clear (area, 1)
				-- Clear bits outside the sieve.
			from
				count := count * element_size - 1
				i := n + 1
			until
				i >= count
			loop
				clear (area, i)
				i := i + 1
			end
		ensure
			sieve_size = n
		end

feature -- Measurement

	sieve_size: INTEGER
			-- The number of potential items.

feature -- Access

	prime_count: INTEGER
		local
			i, size: INTEGER
			a: like area
			v: NATURAL_32
		do
			from
				Result := 1
				a := area
				size := a.count
			until
				i >= size
			loop
				v := a [i]
				v := v - ((v |>> 1) & 0x55555555)
				v := (v & 0x33333333) + ((v |>> 2) & 0x33333333)
				Result := Result + ((((v + (v |>> 4)) & 0x0F0F0F0F) * 0x01010101) |>> 24).as_integer_32
				i := i + 1
			end
		end

feature -- Basic operations

	execute
		local
			factor, q, i, size: INTEGER
			f: INTEGER
			a: like area
		do
			size := sieve_size
			q := sqrt (size.to_real).rounded
			a := area
			from factor := 3 until factor > q loop
				from
					i := factor
				until
					i >= size or item (a, i)
				loop
					i := i + 2
				end
				if i < size then
					factor := i
				end
				f := factor * 2
				from
					i := factor * factor
				until
					i >= size
				loop
					clear (a, i)
					i := i + f
				end
				factor := factor + 2
			end
		end

feature -- Access

	item (a: like area; i: INTEGER): BOOLEAN
			-- Value of `i`-th bit of `a`.
		do
			Result := a.item (i |>> index_shift).bit_test (i & index_mask)
		end

feature -- Modification

	clear (a: like area; i: INTEGER)
			-- Put `False` at `i`-th bit of `a`.
		require
			valid_bit_index: 0 <= i and i < sieve_size
		local
			index: INTEGER
			v: like area.item
		do
			index := i |>> index_shift
			v := a [index] & (one |<< (i & index_mask)).bit_not
			a [index] := v
		ensure
			cleared: not item (a, i)
		end

feature {NONE} -- Internal attributes

	one: NATURAL_32 = 1
			-- An element with a single lower bit.

	area: SPECIAL [like one]
			-- Storage for booleans.

	element_size: INTEGER = 32
			-- Size of one element in bits.

	index_mask: INTEGER = 31
			-- A mask of an index to access a bit in the selected element.

	index_shift: INTEGER = 5
			-- A number of bits the index should be shifted to obtain the element position.

		-- `Double` and `Prime_count_table` are as in your code.

feature {NONE} -- Constants

	Name: STRING = "Bit shifting SPECIAL [NATURAL_32]"

end