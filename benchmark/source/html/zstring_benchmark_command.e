note
	description: "Zstring benchmark command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 14:25:40 GMT (Thursday 13th January 2022)"
	revision: "6"

class
	ZSTRING_BENCHMARK_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_ZSTRING_CODEC

feature {EL_COMMAND_CLIENT} -- Initialization

	make (output_dir: DIR_PATH; a_number_of_runs: INTEGER; filter: ZSTRING)
		local
			h: like Hexagram
		do
			number_of_runs := a_number_of_runs; routine_filter := filter
			h := Hexagram
			create benchmark_html.make ("doc/benchmark/ZSTRING-benchmarks.evol", output_dir + Output_name #$ [codec.id])
		end

feature -- Constants

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

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
		local
			list: EL_ARRAYED_LIST [STRING_BENCHMARK]
		do
			create list.make_from_tuple (benchmark)
			list.do_all (agent {STRING_BENCHMARK}.execute)

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