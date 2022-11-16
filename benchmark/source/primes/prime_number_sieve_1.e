note
	description: "[$source TO_SPECIAL [BOOLEAN]] implementation of [$source PRIME_NUMBER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	PRIME_NUMBER_SIEVE_1

inherit
	PRIME_NUMBER_COMMAND

	TO_SPECIAL [BOOLEAN]
		rename
			area as bits_area
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_filled_area (True, n)
		end

feature -- Access

	prime_count: INTEGER
		local
			i, size: INTEGER; bits: like bits_area
		do
			size := sieve_size; bits := bits_area
			Result := 1
			from i := 3 until i >= size loop
				if bits [i] then
					Result := Result + 1
				end
				i := i + 2
			end
		end

feature -- Basic operations

	execute
		local
			factor, q, i, size: INTEGER; done: BOOLEAN
			bits: like bits_area
		do
			size := sieve_size; bits := bits_area

			q := sqrt (sieve_size.to_real).rounded
			from factor := 3 until factor > q loop
				from done := False; i := factor until done or else i >= size loop
					if bits [i] then
						factor := i; done := True
					else
						i := i + 2
					end
				end
				from i := factor * factor until i >= size loop
					bits [i] := False
					i := i + factor * 2
				end
				factor := factor + 2
			end
		end

	reset
		do
			bits_area.fill_with (True, 0, sieve_size - 1)
		end

feature {NONE} -- Implementation

	sieve_size: INTEGER
		do
			Result := bits_area.count
		end

feature {NONE} -- Constants

	Name: STRING = "TO_SPECIAL [BOOLEAN]"

end