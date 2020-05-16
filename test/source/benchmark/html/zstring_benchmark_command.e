note
	description: "Zstring benchmark command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-15 10:08:04 GMT (Friday 15th May 2020)"
	revision: "1"

class
	ZSTRING_BENCHMARK_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_ZSTRING_CODEC

feature {EL_COMMAND_CLIENT} -- Initialization

	make (output_dir: EL_DIR_PATH; a_number_of_runs: INTEGER; filter: ZSTRING)
		local
			h: like Hexagram
		do
			number_of_runs := a_number_of_runs; routine_filter := filter
			h := Hexagram
			create benchmark_html.make ("doc/benchmark/ZSTRING-benchmarks.evol", output_dir + Output_name #$ [codec.id])
		end

feature -- Basic operations

	execute
		do
			lio.put_labeled_string ("{ZSTRING}.codec", codec.name)
			lio.put_new_line
			lio.put_integer_field ("Runs per test", number_of_runs)
			lio.put_new_line
			lio.put_new_line

			add_benchmarks ([
				create {ZSTRING_BENCHMARK}.make (Current),
				create {STRING_32_BENCHMARK}.make (Current)
			])
			add_benchmarks ([
				create {MIXED_ENCODING_ZSTRING_BENCHMARK}.make (Current),
				create {MIXED_ENCODING_STRING_32_BENCHMARK}.make (Current)
			])

			benchmark_html.serialize
		end

feature {NONE} -- Implementation

	add_benchmarks (benchmark: TUPLE [STRING_BENCHMARK, STRING_BENCHMARK])
		do
			benchmark_html.performance_tables.extend (create {PERFORMANCE_BENCHMARK_TABLE}.make (codec.id, benchmark))
			benchmark_html.memory_tables.extend (create {MEMORY_BENCHMARK_TABLE}.make (codec.id, benchmark))
		end

feature {STRING_BENCHMARK} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

	number_of_runs: INTEGER

	routine_filter: ZSTRING

feature {NONE} -- Constants

	Output_name: ZSTRING
		once
			Result := "ZSTRING-benchmarks-latin-%S.html"
		end

end
