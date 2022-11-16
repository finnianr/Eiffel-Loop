note
	description: "[$source MANAGED_POINTER] implementation of [$source PRIME_NUMBER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	PRIME_NUMBER_SIEVE_2

inherit
	PRIME_NUMBER_COMMAND
		undefine
			copy, is_equal
		end

	MANAGED_POINTER
		rename
			item as bits_item,
			count as sieve_size
		export
			{NONE} all
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		local
			i: INTEGER; bool_true: BOOLEAN
			bits_ptr: like bits_item
		do
			Precursor (n)
			bits_ptr := bits_item; bool_true := True
			from i := 1 until i = sieve_size loop
				(bits_ptr + i).memory_copy ($bool_true, Boolean_bytes)
				i := i + 1
			end
		end

feature -- Access

	prime_count: INTEGER
		local
			i, size: INTEGER; bits_ptr: like bits_item
			i_th: BOOLEAN
		do
			size := sieve_size; bits_ptr := bits_item
			Result := 1
			from i := 3 until i >= size loop
				($i_th).memory_copy (bits_ptr + i, Boolean_bytes)
				if i_th then
					Result := Result + 1
				end
				i := i + 2
			end
		end

feature -- Basic operations

	execute
		local
			factor, q, i, size: INTEGER; done, i_th, bool_false: BOOLEAN
			bits_ptr: like bits_item
		do
			size := sieve_size; bits_ptr := bits_item

			q := sqrt (sieve_size.to_real).rounded
			from factor := 3 until factor > q loop
				from done := False; i := factor until done or else i >= size loop
					($i_th).memory_copy (bits_ptr + i, Boolean_bytes)
					if i_th then
						factor := i; done := True
					else
						i := i + 2
					end
				end
				bool_false := False
				from i := factor * factor until i >= size loop
					(bits_ptr + i).memory_copy ($bool_false, Boolean_bytes)
					i := i + factor * 2
				end
				factor := factor + 2
			end
		end

feature {NONE} -- Constants

	Name: STRING = "MANAGED_POINTER"

end