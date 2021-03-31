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
	date: "2021-03-31 12:36:22 GMT (Wednesday 31st March 2021)"
	revision: "4"

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
		do
			benchmark_to_special
			benchmark_managed_pointer
			benchmark_cpp_vector
		end

feature {NONE} -- Implementation

	benchmark_cpp_vector
		local
			time: C_DATE; sieve: PRIME_NUMBER_SIEVE_3
			pass_count, millisecs_start, millisecs_elapsed: INTEGER
		do
			lio.put_line ("EL_CPP_BOOLEAN_ARRAY implementation")
			create time
			from millisecs_start := millisecs (time) until millisecs_elapsed > 5000 loop
				create sieve.make (1_000_000)
				sieve.execute
				time.update
				millisecs_elapsed := millisecs (time) - millisecs_start
				pass_count := pass_count + 1
			end
			sieve.print_results (millisecs_elapsed / 1000, pass_count)
		end

	benchmark_to_special
		local
			time: C_DATE; sieve: PRIME_NUMBER_SIEVE
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
		end

	benchmark_managed_pointer
		local
			time: C_DATE; sieve: PRIME_NUMBER_SIEVE_2
			pass_count, millisecs_start, millisecs_elapsed: INTEGER
		do
			lio.put_line ("MANAGED_POINTER implementation")
			create time
			from millisecs_start := millisecs (time) until millisecs_elapsed > 5000 loop
				create sieve.make (1_000_000)
				sieve.execute
				time.update
				millisecs_elapsed := millisecs (time) - millisecs_start
				pass_count := pass_count + 1
			end
			sieve.print_results (millisecs_elapsed / 1000, pass_count)
		end

	millisecs (time: C_DATE): INTEGER
		do
			Result := time.minute_now * 60_000 + time.second_now * 1000 + time.millisecond_now
		end

feature {NONE} -- Constants

	Description: STRING = "Benchmark calculation of primes using the the sieve of Eratosthenes method"
end