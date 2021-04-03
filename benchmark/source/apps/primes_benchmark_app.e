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
	date: "2021-04-03 13:40:54 GMT (Saturday 3rd April 2021)"
	revision: "8"

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
			elapsed_millisecs: DOUBLE_REF; pass_count: INTEGER_REF
			method: like new_method_list.item; command: PRIME_NUMBER_COMMAND
		do
			across new_method_list as list loop
				method := list.item
				create elapsed_millisecs; create pass_count
				command := method (elapsed_millisecs, pass_count)
				print_results (command, elapsed_millisecs.item / 1000, pass_count.item)
			end
		end

feature {NONE} -- Methods

	benchmark_bit_shifting (elapsed_millisecs: DOUBLE_REF; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_4
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			from timer.start until elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
				elapsed_millisecs.set_item (timer.elapsed_millisecs)
			end
		end

	benchmark_cpp_vector (elapsed_millisecs: DOUBLE_REF; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_3
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			from timer.start until elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
				elapsed_millisecs.set_item (timer.elapsed_millisecs)
			end
		end

	benchmark_to_special (elapsed_millisecs: DOUBLE_REF; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_1
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			from timer.start until elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
				elapsed_millisecs.set_item (timer.elapsed_millisecs)
			end
		end

	benchmark_managed_pointer (elapsed_millisecs: DOUBLE_REF; pass_count: INTEGER_REF): PRIME_NUMBER_SIEVE_2
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			from timer.start until elapsed_millisecs > Time_limit loop
				create Result.make (Sieve_size)
				Result.execute
				pass_count.set_item (pass_count.item + 1)
				elapsed_millisecs.set_item (timer.elapsed_millisecs)
			end
		end

feature {NONE} -- Implementation

	print_results (command: PRIME_NUMBER_COMMAND; duration: DOUBLE; pass_count: INTEGER)
		do
			lio.put_labeled_string ("Implementation method", command.name)
			lio.put_new_line
			lio.put_substitution (
				Results_template, [pass_count, Double.formatted (duration), Double.formatted (duration / pass_count),
				sieve_size, command.prime_count, command.is_valid]
			)
			lio.put_new_line_x2
		end

	new_method_list: ARRAY [FUNCTION [DOUBLE_REF, INTEGER_REF, PRIME_NUMBER_COMMAND]]
		do
			Result := <<
				agent benchmark_managed_pointer, agent benchmark_to_special,
				agent benchmark_cpp_vector, agent benchmark_bit_shifting
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Benchmark calculation of primes using the the sieve of Eratosthenes method"

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 3)
			Result.no_justify
		end

	Time_limit: DOUBLE = 5000.0

	Sieve_size: INTEGER = 1_000_000

	Results_template: ZSTRING
		once
			Result := "Passes: %S, Time: %S, Avg: %S, Limit: %S, Count: %S, Valid: %S"
		end
end