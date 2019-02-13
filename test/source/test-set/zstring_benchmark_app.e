note
	description: "Zstring benchmark app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 13:28:28 GMT (Wednesday 13th February 2019)"
	revision: "6"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_HEXAGRAM

	EL_SHARED_ZCODEC

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
			lio.put_integer_field ("Codec is latin", system_codec.id)
			lio.put_new_line
			lio.put_integer_field ("Runs per test", Number_of_runs)
			lio.put_new_line
			lio.put_new_line

			add_benchmarks ([
				create {ZSTRING_BENCHMARK}.make (Number_of_runs, routine_filter),
				create {STRING_32_BENCHMARK}.make (Number_of_runs, routine_filter)
			])
			add_benchmarks ([
				create {MIXED_ENCODING_ZSTRING_BENCHMARK}.make (Number_of_runs, routine_filter),
				create {MIXED_ENCODING_STRING_32_BENCHMARK}.make (Number_of_runs, routine_filter)
			])

			benchmark_html.serialize

			log.exit
		end

feature {NONE} -- Implementation

	add_benchmarks (benchmark: like Type_benchmark_table.benchmark)
		do
			benchmark_html.performance_tables.extend (create {PERFORMANCE_BENCHMARK_TABLE}.make (system_codec.id, benchmark))
			benchmark_html.memory_tables.extend (create {MEMORY_BENCHMARK_TABLE}.make (system_codec.id, benchmark))
		end

feature {NONE} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

	number_of_runs: INTEGER_REF

	routine_filter: ZSTRING

feature {NONE} -- Type definition

	Type_benchmark_table: BENCHMARK_TABLE
		require
			never_called: False
		once
		end

feature {NONE} -- Constants

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ZSTRING_BENCHMARK_APP}, All_routines],
				[{STRING_32_BENCHMARK}, All_routines],
				[{ZSTRING_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_STRING_32_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_ZSTRING_BENCHMARK}, All_routines]
			>>
		end

	Option_name: STRING = "zstring_benchmark"

	Output_path: ZSTRING
		once
			Result := "workarea/ZSTRING-benchmarks-latin-%S.html"
		end

end
