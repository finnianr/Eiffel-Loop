note
	description: "[
		Eiffel entry for [https://www.youtube.com/watch?v=D3h62rgewZM Software Drag Racing: C++ vs C# vs Python]
	]"
	notes: "[
		Command switch: -primes_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 17:08:21 GMT (Sunday 10th December 2023)"
	revision: "13"

class
	PRIMES_BENCHMARK_APP

inherit
	EL_APPLICATION

	MEMORY
		export
			{NONE} all
		end

	EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	initialize
		do

		end

feature -- Basic operations

	run
		local
			timer: EL_EXECUTION_TIMER; pass_count: INTEGER_REF
			method: like new_method_list.item; command: PRIME_NUMBER_COMMAND
		do
			create timer.make
			across new_method_list as list loop
				method := list.item
				create pass_count
				timer.start
				command := method (timer, pass_count)
				timer.stop
				print_results (command, timer.elapsed_millisecs / 1000, pass_count.item)
			end
		end

feature {NONE} -- Methods

	benchmark_bit_shifting (timer: EL_EXECUTION_TIMER; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_4
		do
			from timer.start until timer.elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
			end
		end

	benchmark_cpp_vector (timer: EL_EXECUTION_TIMER; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_3
		do
			from timer.start until timer.elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
			end
		end

	benchmark_to_special (timer: EL_EXECUTION_TIMER; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_1
		do
			from timer.start until timer.elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
			end
		end

	benchmark_managed_pointer (timer: EL_EXECUTION_TIMER; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_2
		do
			from timer.start until timer.elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
			end
		end

feature {NONE} -- Implementation

	print_results (command: PRIME_NUMBER_COMMAND; duration: DOUBLE; pass_count: INTEGER)
		do
			lio.put_labeled_string ("Implementation method", command.name)
			lio.put_new_line
			if attached Format.double ("9.999") as d then
				lio.put_substitution (
					Results_template, [pass_count, d.formatted (duration), d.formatted (duration / pass_count),
					sieve_size, command.prime_count, command.is_valid]
				)
			end
			lio.put_new_line_x2
		end

	new_method_list: ARRAY [FUNCTION [EL_EXECUTION_TIMER, INTEGER_REF, PRIME_NUMBER_COMMAND]]
		do
			Result := <<
				agent benchmark_managed_pointer, agent benchmark_to_special,
				agent benchmark_cpp_vector, agent benchmark_bit_shifting
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Benchmark calculation of primes using the the sieve of Eratosthenes method"

	Time_limit: INTEGER = 5000

	Sieve_size: INTEGER = 1_000_000

	Results_template: ZSTRING
		once
			Result := "Passes: %S, Time: %S, Avg: %S, Limit: %S, Count: %S, Valid: %S"
		end
end