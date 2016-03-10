note
	description: "Summary description for {ZSTRING_BENCHMARK_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-03 18:30:03 GMT (Thursday 3rd March 2016)"
	revision: "6"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_FACTORY_CLIENT

	MODULE_HEXAGRAM

	EL_MODULE_UTF

	EL_SHARED_ZCODEC

	BENCHMARK_ROUTINES

create
	make

feature {NONE} -- Initialization

	initialize
		local
			l_codec: INTEGER_REF

		do
			log.enter ("initialize")
			create l_codec
			Args.set_integer_from_word_option ("codec", agent l_codec.set_item, 1)
			inspect l_codec.item
				when 1 then
					set_system_codec (create {EL_ISO_8859_1_ZCODEC}.make)
				when 15 then
					set_system_codec (create {EL_ISO_8859_15_ZCODEC}.make)
			else
			end
			create number_of_runs
			Args.set_integer_from_word_option ("runs", agent number_of_runs.set_item, 100)
			if Execution_environment.is_work_bench_mode then
				number_of_runs := 1
			end
			create routine_filter.make_empty
			Args.set_string_from_word_option ("filter", agent routine_filter.copy, "")

			call (Hexagram)
			create benchmark_html.make_from_file (Output_path #$ [system_codec.id])
			log.exit
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			log_or_io.put_integer_field ("Codec is latin", system_codec.id)
			log_or_io.put_new_line
			log_or_io.put_integer_field ("Runs per test", Number_of_runs)
			log_or_io.put_new_line
			log_or_io.put_new_line

			do_latin_encoding_tests
			do_mixed_encoding_tests

			benchmark_html.serialize

			log.exit
		end

feature {NONE} -- Implementation

	do_latin_encoding_tests
		local
			benchmark: like new_benchmark
		do
			benchmark := new_benchmark
			benchmark.zstring.do_latin_encoding_performance_tests
			benchmark.string_32.do_latin_encoding_performance_tests
			benchmark_html.performance_tables.extend (
				create {PERFORMANCE_BENCHMARK_TABLE}.make_pure (system_codec.id, benchmark.string_32, benchmark.zstring)
			)

			benchmark.zstring.do_latin_encoding_memory_tests
			benchmark.string_32.do_latin_encoding_memory_tests
			benchmark_html.memory_tables.extend (
				create {MEMORY_BENCHMARK_TABLE}.make_pure (system_codec.id, benchmark.string_32, benchmark.zstring)
			)
		end

	do_mixed_encoding_tests
		local
			benchmark: like new_benchmark
		do
			benchmark := new_benchmark
			benchmark.zstring.do_mixed_encoding_performance_tests
			benchmark.string_32.do_mixed_encoding_performance_tests
			benchmark_html.performance_tables.extend (
				create {PERFORMANCE_BENCHMARK_TABLE}.make_mixed (system_codec.id, benchmark.string_32, benchmark.zstring)
			)

			benchmark.zstring.do_mixed_encoding_memory_tests
			benchmark.string_32.do_mixed_encoding_memory_tests
			benchmark_html.memory_tables.extend (
				create {MEMORY_BENCHMARK_TABLE}.make_mixed (system_codec.id, benchmark.string_32, benchmark.zstring)
			)
		end

	new_benchmark: TUPLE [string_32: STRING_32_BENCHMARK; zstring: ZSTRING_BENCHMARK]
		do
			Result := [
				create {STRING_32_BENCHMARK}.make (Number_of_runs, routine_filter),
				create {ZSTRING_BENCHMARK}.make (Number_of_runs, routine_filter)
			]
		end

feature {NONE} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

	number_of_runs: INTEGER_REF

	routine_filter: ZSTRING

feature {NONE} -- Constants

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{ZSTRING_BENCHMARK_APP}, All_routines],
				[{STRING_32_BENCHMARK}, All_routines],
				[{ZSTRING_BENCHMARK}, All_routines]
			>>
		end

	Option_name: STRING = "zstring_benchmark"

	Output_path: ZSTRING
		once
			Result := "workarea/ZSTRING-benchmarks-latin-%S.html"
		end

end
