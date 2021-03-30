note
	description: "[
		Eiffel entry for [https://www.youtube.com/watch?v=D3h62rgewZM Software Drag Racing: C++ vs C# vs Python]
	]"
	notes: "[
		Command switch: -primes_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-30 15:38:28 GMT (Tuesday 30th March 2021)"
	revision: "3"

class
	PRIMES_BENCHMARK_APP

inherit
	EL_SUB_APPLICATION

	MEMORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do

		end

feature -- Basic operations

	run
		local
			time: C_DATE; sieve: PRIME_NUMBER_SIEVE; sieve_2: PRIME_NUMBER_SIEVE_2
			pass_count, millisecs_start, millisecs_elapsed: INTEGER
		do
			create time
			lio.put_line ("TO_SPECIAL implementation")
			from millisecs_start := millisecs (time) until millisecs_elapsed > 5000 loop
				create sieve.make (1_000_000)
				sieve.execute
				time.update
				millisecs_elapsed := millisecs (time) - millisecs_start
				pass_count := pass_count + 1
			end
			sieve.print_results (millisecs_elapsed / 1000, pass_count)
			lio.put_new_line

			lio.put_line ("TO_SPECIAL implementation without GC overhead")
			collect
			collection_off
			create sieve.make (1_000_000)
			pass_count := 0; millisecs_elapsed := 0
			from millisecs_start := millisecs (time) until millisecs_elapsed > 5000 loop
				sieve.reset; sieve.execute
				time.update
				millisecs_elapsed := millisecs (time) - millisecs_start
				pass_count := pass_count + 1
			end
			sieve.print_results (millisecs_elapsed / 1000, pass_count)
			lio.put_new_line
			collection_on

			lio.put_line ("MANAGED_POINTER implementation")
			pass_count := 0; millisecs_elapsed := 0
			create time
			from millisecs_start := millisecs (time) until millisecs_elapsed > 5000 loop
				create sieve_2.make (1_000_000)
				sieve_2.execute
				time.update
				millisecs_elapsed := millisecs (time) - millisecs_start
				pass_count := pass_count + 1
			end
			sieve_2.print_results (millisecs_elapsed / 1000, pass_count)
		end

feature {NONE} -- Implementation

	millisecs (time: C_DATE): INTEGER
		do
			Result := time.minute_now * 60_000 + time.second_now * 1000 + time.millisecond_now
		end

feature {NONE} -- Constants

	Description: STRING = "Benchmark calculation of primes using the the sieve of Eratosthenes method"
end