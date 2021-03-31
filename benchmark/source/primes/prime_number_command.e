note
	description: "Command to calculate primes using the the sieve of Eratosthenes method"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-31 12:33:03 GMT (Wednesday 31st March 2021)"
	revision: "2"

deferred class
	PRIME_NUMBER_COMMAND

inherit
	EL_COMMAND

	SINGLE_MATH
		export
			{NONE} all
		end

	EL_MODULE_LIO

feature -- Access

	prime_count: INTEGER
		deferred
		end

feature -- Status query

	is_valid: BOOLEAN
		-- `True' if results are valid
		do
			if Prime_count_table.has_key (sieve_size) then
				Result := Prime_count_table.found_item = prime_count
			end
		end

feature -- Basic operations

	print_results (duration: DOUBLE; pass_count: INTEGER)
		do
			lio.put_substitution (
				Results_template, [pass_count, Double.formatted (duration), Double.formatted (duration / pass_count),
				sieve_size, prime_count, is_valid]
			)
			lio.put_new_line_x2
		end

feature {NONE} -- Implementation

	sieve_size: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 3)
			Result.no_justify
		end

	Prime_count_table: HASH_TABLE [INTEGER, INTEGER]
		-- Historical data for validating results - the number of primes
		-- to be found under some limit, such as 168 primes under 1000
		local
			key: INTEGER
		once
			create Result.make (13)
			key := 10
			across << 4, 25, 168, 1229, 9592, 78498, 664579, 5761455, 50847534 >> as n loop
				Result [key] := n.item
				key := key * 10
			end
		end

	Results_template: ZSTRING
		once
			Result := "Passes: %S, Time: %S, Avg: %S, Limit: %S, Count: %S, Valid: %S"
		end

end