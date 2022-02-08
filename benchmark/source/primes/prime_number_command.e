note
	description: "Command to calculate primes using the the sieve of Eratosthenes method"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 10:12:21 GMT (Tuesday 8th February 2022)"
	revision: "5"

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

	name: STRING
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

feature {NONE} -- Implementation

	sieve_size: INTEGER
		deferred
		end

feature {NONE} -- Constants

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

end